<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>관리자 마이페이지</title>

  <!-- libs -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

  <style>
    /* ========== Base ========== */
    :root{
      --bg:#F8F9FA;
      --card:#ffffff;
      --line:#EDEFF2;
      --text:#2B2F36;
      --muted:#6B7280;
      --brand:#FFB200;
      --hover:rgba(20,30,58,.06);
      --radius:16px;
      --shadow:0 6px 18px rgba(20,30,58,.08);
      --shadow-hover:0 10px 24px rgba(20,30,58,.12);
    }
    * { box-sizing:border-box; }
    html, body { height:100%; overflow:hidden; }
    body{
      margin:0; background:var(--bg);
      font-family:'Pretendard','Apple SD Gothic Neo',system-ui,-apple-system,Segoe UI,Arial,'Noto Sans KR',sans-serif;
      color:var(--text);
    }
    a { color:inherit; text-decoration:none; }
    .btn:focus, .form-control:focus, .icon-btn:focus{ box-shadow:none; }

    /* ========== Layout ========== */
    .mypage-layout{
      min-height:100vh;
      display:grid;
      grid-template-columns: 240px 1fr;
    }

    /* Sidebar (데스크톱에서만 sticky) */
    .sidebar{
      background:var(--card);
      border-right:1px solid var(--line);
      display:flex; flex-direction:column; align-items:center;
      padding:28px 18px;
    }
    @media (min-width: 992px){
      .sidebar{ position:sticky; top:0; height:100vh; }
    }

    .profile-img{
      width:84px; height:84px; border-radius:50%;
      background:#ddd url('https://img.icons8.com/ios-glyphs/60/000000/user.png') center/48px no-repeat;
      object-fit:cover; cursor:pointer;
      box-shadow: inset 0 0 0 1px #e9ecef;
    }
    .profile-name{
      margin-top:10px; font-weight:700; font-size:1.05rem; text-align:center;
      word-break:keep-all;
    }
    .profile-edit-btn, .logout-btn{
      background:#f4f6f8; border:1px solid #E7E9ED; color:#4B5563;
      padding:8px 14px; border-radius:10px; font-size:.92rem;
      transition:.15s ease-in-out; margin-top:8px;
    }
    .profile-edit-btn:hover, .logout-btn:hover{ background:#eef1f5; color:#111827; }

    .sidebar-bottom{
      margin-top:auto; width:100%;
      display:flex; flex-direction:column; align-items:center; gap:10px;
      padding-top:18px;
    }

    /* Header */
    .main-header{
      height:64px; background:#E9ECEF;
      display:flex; align-items:center; justify-content:flex-end;
      padding:0 24px; border-bottom:1px solid var(--line);
    }
    .icon-btn{
      background:transparent; border:0; font-size:22px; color:#374151;
      padding:6px 10px; margin-left:10px; border-radius:10px; position:relative;
      transition: background .15s ease-in-out, transform .05s ease-in-out;
    }
    .icon-btn:hover{ background:rgba(0,0,0,.05); }
    .icon-btn:active{ transform:translateY(1px); }

    /* Content */
    .mypage-main{ display:flex; flex-direction:column; min-width:0; }

    /* 기본 패딩은 작게, 데스크톱에서만 넉넉하게 */
    .main-board{
      padding:24px;
      display:grid; gap:22px;
      grid-auto-rows:auto;
    }
    @media (min-width:1200px){
      .main-board{ padding:100px 170px; }
    }

    /* ========== Cards ========== */
    .card{
      border:none; border-radius:var(--radius);
      background:var(--card);
      box-shadow:var(--shadow);
      transition: box-shadow .2s ease, transform .12s ease;
    }
    .card:hover{ box-shadow:var(--shadow-hover); }

    /* Dashboard rows -> grid, auto-fit (좁은 폭에서도 빨리 1열로 전환) */
    .dashboard-row{
      display:grid; gap:20px;
      grid-template-columns: repeat(auto-fit, minmax(260px,1fr));
    }

    /* Link-card: 아이콘+텍스트 한 줄 중앙정렬 */
    .link-card{
      padding:18px;
      display:flex; align-items:center; justify-content:center; gap:12px;
      position:relative; overflow:hidden;
    }
    .link-card img{ width:34px; height:34px; flex:0 0 34px; }
    .link-card span{ font-weight:600; letter-spacing:.2px; }

    .link-card::after{
      content:""; position:absolute; inset:0;
      background:linear-gradient(120deg, transparent 0%, rgba(255,255,255,.5) 40%, transparent 80%);
      transform:translateX(-120%); transition:transform .6s ease;
    }
    .link-card:hover::after{ transform:translateX(120%); }

    /* Section titles */
    .section-title{ font-weight:700; font-size:1rem; margin-bottom:10px; }

    /* News (내 소식) */
    .news-card .scroll-area{ min-height: 170px; }            /* 콘텐츠 높이 기준 */
    .news-card .notification-list{
      min-height: 140px;
    }
    .news-card .notification-list .empty-center{ flex: 1; }
    /* 게시물 승인/삭제 카드도 동일하게 */
    .list-group.mt-2{
      margin-top: 0 !important;     /* 상단 밀림 제거 */
      max-height: 240px;            /* 필요 시 스크롤 */
      overflow-y: auto;
      min-height: 140px;            /* 빈 상태 기준 높이 */
    }

    .list-group.mt-2 .empty-center{ flex: 1; }
    .notification-item{
      padding:10px 0; border-bottom:1px dashed #ECEFF3; font-size:.95rem;
      display:flex; align-items:flex-start; justify-content:space-between; gap:10px;
    }
    .notification-item:last-child{ border-bottom:0; }

    /* Pending moderation list */
    .list-group .list-group-item{
      border:1px solid #EEF1F5; border-radius:12px !important;
      box-shadow: 0 1px 6px rgba(20,30,58,.04);
    }
    .badge.user{ background:#EEF2FF; color:#4338CA; font-weight:600; }

    .btn-warning.btn-sm{ background:var(--brand); border-color:var(--brand); color:#111; }
    .btn-warning.btn-sm:hover{ filter:brightness(.98); }
    .btn-outline-danger.btn-sm{ border-width:1.5px; }

    /* 카드 안 CTA 버튼: 길고 중앙정렬 */
    .card .center-btn{
      display:block; width:160px; max-width:70%;
      margin:12px auto 0; text-align:center;
    }

    /* 모바일/태블릿에서만 가로 배치 */
    @media (max-width: 992px){
      .mypage-layout{ grid-template-columns:1fr; }

      .sidebar{
        position:static; height:80px;
        border-right:none; border-bottom:1px solid var(--line);
        display:flex; flex-direction:row; align-items:center;
        justify-content:flex-start; gap:14px;
        background:#E9ECEF; padding:14px 16px;
        flex-wrap:nowrap;                 /* 줄바꿈 방지 */
      }

      /* 프로필 폼: 이미지와 이름을 가로로 */
      .sidebar form{
        display:flex; flex-direction:row; align-items:center; gap:10px;
        width:auto;                       /* 데스크톱의 width:100% 영향 차단 */
        margin:0;
      }

      .profile-img{ width:56px; height:56px; }
      .profile-name{ margin:0 0 0 8px; font-size:1rem; text-align:left; }

      /* 로그아웃: 이름 오른쪽에 바로 붙임 */
      .sidebar-bottom{
        display:flex; align-items:center; justify-content:flex-start;
        width:auto; margin:0 0 0 12px; padding:0;  /* 이름-버튼 간격 조절 */
      }
      .logout-btn{ margin:0; }

      .main-header{ display:none; }
      .main-board{ padding:16px; }
    }


    /* 카드 빈 상태 문구 전용 중앙 정렬 */
    .empty-center{
      display:flex;
      align-items:center;
      justify-content:center;
      text-align:center;
      color: var(--muted);
      min-height: 140px;    /* 120~160px 사이로 취향껏 */
    }

    /* 카드 높이만 컴팩트하게 */
    .compact-card{ padding:16px !important; }          /* p-4(=24px) → 16px로 줄임 */

    /* 문구 중앙은 유지하면서 전체 높이 낮춤 */
    .compact-card .scroll-area{ max-height:160px; }    /* 내용 많으면 스크롤 */
    .compact-card .notification-list{ min-height:120px; }
    .compact-card .list-group{
      margin-top:0 !important;
      max-height:160px;
      min-height:120px;
      overflow-y:auto;
    }

    /* 빈 상태 문구 높이(문구가 카드 안에서 중앙 유지용) */
    .compact-card .empty-center{
      min-height:120px;         /* 필요하면 100~140px로 더 조절 가능 */
    }

  </style>

  <!-- scripts -->
  <script src="https://kit.fontawesome.com/65ecdc8e2b.js" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
<c:if test="${not empty editSuccess}">
  <script>alert('${editSuccess}');</script>
</c:if>

<div class="mypage-layout">
  <!-- Sidebar -->
  <aside class="sidebar">
    <form action="/profile/upload" method="post" enctype="multipart/form-data"
          style="display:flex; align-items:center;">
      <label for="profileImgInput" style="cursor:pointer;">
        <img src="https://img.icons8.com/ios-glyphs/60/000000/user.png" class="profile-img" id="profileImgPreview" alt="프로필 이미지">
      </label>
      <input type="file" name="profileImg" id="profileImgInput" accept="image/*" style="display:none;" onchange="previewProfileImg(event)">
      <div class="profile-name">관리자</div>
    </form>

    <div class="sidebar-bottom">
      <button class="logout-btn" onclick="location.href='/logout'">로그아웃</button>
    </div>
  </aside>

  <!-- Main -->
  <div class="mypage-main">
    <div class="main-header">
      <button class="icon-btn" title="알림"><i class="fas fa-bell"></i></button>
      <button class="icon-btn" title="쪽지"><i class="fas fa-envelope"></i></button>
    </div>

    <div class="main-board">
      <!-- row 1 -->
      <div class="dashboard-row">
        <div class="card link-card">
          <a href="/free" class="stretched-link"></a>
          <img src="https://img.icons8.com/color/48/speech-bubble--v1.png" alt="">
          <span>소통 커뮤니티</span>
        </div>
        <div class="card link-card">
          <a href="/flag" class="stretched-link"></a>
          <img src="https://img.icons8.com/color/48/faq.png" alt="">
          <span>제보 및 신고 커뮤니티</span>
        </div>
      </div>

      <!-- row 2 -->
      <div class="dashboard-row">
        <div class="card link-card">
          <a href="/info" class="stretched-link"></a>
          <img src="https://img.icons8.com/color/48/police-badge.png" alt="">
          <span>아동 범죄 예방 게시판</span>
        </div>
        <div class="card link-card">
          <a href="/map/" class="stretched-link"></a>
          <img src="https://img.icons8.com/color/48/worldwide-location.png" alt="">
          <span>어린이 범죄 예방 지도</span>
        </div>
      </div>

      <!-- row 3 -->
      <div class="dashboard-row">
        <div class="card p-4 d-flex flex-column justify-content-between">
          <div class="section-title">재학증명서 처리</div>
          <a href="/cert/admin/list" class="btn btn-warning btn-sm center-btn">바로가기</a>
        </div>
        <div class="card p-4 d-flex flex-column justify-content-between">
          <div class="section-title">신고 글 접수</div>
          <a href="/report/list" class="btn btn-danger btn-sm center-btn">바로가기</a>
        </div>
      </div>

      <!-- row 4 -->
      <div class="dashboard-row">
        <!-- 내 소식 -->
        <div class="card p-4 news-card compact-card">
          <div class="section-title d-flex align-items-center gap-2">
            <i class="fas fa-bell"></i><span>내 소식</span>
          </div>
          <div class="scroll-area">
            <div class="notification-list" id="notifyList">
              <%-- 서버에서 알림 아이템 주입 시 .notification-item 사용 --%>
              <div class="empty-center" <c:if test="${not empty notifyList}">style="display:none"</c:if>>
                <i class="fas fa-inbox fa-lg mb-2 d-block"></i>
                아직 알림이 없습니다.
              </div>
            </div>
          </div>
        </div>

        <!-- 승인/반려 -->
        <div class="card p-4 compact-card">
          <div class="section-title d-flex align-items-center gap-2">
            <i class="fas fa-check-square"></i><span>게시물 승인 및 삭제</span>
          </div>

          <div class="list-group mt-2" style="max-height:330px; overflow-y:auto;">
            <c:forEach var="post" items="${pendingList}">
              <div class="list-group-item d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                  <a href="/flag/${post.id}" class="fw-semibold text-decoration-none text-reset">${post.title}</a>
                  <span class="badge user">${post.nickname}</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                  <form method="post" action="${pageContext.request.contextPath}/admin/approve/${post.id}">
                    <button class="btn btn-warning btn-sm" type="submit">승인</button>
                  </form>
                  <form method="post" action="${pageContext.request.contextPath}/admin/reject/${post.id}">
                    <button class="btn btn-outline-danger btn-sm" type="submit">반려</button>
                  </form>
                </div>
              </div>
            </c:forEach>

            <c:if test="${empty pendingList}">
              <div class="empty-center">
                <i class="fas fa-check-circle fa-2x mb-2 d-block"></i>
                승인/반려할 게시물이 없습니다.
              </div>
            </c:if>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- scripts -->
<script>
  function previewProfileImg(e){
    const file = e.target.files?.[0];
    if(!file) return;
    const reader = new FileReader();
    reader.onload = (ev)=> document.getElementById('profileImgPreview').src = ev.target.result;
    reader.readAsDataURL(file);
  }
  function deleteNotify(id) {
    $.ajax({
      type: "POST",
      url: "/mypage/delete",
      data: { id: id },
      success: function() {
        alert("알림이 삭제되었습니다."); location.reload();
      },
      error: function() { alert("삭제 실패"); }
    });
  }
  document.addEventListener("DOMContentLoaded", function () {
    let alerts = [];
    document.querySelectorAll(".danger-alert").forEach(el => alerts.push(el.value));
    if (alerts.length > 0) {
      let html = alerts.join("<br>");
      const modalBody = document.querySelector("#dangerModal .modal-body");
      if(modalBody){ modalBody.innerHTML = html; }
      const modalEl = document.getElementById('dangerModal');
      if(modalEl){
        new bootstrap.Modal(modalEl, {}).show();
      }
    }
  });
</script>
</body>
</html>
