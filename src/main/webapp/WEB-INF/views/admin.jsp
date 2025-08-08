<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background: #F8F9FA;
            margin: 0;
            font-family: 'Pretendard', 'Apple SD Gothic Neo', Arial, sans-serif;
        }
        .mypage-layout {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 220px;
            height: 100vh;
            background: #fff;
            border-right: 1.5px solid #eee;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 0;
        }
        .profile-img {
            width: 76px;
            height: 76px;
            border-radius: 50%;
            background: #ddd url('https://img.icons8.com/ios-glyphs/60/000000/user.png') center/48px no-repeat;
            margin-top: 50px;
            margin-bottom: 10px;
            object-fit: cover;
            cursor: pointer;
        }
        .profile-name {
            font-weight: 600;
            font-size: 1.08rem;
            color: #444;
            margin-bottom: 8px;
        }
        .profile-edit-btn, .logout-btn {
            border: none;
            background: #f8f9fa;
            color: #666;
            font-size: 0.92rem;
            border-radius: 7px;
            padding: 5px 15px;
            margin-top: 6px;
            cursor: pointer;
            transition: background 0.15s;
        }
        .profile-edit-btn:hover, .logout-btn:hover {
            background: #f1f1f1;
            color: #222;
        }
        .sidebar-bottom {
            margin-top: auto;
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-bottom: 34px;
        }
        .main-header {
            height: 64px;
            background: #D9D9D9;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 40px;
            border-bottom: 1.5px solid #eee;
        }
        .main-header .icon-btn {
            background: transparent;
            border: none;
            outline: none;
            font-size: 25px;
            margin-left: 18px;
            color: #333;
            cursor: pointer;
        }
        .main-header .icon-btn:focus {
            outline: none;
        }
        .mypage-main {
            flex: 1 1 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            overflow-x: auto;
        }
        .main-board {
            flex: 1 1 0;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            padding: 38px 40px 30px 40px;
        }
        .dashboard-row {
            display: flex;
            gap: 25px;
            margin-bottom: 18px;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(20,30,58,0.06);
            border: none;
        }
        .dashboard-row .card {
            flex: 1;
        }
        /* 도넛차트 스타일 */
        .donut-box canvas {
            margin-top: 18px;
            width: 220px !important;
            height: 220px !important;
            min-width: 50px !important;
            min-height: 50px !important;
        }
        .donut-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 180px;
        }
        .donut-labels {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-top: 12px;
            font-size: 15px;
        }
        .donut-label-dot {
            display: inline-block;
            width: 12px; height: 12px;
            border-radius: 6px;
            margin-right: 5px;
        }
        .donut-grade-badge {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 7px;
            font-size: 16px;
            font-weight: 600;
        }

        /* 게이지바 */
        .trust-gauge-wrap { margin-top: 16px; }
        .trust-gauge-bar-bg { width: 100%; height: 18px; background: #eee; border-radius: 9px; position: relative; overflow: hidden; }
        .trust-gauge-bar {
            height: 100%;
            background: #FFC112; /* 한 가지 색상으로! */
            border-radius: 9px 0 0 9px;
            width: 0;  /* JS에서 제어 */
            transition: width 0.9s cubic-bezier(.23,1.01,.32,1);
        }
        .trust-gauge-label { font-size: 0.93rem; text-align: right; margin-top: 4px;}

        @media (max-width: 1200px) {
            .main-board { padding: 18px 10px 18px 10px; }
        }
        @media (max-width: 900px) {
            .sidebar { display: none; }
            .main-board { padding: 7px;}
        }
    </style>
    <script src="https://kit.fontawesome.com/65ecdc8e2b.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <%--jQuery CDN 추가 --%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <c:if test="${not empty editSuccess}">
        <script>
            alert('${editSuccess}');
        </script>
    </c:if>
    <div class="mypage-layout">
        <%-- 왼쪽 사이드바 --%>
        <aside class="sidebar">
            <%-- 프로필 이미지 + 수정 --%>
            <form action="/profile/upload" method="post" enctype="multipart/form-data" style="display:flex; flex-direction:column; align-items:center; width:100%;">
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
        <%-- 오른쪽 영역(헤더+내용) --%>
        <div class="mypage-main">
            <div class="main-header">
                <button class="icon-btn" title="알림">
                    <i class="fas fa-bell"></i>
                </button>
                <button class="icon-btn" title="쪽지">
                    <i class="fas fa-envelope"></i>
                </button>
            </div>
            <%-- 메인 보드(카드 내용) --%>
            <div class="main-board">
                <div class="dashboard-row">
                    <div class="card p-4 d-flex align-items-center position-relative">
                        <a href="/free" class="stretched-link"></a>
                        <img src="https://img.icons8.com/color/48/speech-bubble--v1.png" class="me-3" width="34">
                        <span>소통 커뮤니티</span>
                    </div>
                    <div class="card p-4 d-flex align-items-center position-relative">
                        <a href="/flag" class="stretched-link"></a>
                        <img src="https://img.icons8.com/color/48/faq.png" class="me-3" width="34">
                        <span>제보 및 신고 커뮤니티</span>
                    </div>
                </div>
                <div class="dashboard-row">
                    <div class="card p-4 d-flex align-items-center position-relative">
                        <a href="/info" class="stretched-link"></a>
                        <img src="https://img.icons8.com/color/48/police-badge.png" class="me-3" width="34">
                        <span>아동 범죄 예방 게시판</span>
                    </div>
                    <div class="card p-4 d-flex align-items-center position-relative">
                        <a href="/map" class="stretched-link"></a>
                        <img src="https://img.icons8.com/color/48/worldwide-location.png" class="me-3" width="34">
                        <span>어린이 범죄 예방 지도</span>
                    </div>
                </div>
                <%-- 재학증명서 --%>
                <div class="dashboard-row">
                    <div class="card p-4">
                        <span>재학증명서 처리</span>
                         <a href="/#" class="btn btn-warning btn-sm mt-2">바로가기</a>
                    </div>
                    <div class="card p-4">
                        <span>신고 글 접수</span>
                        <a href="/myPost" class="btn btn-warning btn-sm mt-2">바로가기</a>
                    </div>

                </div>

                      <div class="dashboard-row">
                          <!-- 내 소식 -->
                          <div class="card p-4" style="flex:2">
                              <span>내 소식</span>
                              <div class="text-center text-muted py-5">
                                  <i class="fas fa-bell fa-2x mb-2"></i><br>
                                  <div class="notification-list" id="notifyList">
                                      <%-- 알림 내용 --%>
                                  </div>
                              </div>
                          </div>
                          <!-- 게시물 승인 및 삭제 -->
                          <div class="card p-4" style="flex:2">
                              <span>게시물 승인 및 삭제</span>
                              <div class="text-center text-muted py-5">
                                  <i class="fas fa-check-square fa-2x mb-2"></i><br>
                                  <span>승인/삭제할 게시물이 없습니다.</span>

                                  </div>
                              </div>

 <script>
    function deleteNotify(id) {
    $.ajax({
        type: "POST",
        url: "/myPage/delete",
        data: { id: id },
        success: function(response) {
            alert("알림이 삭제되었습니다.");
            location.reload();
        },
        error: function() {
            alert("삭제 실패");
        }
    });
}
 </script>
 <script>
    // 지역 위험 알림 모달
    document.addEventListener("DOMContentLoaded", function () {
        let alerts = [];
        document.querySelectorAll(".danger-alert").forEach(el => {
            alerts.push(el.value);
        });

         // 지역 위험 알림의 수
        if (alerts.length > 0) {
            let message = alerts.join("<br>");
            document.querySelector("#dangerModal .modal-body").innerHTML = message;
            let myModal = new bootstrap.Modal(document.getElementById('dangerModal'), {});
            myModal.show();
        }
    });
</script>


</body>
</html>