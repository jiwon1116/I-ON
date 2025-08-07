window.toggledLayers = {
  sexOffender: false,
  emergency: false,   // ← 이 key를 아래 switch 문과 일치시켜야 함
  safeHouse: false
};

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".main-menu").forEach(tab => {
    tab.addEventListener("click", () => {
      const type = tab.dataset.type;
      console.log("클릭된 타입:", type);

      toggledLayers[type] = !toggledLayers[type];

      switch (type) {
        case "sexoffender":
          toggleSexOffenderMarkers(toggledLayers[type]);
          break;
        case "emergencybell":
          toggleEmergencyMarkers(toggledLayers[type]);
          break;
        case "safehouse":
          toggleSafehouseMarkers(toggledLayers[type]);
          break;
      }

      // UI 강조
      document.querySelectorAll(".main-menu").forEach(m => m.classList.remove("active"));
      if (toggledLayers[type]) tab.classList.add("active");
    });
  });
});

function toggleEmergencyMarkers(checked) {
  if (checked) {
    window.loadEmergencyMarkersByBounds();
  } else {
    window.clearEmergencyMarkers();
  }
}

let safehouseMarkers = [];

window.clearSafehouseMarkers = function () {
  if (window.clusterer) {
    window.clusterer.removeMarkers(safehouseMarkers);
  }
  safehouseMarkers.forEach(mk => mk.setMap(null));
  safehouseMarkers = [];
};

// 안전지킴이집
window.loadSafehouseMarkersByBounds = function () {
  if (!window.map) return;

  const bounds = window.map.getBounds();
  const sw = bounds.getSouthWest();
  const ne = bounds.getNorthEast();

  const url = `/map/safehouse?minX=${sw.getLng()}&minY=${sw.getLat()}&maxX=${ne.getLng()}&maxY=${ne.getLat()}`;

  fetch(url)
    .then(res => res.json())
    .then(data => {
      console.log("✅ 범위 기반 safehouse 응답:", data);

      if (!data || !Array.isArray(data.list)) {
        console.error("❌ 안전지킴이집 응답 오류", data);
        return;
      }

      window.clearSafehouseMarkers();
      const newMarkers = [];

      data.list.forEach(item => {
        const lat = parseFloat(item.lcinfoLa);
        const lng = parseFloat(item.lcinfoLo);
        if (!lat || !lng) return;

        const mk = new kakao.maps.Marker({
          position: new kakao.maps.LatLng(lat, lng),
          map: window.map,
          image: new kakao.maps.MarkerImage(
            '/resources/img/safehouse-marker.png',
            new kakao.maps.Size(32, 32)
          ),
          title: item.bsshNm
        });

        const content = `
          <div class="custom-info-window">
            <strong>${item.bsshNm}</strong><br/>
            주소: ${item.adres} ${item.etcAdres || ""}<br/>
            전화: ${item.telno || "정보 없음"}<br/>
            분류: ${item.clNm}
          </div>`;

        const infoWindow = new kakao.maps.InfoWindow({ content });
        kakao.maps.event.addListener(mk, 'click', () => infoWindow.open(window.map, mk));

        safehouseMarkers.push(mk);
        newMarkers.push(mk);
      });

      if (window.clusterer && newMarkers.length > 0) {
        window.clusterer.addMarkers(newMarkers);
      }
    })
    .catch(err => console.error("❗ 안전지킴이집 로딩 실패", err));
};

function toggleSafehouseMarkers(checked) {
  if (checked) {
    window.loadSafehouseMarkersByBounds();
  } else {
    window.clearSafehouseMarkers();
  }
}

