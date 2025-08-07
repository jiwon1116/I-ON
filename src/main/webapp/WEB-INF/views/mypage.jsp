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
    <style>
        body {
            background: #F8F9FA;
            margin: 0;
            font-family: 'Pretendard', 'Apple SD Gothic Neo', Arial, sans-serif;
        }
        .mypage-layout {
            display: flex;
            min-height: 100vh;     /* 한 화면 채우기 */
        }
        /* 사이드바 */
        .sidebar {
            width: 220px;
            height: 100vh;
            background: #fff;
            border-right: 1.5px solid #eee;
            display: flex;
            flex-direction: column;
            align-items: center;
            /* 중앙정렬 */
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
        /* 헤더 */
        .main-header {
            height: 64px;
            background: #D9D9D9;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 40px;
            border-bottom: 1.5px solid #eee;
            /* 고정 X */
            /* margin-left 없음! */
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
        /* 메인 */
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


         /* 알림창 */
        .notification-box {
            background-color: #ffffff;
            border-radius: 10px;
            padding: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            height: 300px; /* 적당한 높이로 조절 가능 */
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .notification-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 12px;
        }

        .notification-list {
            flex: 1;
            overflow-y: auto; /* 스크롤바 생김 */
            padding-right: 8px;
        }

        .notification-item {
            border-bottom: 1px solid #eee;
            padding: 8px 0;
        }

        .notify-header {
            display: flex;
            justify-content: space-between;
            font-weight: bold;
        }

        .notify-content {
            margin-top: 4px;
            color: #333;
        }

        .notify-date {
            margin-top: 4px;
            font-size: 12px;
            color: #888;
        }
        .notify-icon {
            margin-right: 6px;
        }
        .notify-header {
            font-weight: bold;
            display: flex;
            align-items: center;
        }


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
</head>
<body>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <c:if test="${not empty editSuccess}">
        <script>
            alert('${editSuccess}');
        </script>
    </c:if>
    <div class="mypage-layout">
        <!-- 왼쪽 사이드바 -->
        <aside class="sidebar">
            <!-- 프로필 이미지 + 수정 -->
            <form action="/profile/upload" method="post" enctype="multipart/form-data" style="display:flex; flex-direction:column; align-items:center; width:100%;">
                <label for="profileImgInput" style="cursor:pointer;">
                    <img src="https://img.icons8.com/ios-glyphs/60/000000/user.png" class="profile-img" id="profileImgPreview" alt="프로필 이미지">
                </label>
                <input type="file" name="profileImg" id="profileImgInput" accept="image/*" style="display:none;" onchange="previewProfileImg(event)">
                <div class="profile-name">${member.nickname}</div>
                <button type="button" class="profile-edit-btn mt-1" onclick="location.href='/edit'">회원 정보 수정하기</button>

            </form>
            <div class="sidebar-bottom">
                <button class="logout-btn" onclick="location.href='/logout'">로그아웃</button>
            </div>
        </aside>
        <!-- 오른쪽 영역(헤더+내용) -->
        <div class="mypage-main">
            <!-- 헤더 -->
            <div class="main-header">
                <button class="icon-btn" title="알림">
                    <i class="fas fa-bell"></i>
                </button>
                <button class="icon-btn" title="쪽지">
                    <i class="fas fa-envelope"></i>
                </button>
            </div>
            <!-- 메인 보드(카드 내용) -->
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


                 <!-- 자녀 등록 -->
                <div class="dashboard-row">
                    <div class="card p-4">
                        <span>자녀 등록</span>
                         <a href="/#" class="btn btn-warning btn-sm mt-2">
                                                        바로가기
                                                    </a>
                    </div>
                    <div class="card p-4">
                        <span>내가 작성한 글</span>
                        <a href="/myPost" class="btn btn-warning btn-sm mt-2">
                                바로가기
                            </a>
                    </div>
                    <div class="card p-4">
                        <span>내가 작성한 댓글</span>
                        <a href="/myComment" class="btn btn-warning btn-sm mt-2">
                                바로가기
                        </a>
                    </div>
                </div>
                <div class="dashboard-row">
                    <div class="card p-4" style="flex:2">
                        <span>내 소식</span>
                        <div class="text-center text-muted py-5">
                            <i class="fas fa-bell fa-2x mb-2"></i><br>
                           <div class="notification-list" id="notifyList">
                                  <c:forEach var="notify" items="${notifyList}">
                                      <div class="notification-item">
                                          <div class="notify-header">
                                              <span class="notify-icon">
                                                  <c:choose>
                                                      <c:when test="${notify.type == 'COMMENT'}">[댓글]</c:when>
                                                      <c:when test="${notify.type == 'DANGER_ALERT'}">[위험]</c:when>
                                                      <c:otherwise>[알림]</c:otherwise>
                                                  </c:choose>
                                              </span>
                                          </div>
                                          <div class="notify-content">${notify.content}</div>
                                          <div class="notify-date">
                                              <fmt:formatDate value="${notify.created_at}" pattern="yyyy-MM-dd HH:mm" />
                                          </div>
                                      </div>
                                  </c:forEach>
                               </div>
                        </div>
                    </div>


                    <div class="card p-4" style="flex:1; position:relative;">
                        <div class="d-flex align-items-center mb-2" style="gap: 10px;">
                            <span style="font-weight:600; font-size:1.08rem;">신뢰도 점수판</span>
                            <!-- 등급 배지 & 반짝 효과 -->
                            <span class="trust-grade-badge sparkle"
                                  style="margin-left:6px;">
                              ${trustScore.grade}
                            </span>
                            <!-- 모달 버튼 -->
                            <div class="mb-2">
                                <div class="progress" style="height:18px;">
                                  <div class="progress-bar
                                    <c:choose>
                                      <c:when test="${trustScore.grade eq '새싹맘'}">bg-success</c:when>
                                      <c:when test="${trustScore.grade eq '도토리맘'}">bg-warning</c:when>
                                      <c:when test="${trustScore.grade eq '캡숑맘'}">bg-danger</c:when>
                                    </c:choose>"
                                    role="progressbar"
                                    style="width: ${trustScore.totalScore >= 30 ? 100 : trustScore.totalScore >= 10 ? (trustScore.totalScore-10)*100/20 : trustScore.totalScore*100/10}%;"
                                    aria-valuenow="${trustScore.totalScore}" aria-valuemin="0" aria-valuemax="30">
                                    <c:choose>
                                      <c:when test="${fn:trim(trustScore.grade) eq '새싹맘'}">🌱</c:when>
                                      <c:when test="${fn:trim(trustScore.grade) eq '도토리맘'}">🥜</c:when>
                                      <c:when test="${fn:trim(trustScore.grade) eq '캡숑맘'}">👑</c:when>
                                    </c:choose>
                                  </div>
                                </div>
                                <div class="small text-end mt-1" style="color:#666;">
                                  <c:choose>
                                    <c:when test="${fn:trim(trustScore.grade) eq '캡숑맘'}">최고 등급 달성!</c:when>
                                    <c:when test="${fn:trim(trustScore.grade) eq '도토리맘'}">
                                      <span>캡숑맘까지 <b>${30-trustScore.totalScore}</b>점 남았어요!</span>
                                    </c:when>
                                    <c:when test="${fn:trim(trustScore.grade) eq '새싹맘'}">
                                      <span>도토리맘까지 <b>${10-trustScore.totalScore}</b>점 남았어요!</span>
                                    </c:when>
                                  </c:choose>
                                </div>
                            </div>

                        </div>
                        <div class="mt-3">
                            <div class="d-flex justify-content-between">
                                <span>제보 횟수</span>
                                <span style="color:#f6a623; font-size:1.1rem;">${trustScore.reportCount} 개</span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span>위탁 횟수</span>
                                <span style="color:#f6a623; font-size:1.1rem;">${trustScore.entrustCount} 개</span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span>댓글</span>
                                <span style="color:#f6a623; font-size:1.1rem;">${trustScore.commentCount} 개</span>
                            </div>
                            <div class="d-flex justify-content-between mt-2">
                                <span style="font-weight:500;">총점</span>
                                <span style="color:#2d63a3; font-weight:700;">${trustScore.totalScore} 점</span>
                            </div>
                        </div>
                    </div>

                    <!-- 모달은 기존대로 -->
                    <div class="modal fade" id="trustScoreModal" tabindex="-1" aria-labelledby="trustScoreModalLabel" aria-hidden="true">
                      <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h5 class="modal-title" id="trustScoreModalLabel">신뢰도 점수판 안내</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                          </div>
                          <div class="modal-body">
                            <ul style="padding-left: 1rem;">
                              <li><b>제보 횟수</b> : 신고/제보 게시판에 올린 게시글 수를 의미합니다.</li>
                              <li><b>위탁 횟수</b> : 위탁 게시판에 작성한 게시글 수를 의미합니다.</li>
                              <li><b>댓글</b> : 내가 단 댓글의 총 개수를 의미합니다.</li>
                              <li><b>총점</b> : 제보+위탁+댓글의 합산 점수입니다.</li>
                              <li><b>등급</b> : 총점에 따라 등급이 올라갑니다! <br>
                                  <span style="color:#40a048; font-weight:500;">새싹맘 (0~9점)</span>,
                                  <span style="color:#a8743d; font-weight:500;">도토리맘 (10~29점)</span>,
                                  <span style="color:#f6a623; font-weight:500;">캡숑맘 (30점 이상)</span>
                              </li>
                            </ul>
                            <div class="mt-2 text-secondary" style="font-size:0.98rem;">
                              신뢰도 점수판은 커뮤니티 활동의 활발함과 신뢰도를 시각적으로 보여줍니다.<br>
                              활동이 많을수록 별이 더 많이 채워집니다.
                            </div>
                          </div>
                          <div class="modal-footer">
                            <button type="button" class="btn btn-warning" data-bs-dismiss="modal">확인</button>
                          </div>
                        </div>
                      </div>
                    </div>


                </div>
            </div><!-- main-board -->
        </div><!-- mypage-main -->
    </div><!-- mypage-layout -->


</body>
</html>
