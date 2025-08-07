window.toggledLayers = {
  offender: false,
  emergencybell: false,
  safehouse: false
};

document.addEventListener("DOMContentLoaded", () => {
  const urlParams = new URLSearchParams(window.location.search);
  const initType = urlParams.get("type");

  // ✅ URL 파라미터 기반 마커 초기화
  if (initType && toggledLayers.hasOwnProperty(initType)) {
    toggledLayers[initType] = true;

    const targetTab = document.querySelector(`.main-menu[data-type="${initType}"]`);
    if (targetTab) targetTab.classList.add("active");

    // 지도가 초기화된 이후 실행
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

// ✅ 반드시 전역에 정의
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

