<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="now" class="java.util.Date" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <!-- 지역경보 모달을 위한 세션가져오기 -->
    <meta name="session-id" content="${pageContext.session.id}">
    <title>회원페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
      /* === 베이스 === */
      html, body {
        height: 100%;
        margin: 0;
        background: #F8F9FA;
        font-family: 'Pretendard','Apple SD Gothic Neo',Arial,sans-serif;
        overflow-x: hidden;
      }

      /* 레이아웃 */
      .mypage-layout { display:flex; min-height:100vh; }
      .mypage-main   { flex:1 1 0; display:flex; flex-direction:column; min-height:100vh; min-width:0; }

      /* 사이드바 */
      .sidebar{
        width:250px;
        background:#fff;
        border-right:1.5px solid #eee;
        display:flex;
        flex-direction:column;
        align-items:center;
        padding-top:36px;
      }
      .profile-img{
        width:72px; height:72px; border-radius:50%;
        object-fit:cover; margin-bottom:8px; cursor:pointer;
        background:#ddd url('https://img.icons8.com/ios-glyphs/60/000000/user.png') center/46px no-repeat;
      }
      .profile-name{ font-weight:600; font-size:1rem; color:#444; margin-bottom:6px; text-align:center; word-break:keep-all; }
      .profile-edit-btn, .logout-btn{
        display:inline-block;
        text-align:center;
        border:1px solid #e0e0e0;
        background:#f8f9fa;
        color:#666;
        font-size:.85rem;
        border-radius:10px;
        padding:6px 12px;
        margin-top:6px;
        cursor:pointer;
        transition:background .15s,color .15s;
      }
      .profile-edit-btn:hover, .logout-btn:hover{ background:#f1f1f1; color:#222; }
      .sidebar-bottom{ margin-top:auto; padding:18px 10px 32px; width:100%; text-align:center; }

      /* 상단 헤더 */
      .main-header{
        height:70px; flex:0 0 70px;
        background:#D9D9D9;
        display:flex; align-items:center; justify-content:flex-end;
        padding:0 16px; border-bottom:1.5px solid #eee;
      }
      .main-header .icon-btn{
        border:0; outline:0; background:transparent;
        font-size:22px; color:#333; padding:0 7px; margin-left:14px; cursor:pointer;
      }

      /* 메인 보드 (그리드 컨테이너) */
      .main-board{
        height:calc(100vh - 70px);
        display:grid;
        grid-template-rows:auto auto auto 1fr;
        row-gap:16px;
        padding:50px 200px;
        box-sizing:border-box;
        overflow:hidden;
      }

      /* 대시보드 행을 카드 2개 그리드로 정렬 */
      .dashboard-row{
        display:grid;
        grid-template-columns:repeat(2, 1fr);
        gap:16px;
        margin:0; /* 상하 여백은 main-board의 row-gap로 관리 */
      }

      /* 카드 공통 */
      .card{
        position:relative;
        background:#fff;
        border:none;
        border-radius:16px;
        box-shadow:0 4px 10px rgba(20,30,58,.06);
        padding:20px;
        display:flex; flex-direction:column;
      }
      .card.p-4{ padding:20px !important; } /* 기존 클래스 유지 호환 */

      /* 링크타일(아이콘+텍스트) 정렬 */
      .dashboard-row .card{
        display:flex; align-items:center; gap:10px;
      }
      .dashboard-row .card a.stretched-link{
        position:absolute; inset:0; border-radius:16px;
      }
      .dashboard-row .card img{ width:32px; height:32px; }
      .dashboard-row .card span{ font-size:15px; font-weight:500; color:#333; }

      /* 도넛/라벨/배지 */
      .donut-box{ width:100%; max-width:205px; margin:6px auto; display:flex; flex-direction:column; align-items:center; }
      .donut-box canvas{ width:100% !important; height:auto !important; aspect-ratio:1/1; display:block; margin-top:4px; }
      .donut-labels{
        display:flex; justify-content:center; gap:7px; flex-wrap:wrap;
        margin-top:6px; font-size:12px;
      }
      .donut-label-dot{ display:inline-block; width:8px; height:8px; border-radius:50%; margin-right:4px; }
      .donut-grade-badge{ font-size:.9rem; }

      #trustGaugeText{
        white-space: nowrap;
        display: block;
        width: 100%;
        text-align: center !important; /* .text-end 무력화 */
        margin: 6px 0 0 0;            /* 위로 살짝 붙임 */
        padding: 10px 0 0 0;
      }

    .donut-box .trust-gauge-wrap{
      text-align: center;           /* 부모 정렬 */
    }

    .btn.btn-warning.btn-sm {
      min-width: 400px;
      text-align: center; /* 텍스트 중앙 */
    }


      /* 래퍼가 230px로 묶여 있어 중앙이 틀어져 보였음 → 카드 너비 기준으로 정렬 */
      .trust-gauge-wrap{
        max-width: none !important;   /* inline max-width:230px 무시 */
        width: 100% !important;
        align-items: center;           /* 내부 요소 중앙 */
      }
    /* 게이지 바 컨테이너를 기준 박스로 지정 + 높이/배경 복원 */
    .trust-gauge-bar-bg{
      position: relative;          /* ★ 부모 기준 박스 */
      height: 10px;                 /* 막대 높이 */
      background: #e9ecef;
      border-radius: 999px;
      overflow: hidden;
      width: clamp(150px, 48%, 220px); /* 살짝 줄여 중앙 느낌 강화 */
      margin: 6px auto 4px;
      margin-top: 0;
    }

    /* 실제 채워지는 막대: 컨테이너 내부에서만 높이 차지 */
    .trust-gauge-bar{
      position: absolute;
      left: 0;
      top: 0;
      height: 100%;                /* 부모 높이만 사용 */
      width: 0;                    /* JS에서 %로 채움 */
      background: #ffc107;
      border-radius: 999px;
      transition: width .5s ease-in-out;
    }

      .trust-gauge-label{
        display:block; width:auto; align-self:center;
        margin:2px auto 0; text-align:center; white-space:normal; line-height:1.25; font-size:.85rem;
        color:#666 !important;
      }

      /* 반응형 */
      @media (max-width: 1200px){
        .main-board{ padding:24px 32px; }
      }

      /* 모바일: 사이드바 상단바화, 그리드 단일 컬럼 */
      @media (max-width: 992px){
        html, body{ height:auto; overflow-x:hidden; }
        .mypage-layout{ flex-direction:column; min-height:100vh; }
        .sidebar{
          width:100%; height:auto;
          border-right:none; border-bottom:1.5px solid #eee;
          flex-direction:row; align-items:center; justify-content:flex-start;
          padding:12px; gap:10px; background:#D9D9D9;
        }
        .profile-img{ width:48px; height:48px; margin:0; }
        .profile-name{ font-size:.95rem; margin:0; }
        .profile-edit-btn{ display:none; }
        .sidebar-bottom{ display:none; }

        .main-header{ display:none; }

        .main-board{
          height:auto; padding:16px !important; overflow:visible !important;
          grid-template-rows:auto auto auto auto;
        }
        .dashboard-row{ grid-template-columns:1fr; gap:12px; }
        .card{ padding:16px; }
      }

      /* 데스크톱에서 사이드바 하단 버튼 정돈 */
      @media (min-width: 992px){
        .sidebar-bottom .logout-btn{
          display:inline-block; width:auto; padding:6px 14px; border-radius:10px;
        }
      }
    </style>
    <script src="https://kit.fontawesome.com/65ecdc8e2b.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<c:if test="${not empty editSuccess}">
    <script>alert('${editSuccess}');</script>
</c:if>
<div class="mypage-layout">
    <%-- 왼쪽 사이드바 --%>
    <aside class="sidebar">
        <div style="display:flex; flex-direction:column; align-items:center; width:100%;">
            <img
                id="profileImgPreview"
                src="<c:choose>
                        <c:when test='${not empty member.profile_img}'>/profile/img/${member.profile_img}</c:when>
                        <c:otherwise>https://img.icons8.com/ios-glyphs/60/000000/user.png</c:otherwise>
                     </c:choose>"
                class="profile-img"
                alt="프로필 이미지"
                data-bs-toggle="modal" data-bs-target="#profileImgModal"
                style="cursor:pointer;"
            >
            <div class="profile-name">
                ${target.nickname}님의 프로필
                <security:authorize access="hasRole('ADMIN')">
                  <c:choose>
                    <c:when test="${banned}">
                      <a class="btn btn-outline-success btn-sm" data-bs-toggle="modal" data-bs-target="#unbanModal">정지 해제</a>
                      <span class="badge text-bg-danger ms-2">
                        정지 ~ <fmt:formatDate value="${banUntil}" pattern="yyyy-MM-dd HH:mm"/>
                      </span>
                    </c:when>
                    <c:otherwise>
                      <a class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#banModal">계정 정지</a>
                    </c:otherwise>
                  </c:choose>
                </security:authorize>
                <div class="modal fade" id="banModal" tabindex="-1" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-centered">
                    <form method="post" action="${pageContext.request.contextPath}/admin/ban/${target.userId}" class="modal-content">
                      <div class="modal-header">
                        <h5 class="modal-title">회원 정지</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                      </div>
                      <div class="modal-body">
                        <label class="form-label">정지 종료일시</label>
                        <input type="datetime-local" name="banUntil" class="form-control" required>
                      </div>
                      <div class="modal-footer">
                        <security:csrfInput/>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-danger">정지</button>
                      </div>
                    </form>
                  </div>
                </div>
            </div>
        </div>
        <div class="sidebar-bottom">
            <button class="logout-btn" onclick="history.back()">뒤로가기</button>
        </div>
    </aside>

    <%-- 오른쪽 메인 --%>
    <div class="mypage-main">
        <div class="main-header">
            <button class="icon-btn" title="알림"><i class="fas fa-bell"></i></button>
            <button class="icon-btn" title="쪽지"><i class="fas fa-envelope"></i></button>
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
                        <a href="/map/" class="stretched-link"></a>
                        <img src="https://img.icons8.com/color/48/worldwide-location.png" class="me-3" width="34">
                        <span>어린이 범죄 예방 지도</span>
                    </div>
                </div>
                <div class="dashboard-row">
                      <div class="card p-4">
                        <span>${target.nickname}님이 작성한 글</span>
                        <a href="${pageContext.request.contextPath}/othermemberprofile/otherPost?userId=${target.userId}" class="btn btn-warning btn-sm mt-2">바로가기</a>
                    </div>
                    <div class="card p-4">
                        <span>${target.nickname}님이 작성한 댓글</span>
                       <a href="${pageContext.request.contextPath}/othermemberprofile/otherComment?userId=${target.userId}" class="btn btn-warning btn-sm mt-2">바로가기</a>
                    </div>
                </div>

                    <%-- 신뢰도 점수판(도넛차트) --%>
                    <div class="card p-4" style="flex:1;">
                        <div class="d-flex align-items-center mb-2" style="gap: 10px;">
                            <span style="font-weight:600; font-size:1.08rem;">${target.nickname}님의 신뢰도 점수판</span>
                            <span class="donut-grade-badge">
                              <c:choose>
                                <c:when test="${fn:trim(trustScore.grade) eq '새싹 보호자'}">🌱 새싹 보호자</c:when>
                                <c:when test="${fn:trim(trustScore.grade) eq '안심 지킴이'}">🏠 안심 지킴이</c:when>
                                <c:when test="${fn:trim(trustScore.grade) eq '최고 안전 수호자'}">🏆 최고 안전 수호자</c:when>
                              </c:choose>
                              (${trustScore.totalScore}점)
                            </span>
                        </div>
                        <%-- 도넛차트 + 게이지바 --%>
                        <div class="donut-box">
                            <canvas id="trustDonut"></canvas>
                            <div class="donut-labels">
                                <span><span class="donut-label-dot" style="background:#4bc0c0"></span>제보 ${trustScore.reportCount}</span>
                                <span><span class="donut-label-dot" style="background:#f6a623"></span>위탁 ${trustScore.entrustCount}</span>
                                <span><span class="donut-label-dot" style="background:#63a4fa"></span>댓글 ${trustScore.commentCount}</span>
                            </div>
                            <%-- 게이지바 영역 (차트 바로 아래) --%>
                            <div class="trust-gauge-wrap mt-4 w-100" style="max-width:230px;">
                                <div class="trust-gauge-bar-bg">
                                    <div class="trust-gauge-bar" id="trustGaugeBar"></div>
                                </div>
                                <div class="trust-gauge-label small text-end mt-1" id="trustGaugeText" style="color:#666;"></div>
                            </div>
                        </div>
                        <%-- 모달 트리거(원하면 버튼추가) --%>
                        <button type="button"
                                class="btn btn-light rounded-circle"
                                style="position:absolute; top:20px; right:22px; width:28px; height:28px; padding:0; border:1.5px solid #eee; color:#888;"
                                data-bs-toggle="modal" data-bs-target="#trustScoreModal">
                            <i class="fas fa-question"></i>
                        </button>
                    </div>
                    <%-- 모달은 기존대로 --%>
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
                                  <span style="color:#40a048; font-weight:500;">새싹 보호자 (0~9점)</span>,
                                  <span style="color:#a8743d; font-weight:500;">안심 지킴이 (10~29점)</span>,
                                  <span style="color:#f6a623; font-weight:500;">최고 안전 수호자 (30점 이상)</span>
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
            </div><%-- main-board --%>
        </div><%-- mypage-main --%>
    </div><%-- mypage-layout --%>

    <%-- 도넛차트 Chart.js 스크립트 + 게이지바 스크립트 --%>
    <script>
        // JSP 변수 치환 (꼭 Number로!)
        const reportCount = Number('${trustScore.reportCount}');
        const entrustCount = Number('${trustScore.entrustCount}');
        const commentCount = Number('${trustScore.commentCount}');
        // Chart.js 도넛 그리기
        const ctx = document.getElementById('trustDonut').getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['제보', '위탁', '댓글'],
                datasets: [{
                    data: [reportCount, entrustCount, commentCount],
                    backgroundColor: [
                        '#4bc0c0', // 제보
                        '#f6a623', // 위탁
                        '#63a4fa'  // 댓글
                    ],
                    borderWidth: 0,
                }]
            },
            options: {
                cutout: '65%',
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': ' + context.raw + '개';
                            }
                        }
                    }
                }
            }
        });
        // 게이지바
        const totalScore = Number('${trustScore.totalScore}');
        let grade = '${fn:trim(trustScore.grade)}';
        const gaugeBar = document.getElementById('trustGaugeBar');
        const gaugeText = document.getElementById('trustGaugeText');
        const maxScore = 30;
        let percent = Math.min((totalScore / maxScore) * 100, 100);
        setTimeout(() => {
            gaugeBar.style.width = percent + '%';
        }, 300);


        let text = '';
        if (grade === '최고 안전 수호자') {
            text = `${target.nickname}님은 최고 등급 달성! 👑`;
        } else if (grade === '안심 지킴이') {
            text = `${target.nickname}님은 최고 안전 수호자까지 <b>${30-totalScore}</b>점 남았어요!`;
        } else if (grade === '새싹 보호자') {
            text = `${target.nickname}님은 안심 지킴이까지 <b>${10-totalScore}</b>점 남았어요!`;
        }
        gaugeText.innerHTML = text;

    </script>
</body>
</html>
