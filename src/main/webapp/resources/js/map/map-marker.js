let emergencyMarkers = [];

window.clearEmergencyMarkers = function () {
  if (window.clusterer) {
    window.clusterer.removeMarkers(emergencyMarkers);
  }
  emergencyMarkers.forEach(mk => mk.setMap(null));
  emergencyMarkers = [];
};

window.loadEmergencyMarkersByBounds = function () {
  if (!window.map) return;

  const bounds = window.map.getBounds();
  const sw = bounds.getSouthWest();
  const ne = bounds.getNorthEast();

  const url = `/map/emergencybell?swLat=${sw.getLat()}&swLng=${sw.getLng()}&neLat=${ne.getLat()}&neLng=${ne.getLng()}`;

  fetch(url)
    .then(res => res.json())
    .then(data => {
      console.log("📌 비상벨 마커 로딩됨:", data.length);
      window.clearEmergencyMarkers();

      const newMarkers = [];

      data.forEach(marker => {
        const { latitude, longitude } = marker;
        if (!latitude || !longitude || latitude === 0 || longitude === 0) return;

        const position = new kakao.maps.LatLng(latitude, longitude);

        // 전역에서 한 번만 정의
        const emergencyMarkerImage = new kakao.maps.MarkerImage(
          '/resources/img/emergencybell-marker.png',
          new kakao.maps.Size(32, 32)
        );

        // 이후 마커 생성 시 재사용
        const mk = new kakao.maps.Marker({
          position,
          image: emergencyMarkerImage
        });

        attachPopup(marker, mk, "emergency");
        emergencyMarkers.push(mk);
        newMarkers.push(mk);
      });

      if (window.clusterer && newMarkers.length > 0) {
        window.clusterer.addMarkers(newMarkers);  // ✅ 수정됨
      }
    })
    .catch(err => console.error("❗ 비상벨 마커 로딩 실패:", err));
};

// 안전지킴이집
let safehouseMarkers = [];

window.clearSafehouseMarkers = function () {
  if (window.clusterer) {
    window.clusterer.removeMarkers(safehouseMarkers);
  }
  safehouseMarkers.forEach(mk => mk.setMap(null));
  safehouseMarkers = [];
};

window.loadSafehouseMarkersByBounds = function () {
  if (!window.map) return;

  const bounds = window.map.getBounds();
  const sw = bounds.getSouthWest();
  const ne = bounds.getNorthEast();

  const url = `/map/safehouse?minX=${sw.getLng()}&minY=${sw.getLat()}&maxX=${ne.getLng()}&maxY=${ne.getLat()}`;

  fetch(url)
    .then(res => res.json())
    .then(data => {
      console.log("✅ 안전지킴이집 마커 로딩됨:", data);

      window.clearSafehouseMarkers(); // ✅ 여기가 문제였음

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

        attachPopup(item, mk, "safehouse");

        safehouseMarkers.push(mk);
        newMarkers.push(mk);
      });

      if (window.clusterer && newMarkers.length > 0) {
        window.clusterer.addMarkers(newMarkers);
      }
    })
    .catch(err => console.error("❗ 안전지킴이집 로딩 실패", err));
};

// 성범죄자 거주지
window.offenderMarkers = [];

window.clearOffenderMarkers = function () {
  if (window.clusterer && window.offenderMarkers.length) {
    window.clusterer.removeMarkers(window.offenderMarkers);
  }
  window.offenderMarkers.forEach(mk => mk.setMap(null));
  window.offenderMarkers = [];
};

window.loadOffenderMarkersByBounds = function () {
  console.log("📌 offender 마커 로딩 시작");

  // 전역 함수는 window로 호출
  window.clearOffenderMarkers();

  if (!window.map) return;

  const bounds = window.map.getBounds();
  const sw = bounds.getSouthWest();
  const ne = bounds.getNorthEast();

  const url = `/map/offender?swLat=${sw.getLat()}&swLng=${sw.getLng()}&neLat=${ne.getLat()}&neLng=${ne.getLng()}`;

  fetch(url)
    .then(res => {
      if (!res.ok) throw new Error(`HTTP 에러: ${res.status}`);
      return res.json();
    })
    .then(data => {
      console.log("📍 마커 응답:", data);

      let items = Array.isArray(data) ? data : (data ? [data] : []);
      if (!items.length) {
        console.warn("⚠️ items가 없음");
        return;
      }

      const newMarkers = [];

      // 마커 이미지(아이콘) 1번만 생성
      const offenderMarkerImage = new kakao.maps.MarkerImage(
        '/resources/img/offender-marker.png',
        new kakao.maps.Size(32, 32)
      );

      items.forEach(item => {
        const lat = parseFloat(item.la);
        const lng = parseFloat(item.lo);
        if (isNaN(lat) || isNaN(lng)) return;

        const mk = new kakao.maps.Marker({
          position: new kakao.maps.LatLng(lat, lng),
          image: offenderMarkerImage
          // ⚠️ map 옵션 넣지 않음: 클러스터러가 관리
        });

        attachPopup(item, mk, "offender");

        window.offenderMarkers.push(mk);
        newMarkers.push(mk);
      });

      if (window.clusterer && newMarkers.length > 0) {
        window.clusterer.addMarkers(newMarkers);
      } else {
        // 클러스터러가 없을 때도 보이도록 폴백
        newMarkers.forEach(mk => mk.setMap(window.map));
      }
    })
    .catch(err => console.error("❗ offender 마커 로딩 실패", err));
};


