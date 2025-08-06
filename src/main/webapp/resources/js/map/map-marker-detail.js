// 파일 상단에 추가
let currentInfoWindow = null;
let currentInfoTarget = null;

function attachPopup(marker, mk, type) {
  let content = "";

  switch (type) {
    case "emergency":
      content = `
        <div style="padding:5px;">
          📍 <strong>${marker.roadAddress || marker.jibunAddress}</strong><br/>
          🔁 연계방식: ${marker.linkType ?? '-'}<br/>
          👮 경찰연계: ${marker.policeLinked ?? '-'}<br/>
          ☎️ 관리기관 번호 :${marker.agencyPhone ?? '-'}
        </div>
      `;
      break;

    default:
      content = `<div>정보 없음</div>`;
      break;
  }

  // ✅ 이벤트 리스너 등록 (toggle 로직 포함)
  kakao.maps.event.addListener(mk, 'click', function () {
    // 같은 마커 클릭 → InfoWindow 닫기
    if (currentInfoWindow && currentInfoTarget === mk) {
      currentInfoWindow.close();
      currentInfoWindow = null;
      currentInfoTarget = null;
    } else {
      // 기존 열려있는 것 닫고, 새로 열기
      if (currentInfoWindow) currentInfoWindow.close();

      currentInfoWindow = new kakao.maps.InfoWindow({ content });
      currentInfoWindow.open(map, mk);
      currentInfoTarget = mk;
    }
  });
}
