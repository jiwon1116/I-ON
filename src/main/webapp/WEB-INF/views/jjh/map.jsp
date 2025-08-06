<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>안전지도</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

  <!-- 카카오 클러스터 -->
  <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=355b679f9ec17e7c677b8177cc2b3695&libraries=clusterer"></script>

  <!-- Custom JS -->
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
      height: calc(100vh - 60px - 45px); /* 헤더 + 토글버튼 영역 제외 */
    }

    #marker-controls {
      padding: 10px;
      background: #f8f8f8;
      border-top: 1px solid #ddd;
      text-align: center;
    }

    #marker-controls label {
      margin-right: 20px;
      font-weight: bold;
    }

    .main-menu.active {
      background-color: #fff;
      color: #000;
      border-radius: 5px;
    }

  </style>
</head>

<body>
<header>
  <nav class="top-nav">
    <div class="logo-section">
      <a href="/"><img src="${pageContext.request.contextPath}/logo.png" alt="logo"></a>
    </div>
    <ul class="nav-tabs">
      <li class="main-menu" data-type="crime">범죄 발생 지역</li>
      <li class="main-menu" data-type="sexoffender">성범죄자 거주지</li>
      <li class="main-menu" data-type="emergencybell">비상벨</li>
      <li class="main-menu" data-type="safehouse">안전 지킴이집</li>
    </ul>
    <div class="icons">
      <span class="icon">🔔</span>
      <span class="icon">✉️</span>
    </div>
  </nav>
</header>

<div id="map"></div>
</body>
</html>
