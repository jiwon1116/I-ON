(function () {
  const fallbackLat = 37.489996;
  const fallbackLon = 126.927081;

  function initMap(lat, lon) {
    const locPosition = new kakao.maps.LatLng(lat, lon);
    const mapContainer = document.getElementById("map");
    const mapOption = {
      center: locPosition,
      level: 2,
      maxLevel: 5,
      minLevel: 1
    };

    window.map = new kakao.maps.Map(mapContainer, mapOption);

    window.clusterer = new kakao.maps.MarkerClusterer({
      map: window.map,
      averageCenter: true,
      minLevel: 4,
      maxLevel: 5
    });

    kakao.maps.event.addListener(window.map, 'idle', () => {
      if (window.toggledLayers?.emergencybell) {
        window.loadEmergencyMarkersByBounds();
      }

      if (window.toggledLayers?.safehouse) {
        window.loadSafehouseMarkersByBounds();
      }

      if (window.toggledLayers?.offender) {
        window.loadOffenderMarkersByBounds();
      }
    });
  }

  // 위치 기반 지도 초기화
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const offsetLat = 0.0033;
        const offsetLon = 0.01285;
        initMap(pos.coords.latitude + offsetLat, pos.coords.longitude - offsetLon);
      },
      () => {
        console.warn("❗ 위치 실패, 기본 좌표로 지도 표시");
        initMap(fallbackLat, fallbackLon);
      }
    );
  } else {
    alert("이 브라우저는 위치 정보를 지원하지 않습니다.");
    initMap(fallbackLat, fallbackLon);
  }
})();
