function attachPopup(marker, mk, type) {
  let content = "";

  switch (type) {
    case "emergency":
      content = `
        <div style="padding:5px;">
          <strong>${marker.locationName}</strong><br/>
          📍 ${marker.roadAddress || marker.jibunAddress}<br/>
          🔁 연계방식: ${marker.linkType ?? '-'}<br/>
          👮 경찰연계: ${marker.policeLinked ?? '-'}<br/>
          ☎️ ${marker.agencyPhone ?? '-'}
        </div>
      `;
      break;

    case "cctv":
      content = `
        <div style="padding:5px;">
          <strong>${marker.locationName}</strong><br/>
          📍 ${marker.address}<br/>
          🎥 방향: ${marker.angle ?? '-'}<br/>
          📡 해상도: ${marker.resolution ?? '-'}
        </div>
      `;
      break;

    case "aed":
      content = `
        <div style="padding:5px;">
          <strong>${marker.locationName}</strong><br/>
          📍 ${marker.address}<br/>
          ⏰ 사용 가능 시간: ${marker.availableTime ?? '-'}<br/>
          🛠️ 설치 기관: ${marker.agency ?? '-'}
        </div>
      `;
      break;

    default:
      content = `<div>정보 없음</div>`;
      break;
  }

  const iw = new kakao.maps.InfoWindow({ content });
  kakao.maps.event.addListener(mk, 'click', () => iw.open(map, mk));
}
