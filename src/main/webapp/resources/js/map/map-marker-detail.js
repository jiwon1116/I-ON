(function addBubbleStyles(){
  const css = `
    .bubble {
      position: relative;
      max-width: 280px;
      padding: 10px 12px;
      border-radius: 14px;
      background: #fff;
      border: none;
      box-shadow: 0 6px 18px rgba(0,0,0,.12), 0 2px 6px rgba(0,0,0,.08);
      font-size: 13px;
      line-height: 1.45;
      color: #222;
    }
    /* 꼬리를 중앙으로 */
    .bubble::after {
      content: "";
      position: absolute;
      left: 50%;
      transform: translateX(-50%); /* 중앙 정렬 */
      bottom: -8px;
      width: 0; height: 0;
      border-width: 8px 7px 0 7px;
      border-style: solid;
      border-color: #fff transparent transparent transparent;
      filter: drop-shadow(0 -1px 0 rgba(0,0,0,.08));
    }
    .bubble .row { display: flex; gap: 6px; align-items: center; margin-top: 4px; white-space: nowrap; }
    .bubble .row:first-child { margin-top: 0; }
    .bubble .title { font-weight: 700; }
    .bubble .sub { opacity: .85; }
    .bubble .wrap { word-break: keep-all; overflow-wrap: anywhere; }
    @media (prefers-color-scheme: dark){
      .bubble { background: #1f2329; color: #e8e8e8; }
      .bubble::after { border-color: #1f2329 transparent transparent transparent; filter: none; }
    }
  `;
  const el = document.createElement('style');
  el.textContent = css;
  document.head.appendChild(el);
})();

let currentOverlay = null;
let currentOverlayTarget = null;

function attachPopup(marker, mk, type) {
  let content = "";

  switch (type) {
    case "emergency":
      content = `
        <div class="bubble">
          <div class="row wrap">📍 <span class="title">${marker.roadAddress || marker.jibunAddress}</span></div>
          <div class="row">🔁 <span class="sub">연계방식 :</span>&nbsp;${marker.linkType ?? '-'}</div>
          <div class="row">👮 <span class="sub">경찰연계 :</span>&nbsp;${marker.policeLinked ?? '-'}</div>
          <div class="row">☎️ <span class="sub">관리기관 번호 :</span>&nbsp;${marker.agencyPhone ?? '-'}</div>
        </div>`;
      break;

    case "safehouse":
      content = `
        <div class="bubble">
          <div class="row wrap">🏠 <span class="title">${marker.bsshNm}</span></div>
          <div class="row wrap">📍 <span class="sub">주소 :</span>&nbsp;${marker.adres} ${marker.etcAdres || ""}</div>
          <div class="row">☎️ <span class="sub">전화번호 :</span>&nbsp;${marker.telno || "정보 없음"}</div>
        </div>`;
      break;

    case "offender":
      content = `
        <div class="bubble">
          <div class="row">🏠 <span class="title">거주지</span></div>
          <div class="row wrap">📍 <span class="sub">주소 :</span>&nbsp;${marker.ctpvNm} ${marker.sggNm} ${marker.roadNm}</div>
        </div>`;
      break;

    default:
      content = `<div class="bubble">정보 없음</div>`;
  }

  kakao.maps.event.addListener(mk, 'click', function () {
    if (currentOverlay && currentOverlayTarget === mk) {
      currentOverlay.setMap(null);
      currentOverlay = null;
      currentOverlayTarget = null;
    } else {
      if (currentOverlay) currentOverlay.setMap(null);

      currentOverlay = new kakao.maps.CustomOverlay({
        position: mk.getPosition(),
        content: content,
        xAnchor: 0.5,
        yAnchor: 1.45,
        zIndex: 3
      });
      currentOverlay.setMap(window.map);
      currentOverlayTarget = mk;
    }
  });
}
