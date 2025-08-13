<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>범죄지역 지도</title>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol/ol.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

  <style>
    html, body {
      margin: 0;
      height: 100%;
      overflow:hidden;
    }
    #map {
      width: 100%;
      height: 100%;
    }
    #back {
      position: absolute;
      top: 10px;
      left: 10px;
      background: white;
      padding: 6px 12px;
      border-radius: 4px;
      font-weight: bold;
      z-index: 1000;
      cursor: pointer;
      box-shadow: 0 2px 6px rgba(0,0,0,0.2);
    }
  </style>
</head>
<body>
<header>
  <nav class="top-nav">
    <div class="logo-section">
      <a href="/"><img src="${pageContext.request.contextPath}/resources/img/logo.png" alt="logo"></a>
    </div>
    <ul class="nav-tabs">
          <li class="main-menu active">범죄 발생 지역</li>
          <!-- 파라미터 값으로 타입 받음 -->
          <li class="main-menu"><a href="${pageContext.request.contextPath}/map/?type=offender">성범죄자 거주지</a></li>
          <li class="main-menu"><a href="${pageContext.request.contextPath}/map/?type=emergencybell">비상벨</a></li>
          <li class="main-menu"><a href="${pageContext.request.contextPath}/map/?type=safehouse">안전 지킴이집</a></li>
        </ul>
        <div class="icons">
        </div>
  </nav>
</header>

<!-- 지도 컨테이너 -->
<div id="map"></div>

<script src="https://cdn.jsdelivr.net/npm/ol/dist/ol.js"></script>

<script>
  const apiKey = "9JDIMRL5-9JDI-9JDI-9JDI-9JDIMRL5G2";

  function createMap(centerCoords) {
    const map = new ol.Map({
      target: 'map',
      layers: [
        new ol.layer.Tile({
          source: new ol.source.OSM()
        }),
        new ol.layer.Image({
          source: new ol.source.ImageWMS({
            url: 'https://www.safemap.go.kr/openApiService/wms/getLayerData.do',
            params: {
              'LAYERS': 'A2SM_ODBLRCRMNLHSPOT_KID',
              'STYLES': 'A2SM_OdblrCrmnlHspot_Kid',
              'FORMAT': 'image/png',
              'TRANSPARENT': true,
              'apikey': apiKey
            },
            ratio: 1,
            serverType: 'geoserver',
            crossOrigin: 'anonymous'
          }),
          opacity: 0.7
        })
      ],
      view: new ol.View({
        center: ol.proj.fromLonLat(centerCoords),
        zoom: 18
      })
    });
  }

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const lat = pos.coords.latitude;
        const lon = pos.coords.longitude;
        createMap([lon, lat]);
      },
      () => {
        console.warn("❗ 위치 실패, 기본 좌표로 지도 표시");
        createMap([126.926972, 37.489999]);
      }
    );
  } else {
    alert("이 브라우저는 위치 정보를 지원하지 않습니다.");
    createMap([126.926972, 37.489999]);
  }
</script>

</body>
</html>
