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

        const markerImageUrl = "/resources/img/emergencybell-marker.png";
        const imageSize = new kakao.maps.Size(32, 32);
        const markerImage = new kakao.maps.MarkerImage(markerImageUrl, imageSize);

        const mk = new kakao.maps.Marker({
          position,
          image: markerImage
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
