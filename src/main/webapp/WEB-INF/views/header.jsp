<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 공통 헤더: 상단 네비게이션 바만 -->
<!-- 필요하면 css 링크, 아이콘 CDN 추가 가능 -->



<header>
<!-- Bootstrap CSS & JS (팝오버) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <nav class="top-nav">
    <div class="logo-section">
      <a href="/"><img src="${pageContext.request.contextPath}/logo.png" alt="logo"></a>
    </div>
    <ul class="nav-tabs">
      <li class="main-menu"><a href="/mypage/">마이페이지</a></li>
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
    <span><button id="alertBtn" type="button"
                  class="btn btn-secondary"
                  data-bs-toggle="popover"
                  data-bs-html="true"
                  data-bs-placement="bottom"
                  title="알림">
              🔔
          </button></span>
      <span class="icon">✉️</span>
    </div>
  </nav>

  <!-- 알림 팝오버 스크립트 -->
  <script>
  document.addEventListener("DOMContentLoaded", function () {
      const alerts = [
          <c:forEach var="n" items="${notifyList}">
              "${n.content}",
          </c:forEach>
      ];
      const contentHtml = "<ul class='list-unstyled mb-0'>" +
          alerts.map(a => `<li>${a}</li>`).join("") +
          "</ul>";

      const alertBtn = document.getElementById("alertBtn");
      alertBtn.setAttribute("data-bs-content", contentHtml);

      new bootstrap.Popover(alertBtn);
  });
  </script>

</header>



