<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>지도</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

  <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=355b679f9ec17e7c677b8177cc2b3695&libraries=clusterer"></script>

  <script src="${pageContext.request.contextPath}/resources/js/map/map-load.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/map/map-marker.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/map/map-toggle.js" defer></script>
  <script src="${pageContext.request.contextPath}/resources/js/map/map-marker-detail.js"></script>

  <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      overflow: hidden;
    }

    #map {
      width: 100vw;
      height: calc(100vh - 60px);
    }

    .custom-info-window {
        width: 350px;
        height: 90px;
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
      <li class="main-menu"><a href="/map/crime">범죄 발생 지역</a></li>
      <li class="main-menu" data-type="offender">성범죄자 거주지</li>
      <li class="main-menu" data-type="emergencybell">비상벨</li>
      <li class="main-menu" data-type="safehouse">안전 지킴이집</li>
    </ul>
    <div class="icons">
    </div>
  </nav>
</header>

<div id="map"></div>
</body>
</html>
