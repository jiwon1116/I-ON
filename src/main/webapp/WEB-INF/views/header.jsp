<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 공통 헤더: 상단 네비게이션 바만 -->
<!-- 필요하면 css 링크, 아이콘 CDN 추가 가능 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">


<header>
  <nav class="top-nav">
    <div class="logo-section">
      <img src="${pageContext.request.contextPath}/logo.png" alt="logo">
    </div>
    <ul class="nav-tabs">
      <li class="main-menu">마이페이지</li>
      <li class="main-menu">범죄 예방 지도</li>
      <li class="main-menu active">
        커뮤니티
        <ul class="sub-menu">
          <li>자유</li>
          <li>위탁</li>
          <li>실종 및 유괴</li>
        </ul>
      </li>
      <li class="main-menu">제보 및 신고</li>
      <li class="main-menu">정보 공유</li>
    </ul>
    <div class="icons">
      <span class="icon">🔔</span>
      <span class="icon">✉️</span>
    </div>
  </nav>
</header>
