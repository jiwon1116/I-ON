<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 공통 헤더: 상단 네비게이션 바만 -->
<!-- 필요하면 css 링크, 아이콘 CDN 추가 가능 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">


<header>
  <nav class="top-nav">
    <div class="logo-section">
      <a href="/"><img src="${pageContext.request.contextPath}/logo.png" alt="logo"></a>
    </div>
    <ul class="nav-tabs">
      <li class="main-menu"><a href="/myPage/">마이페이지</a></li>
      <li class="main-menu"><a href="/map">범죄 예방 지도</a></li>
      <li class="main-menu active">
        <a href="/free">커뮤니티</a>
        <ul class="sub-menu">
          <li><a href="/free">자유</a></li>
          <li><a href="/entrust">위탁</a></li>
          <li><a href="/miss">실종 및 유괴</a></li>
        </ul>
      </li>
      <li class="main-menu"><a href="/flag">제보 및 신고</a></li>
      <li class="main-menu"><a href="/info">정보 공유</a></li>
    </ul>
    <div class="icons">
      <span class="icon">🔔</span>
      <span class="icon">✉️</span>
    </div>
  </nav>
</header>
