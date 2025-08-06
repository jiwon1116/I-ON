let emergencyMarkers = [];

window.loadEmergencyMarkersByBounds = function () {
  if (!window.map) return;

  const bounds = window.map.getBounds();
  const sw = bounds.getSouthWest();
  const ne = bounds.getNorthEast();

  const url = `/map/emergencybell?swLat=${sw.getLat()}&swLng=${sw.getLng()}&neLat=${ne.getLat()}&neLng=${ne.getLng()}`;

  fetch(url)
    .then(res => res.json())
    .then(data => {
      window.clearEmergencyMarkers();

      const newMarkers = [];

      data.forEach(marker => {
        const { latitude, longitude } = marker;
        if (!latitude || !longitude || latitude === 0 || longitude === 0) return;

        const position = new kakao.maps.LatLng(latitude, longitude);

        const markerImageUrl = "/resources/img/emergencybell-marker.png";  // 마커 이미지 경로
        const imageSize = new kakao.maps.Size(32, 32);                     // 마커 이미지 크기
        const markerImage = new kakao.maps.MarkerImage(markerImageUrl, imageSize);

        const mk = new kakao.maps.Marker({
          position,
          image: markerImage
        });


        if (window.clusterer) {
          window.clusterer.addMarker(mk);
        }

        attachPopup(marker, mk, "emergency");
        emergencyMarkers.push(mk);
        newMarkers.push(mk);
      });

    })
    .catch(err => console.error("❗ 마커 로딩 실패", err));
};

// ✅ 이 함수가 없어서 에러 발생 중 → 아래 코드 추가
window.toggleEmergencyMarkers = function (checked) {
  if (checked) {
    window.loadEmergencyMarkersByBounds();
  } else {
    window.clearEmergencyMarkers();
  }
};

window.clearEmergencyMarkers = function () {
  if (window.clusterer) {
    window.clusterer.removeMarkers(emergencyMarkers);
  }
  emergencyMarkers.forEach(mk => mk.setMap(null));
  emergencyMarkers = [];
};
