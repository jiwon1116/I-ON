  const toggledLayers = {
    crime: false,
    sexOffender: false,
    emergency: false,
    safeHouse: false
  };

  document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".main-menu").forEach(tab => {
      tab.addEventListener("click", () => {
        const type = tab.dataset.type;
        console.log("클릭된 타입:", type);

        toggledLayers[type] = !toggledLayers[type];

        switch (type) {
          case "crime":
            toggleCrimeMarkers(toggledLayers[type]);
            break;
          case "sexOffender":
            toggleSexOffenderMarkers(toggledLayers[type]);
            break;
          case "emergencybell":
            toggleEmergencyMarkers(toggledLayers[type]);
            break;
          case "safeHouse":
            toggleSafeReturnMarkers(toggledLayers[type]);
            break;
        }

        // UI 강조
        document.querySelectorAll(".main-menu").forEach(m => m.classList.remove("active"));
        if (toggledLayers[type]) tab.classList.add("active");
      });
    });
  });
