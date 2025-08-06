window.toggledLayers = {
  sexOffender: false,
  emergency: false,   // ← 이 key를 아래 switch 문과 일치시켜야 함
  safeHouse: false
};

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".main-menu").forEach(tab => {
    tab.addEventListener("click", () => {
      const type = tab.dataset.type;
      console.log("클릭된 타입:", type);

      toggledLayers[type] = !toggledLayers[type];

      switch (type) {
        case "sexoffender":
          toggleSexOffenderMarkers(toggledLayers[type]);
          break;
        case "emergencybell":
          toggleEmergencyMarkers(toggledLayers[type]);
          break;
        case "safehouse":
          toggleSafeReturnMarkers(toggledLayers[type]);
          break;
      }

      // UI 강조
      document.querySelectorAll(".main-menu").forEach(m => m.classList.remove("active"));
      if (toggledLayers[type]) tab.classList.add("active");
    });
  });
});

function toggleEmergencyMarkers(checked) {
  if (checked) {
    window.loadEmergencyMarkersByBounds();
  } else {
    window.clearEmergencyMarkers();
  }
}