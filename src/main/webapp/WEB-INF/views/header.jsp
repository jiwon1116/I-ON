<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 공통 헤더: 상단 네비게이션 바만 -->
<!-- 필요하면 css 링크, 아이콘 CDN 추가 가능 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
<!-- 또는 아래에 <style>로 바로 스타일링도 가능 -->
<style>
body {
  margin: 0;
  font-family: "Noto Sans KR", sans-serif;
  background-color: #fff8e7;
}

/* 네비게이션 바 */
.top-nav {
  background-color: #ffc727;
  padding: 0 24px;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  height: 60px;
  font-weight: bold;
  font-size: 14px;
  position: relative;
  z-index: 10;
}

.logo-section img {
  height: 36px;
}

.nav-tabs {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
}

/* 메인 메뉴 공통 */
.main-menu {
  position: relative;
  padding: 12px 24px;
  border-top-left-radius: 20px;
  border-top-right-radius: 20px;
  cursor: pointer;
  background-color: transparent;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.2s ease;
}

/* hover 시 텍스트 색상만 밝아짐 */
.main-menu:hover {
  color: #ffffffcc;
}

/* 활성 탭 */
.main-menu.active {
  background-color: white;
  color: #222;
  z-index: 2;
  margin-bottom: 0;
}

/* 서브 메뉴 */
.sub-menu {
  display: none;
  position: absolute;
  top: 100%;
  left: 0;
  width: 100%;
  box-sizing: border-box;
  background: #ffc727;
  list-style: none;
  padding: 8px 0;
  margin: 0;
  box-shadow: 0 6px 20px rgba(0,0,0,0.12);
  border-radius: 0 0 12px 12px;
  z-index: 5;
}

/* hover 시 서브 메뉴 보임 */
.main-menu:hover .sub-menu {
  display: block;
}

/* 서브 메뉴 항목 */
.sub-menu li {
  padding: 10px 16px;
  white-space: nowrap;
  font-size: 14px;
  color: #333;
  transition: color 0.2s;
  font-weight: 500;
  text-align: center;
}
.sub-menu li:hover {
  color: #000;
}

.icons {
  display: flex;
  gap: 16px;
  font-size: 20px;
  padding-bottom: 10px;
}

</style>
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
