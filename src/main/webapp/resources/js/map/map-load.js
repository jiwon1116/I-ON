document.addEventListener("DOMContentLoaded", () => {
  if (!window.kakao) {
    console.error("Kakao script not loaded.");
    return;
  }

  kakao.maps.load(() => {
    const FIXED_LAT = 37.489999;
    const FIXED_LON = 126.926972;
    const INIT_LEVEL = 2;

    const mapContainer = document.getElementById("map");
    if (!mapContainer) {
      console.error("#map 요소를 찾을 수 없습니다.");
      return;
    }
    // 높이/너비 0 방지 (혹시 스타일 빠졌을 때)
    if (!mapContainer.offsetWidth || !mapContainer.offsetHeight) {
      mapContainer.style.width = "100%";
      mapContainer.style.height = "80vh";
    }

    const center = new kakao.maps.LatLng(FIXED_LAT, FIXED_LON);
    window.map = new kakao.maps.Map(mapContainer, {
      center,
      level: INIT_LEVEL,
      maxLevel: 5,
      minLevel: 1
    });

    // 클러스터러
    window.clusterer = new kakao.maps.MarkerClusterer({
      map: window.map,
      averageCenter: true,
      minLevel: 4,
      maxLevel: 5
    });

    // 첫 로딩에 화면 이동시키지 않고 데이터만 로드
    kakao.maps.event.addListener(window.map, "idle", () => {
      if (window.toggledLayers?.emergencybell) window.loadEmergencyMarkersByBounds?.();
      if (window.toggledLayers?.safehouse)     window.loadSafehouseMarkersByBounds?.();
      if (window.toggledLayers?.offender)      window.loadOffenderMarkersByBounds?.();
    });
  });
});
