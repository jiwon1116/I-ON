let emergencyMarkers = [];
let cctvMarkers = [];
let aedMarkers = [];
let safeReturnMarkers = [];

// clusterer는 map-load.js에서 생성되므로 전역에서 접근
// window.clusterer 사용 가정

function loadMarkers(apiUrl, markerArray, type, iconUrl = null) {
  fetch(apiUrl)
    .then(res => res.json())
    .then(data => {
      const newMarkers = [];

      data.forEach(marker => {
        if (!marker.latitude || !marker.longitude) {
          console.warn("좌표 누락 마커:", marker);
          return;
        }

        const position = new kakao.maps.LatLng(marker.latitude, marker.longitude);
        const markerOptions = { position };

        if (iconUrl) {
          markerOptions.image = new kakao.maps.MarkerImage(iconUrl, new kakao.maps.Size(32, 32));
        }

        const mk = new kakao.maps.Marker(markerOptions);
        attachPopup(marker, mk, type);

        markerArray.push(mk);
        newMarkers.push(mk);
      });

      // 클러스터러에 한 번에 추가
      if (window.clusterer) {
        window.clusterer.addMarkers(newMarkers);
      } else {
        console.warn("❗ clusterer가 아직 초기화되지 않았습니다.");
      }
    })
    .catch(err => console.error(`❗ Failed to load markers from ${apiUrl}`, err));
}

// 마커 제거 함수
function clearMarkers(markerArray) {
  if (window.clusterer) {
    window.clusterer.removeMarkers(markerArray);
  }
  markerArray.forEach(mk => mk.setMap(null));
  markerArray.length = 0;
}

// 마커 토글 함수들
function toggleEmergencyMarkers(checked) {
  console.log("비상벨 토글:", checked);
  checked
    ? loadMarkers("/map/emergencybell", emergencyMarkers, "emergency")
    : clearMarkers(emergencyMarkers);
}

function toggleCctvMarkers(checked) {
  checked
    ? loadMarkers("/api/map/cctv", cctvMarkers, "cctv")
    : clearMarkers(cctvMarkers);
}

function toggleAedMarkers(checked) {
  checked
    ? loadMarkers("/api/map/aed", aedMarkers, "aed")
    : clearMarkers(aedMarkers);
}

function toggleSafeReturnMarkers(checked) {
  checked
    ? loadMarkers("/api/map/safe-return", safeReturnMarkers, "safeReturn")
    : clearMarkers(safeReturnMarkers);
}

// 예: map-marker.js 하단에 추가
window.onMapReady = () => {
  toggleEmergencyMarkers(true); // 초기 표시할 마커
};
