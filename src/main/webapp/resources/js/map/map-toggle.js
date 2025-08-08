window.toggledLayers = {
  offender: false,
  emergencybell: false,
  safehouse: false
};

document.addEventListener("DOMContentLoaded", () => {
  const urlParams = new URLSearchParams(window.location.search);
  // 범죄지역 api지도에서 기존 지도로 이동시 선택한 토글 on 하기 위한 타입받는 변수
  const initType = urlParams.get("type");

  // initType이 존재한다면(범죄지역 api 제외 다른 토글 버튼들 의미)
  if (initType && toggledLayers.hasOwnProperty(initType)) {
    toggledLayers[initType] = true; // 마커 켠 상태로 유지함

    const targetTab = document.querySelector(`.main-menu[data-type="${initType}"]`); // jsp 파일에서 data-type 받아둠
    if (targetTab) targetTab.classList.add("active"); // 클래스 active 추가함(토글 눌렀을 때 디자인 적용 위함)

    const interval = setInterval(() => {
      if (window.map) {
        clearInterval(interval);

        switch (initType) {
          case "offender":
            toggleOffenderMarkers(true);
            break;
          case "emergencybell":
            toggleEmergencyMarkers(true);
            break;
          case "safehouse":
            toggleSafehouseMarkers(true);
            break;
        }
      }
    }, 200);
  }

  // 초기 타입 받는 것 제외하고 map.jsp에서 바로 토글 눌렀을 때의 이벤트 처리
  document.querySelectorAll('.main-menu[data-type]').forEach(link => {
    const type = link.dataset.type;

    link.addEventListener("click", (e) => {
      e.preventDefault();

      toggledLayers[type] = !toggledLayers[type];
      link.classList.toggle("active", toggledLayers[type]);

      switch (type) {
        case "offender":
          toggleOffenderMarkers(toggledLayers[type]);
          break;
        case "emergencybell":
          toggleEmergencyMarkers(toggledLayers[type]);
          break;
        case "safehouse":
          toggleSafehouseMarkers(toggledLayers[type]);
          break;
      }
    });
  });
});

// 토글 함수들 정의. on일 때 마커 표시/off일 때 마커 삭제
window.toggleEmergencyMarkers = function (checked) {
  if (checked) {
    window.loadEmergencyMarkersByBounds?.();
  } else {
    window.clearEmergencyMarkers?.();
  }
};

window.toggleSafehouseMarkers = function (checked) {
  if (checked) {
    window.loadSafehouseMarkersByBounds?.();
  } else {
    window.clearSafehouseMarkers?.();
  }
};

window.toggleOffenderMarkers = function (checked) {
  if (checked) {
    window.loadOffenderMarkersByBounds();
  } else {
    window.clearOffenderMarkers();
  }
};

