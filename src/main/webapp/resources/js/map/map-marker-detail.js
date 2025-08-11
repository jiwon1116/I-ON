// 상세보기 변수
let currentInfoWindow = null;
let currentInfoTarget = null;

// 상세보기 팝업창 변수
function attachPopup(marker, mk, type) {
  let content = "";

  // 각각의 타입 별로 상세보기 팝업 다르게 처리하기 위함
  switch (type) {
    case "emergency":
      content = `
        <div style="padding:5px;">
          📍 <strong>${marker.roadAddress || marker.jibunAddress}</strong><br/>
          🔁 연계방식 : ${marker.linkType ?? '-'}<br/>
          👮 경찰연계 : ${marker.policeLinked ?? '-'}<br/>
          ☎️ 관리기관 번호 : ${marker.agencyPhone ?? '-'}
        </div>
      `;
      break;

    case "safehouse":
      content = `
        <div class="custom-info-window">
          🏠 <strong>${marker.bsshNm}</strong><br/>
          📍 주소 : ${marker.adres} ${marker.etcAdres || ""}<br/>
          ☎️ 전화번호 : ${marker.telno || "정보 없음"}<br/>
        </div>`;
      break;

      case "offender":
        content = `
          <div class="custom-info-window">
            🏠 <strong>거주지</strong><br/>
            📍 주소 : ${marker.ctpvNm} ${marker.sggNm} ${marker.roadNm}<br/>
          </div>`;
        break;
    // 만약 주소 없는 경우
    default:
      content = `<div>정보 없음</div>`;
      break;
  }

  // 팝업 띄우기 위한 이벤트 처리
  kakao.maps.event.addListener(mk, 'click', function () {
    // 팝업이 이미 켜져 있는 경우 닫기
    if (currentInfoWindow && currentInfoTarget === mk) {
      currentInfoWindow.close();
      currentInfoWindow = null;
      currentInfoTarget = null;
    } else {
      // 기존 열려있는 것 닫고, 새로 열기(여러 마커 한 번에 팝업 띄우지 못하게 처리)
      if (currentInfoWindow) currentInfoWindow.close();

      currentInfoWindow = new kakao.maps.InfoWindow({ content });
      currentInfoWindow.open(window.map, mk);
      currentInfoTarget = mk;
    }
  });
}
