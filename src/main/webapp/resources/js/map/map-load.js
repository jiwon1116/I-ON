(function () {
  const fallbackLat = 37.489996; // 신림역 위도
  const fallbackLon = 126.927081; // 신림역 경도

  // 맵 초기화 콜백 등록용
  window.onMapReady = null;

  function initMap(lat, lon) {
    const locPosition = new kakao.maps.LatLng(lat, lon);
    const mapContainer = document.getElementById('map');
    const mapOption = {
      center: locPosition,
      level: 4
    };

    window.map = new kakao.maps.Map(mapContainer, mapOption);

    //  클러스터러도 함께 초기화
    window.clusterer = new kakao.maps.MarkerClusterer({
      map: window.map,
      averageCenter: true,
      minLevel: 10
    });

    //  지도와 클러스터러가 준비된 이후 실행
    if (typeof window.onMapReady === 'function') {
      window.onMapReady();
    }
  }

  // 이 부분이 바깥으로 빠져야 합니다!
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const lat = position.coords.latitude;
        const lon = position.coords.longitude;

        const offsetLat = 0.0033;
        const offsetLon = 0.01285;

        initMap(lat + offsetLat, lon - offsetLon);
      },
      (err) => {
        console.warn("위치 정보를 가져오지 못해 기본 위치로 대체합니다.");
        initMap(fallbackLat, fallbackLon);
      }
    );
  } else {
    alert("이 브라우저는 위치 정보를 지원하지 않습니다.");
    initMap(fallbackLat, fallbackLon);
  }
})();
