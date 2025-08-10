<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
        /* === (생략) 기존 스타일 복사 === */
        body { background: #F8F9FA; margin: 0; font-family: 'Pretendard','Apple SD Gothic Neo',Arial,sans-serif; }
        .mypage-layout { display: flex; min-height: 100vh; }
        .sidebar { width: 220px; height: 100vh; background: #fff; border-right: 1.5px solid #eee; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 0; }
        .profile-img { width: 76px; height: 76px; border-radius: 50%; background: #ddd url('https://img.icons8.com/ios-glyphs/60/000000/user.png') center/48px no-repeat; margin-top: 50px; margin-bottom: 10px; object-fit: cover; cursor: pointer; }
        .profile-name { font-weight: 600; font-size: 1.08rem; color: #444; margin-bottom: 8px; }
        .profile-edit-btn, .logout-btn { border: none; background: #f8f9fa; color: #666; font-size: 0.92rem; border-radius: 7px; padding: 5px 15px; margin-top: 6px; cursor: pointer; transition: background 0.15s; }
        .profile-edit-btn:hover, .logout-btn:hover { background: #f1f1f1; color: #222; }
        .sidebar-bottom { margin-top: auto; width: 100%; display: flex; flex-direction: column; align-items: center; padding-bottom: 34px; }
        .main-header { height: 64px; background: #D9D9D9; display: flex; align-items: center; justify-content: flex-end; padding: 0 40px; border-bottom: 1.5px solid #eee; }
        .main-header .icon-btn { background: transparent; border: none; outline: none; font-size: 25px; margin-left: 18px; color: #333; cursor: pointer; }
        .main-header .icon-btn:focus { outline: none; }
        .mypage-main { flex: 1 1 0; display: flex; flex-direction: column; min-height: 100vh; overflow-x: auto; }
        .main-board { flex: 1 1 0; display: flex; flex-direction: column; justify-content: flex-start; padding: 38px 40px 30px 40px; }
        .dashboard-row { display: flex; gap: 25px; margin-bottom: 18px; }
        .card { border-radius: 15px; box-shadow: 0 4px 12px rgba(20,30,58,0.06); border: none; }
        .dashboard-row .card { flex: 1; }
        /* 도넛차트 */
        .donut-box canvas { margin-top: 18px; width: 220px !important; height: 220px !important; min-width: 50px !important; min-height: 50px !important; }
        .donut-box { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 180px; }
        .donut-labels { display: flex; gap: 16px; justify-content: center; margin-top: 12px; font-size: 15px; }
        .donut-label-dot { display: inline-block; width: 12px; height: 12px; border-radius: 6px; margin-right: 5px; }
        .donut-grade-badge { display: flex; align-items: center; gap: 6px; margin-top: 7px; font-size: 16px; font-weight: 600; }
        /* 게이지바 */
        .trust-gauge-wrap { margin-top: 16px; }
        .trust-gauge-bar-bg { width: 100%; height: 18px; background: #eee; border-radius: 9px; position: relative; overflow: hidden; }
        .trust-gauge-bar { height: 100%; background: #FFC112; border-radius: 9px 0 0 9px; width: 0; transition: width 0.9s cubic-bezier(.23,1.01,.32,1); }
        .trust-gauge-label { font-size: 0.93rem; text-align: right; margin-top: 4px; }
        @media (max-width: 1200px) { .main-board { padding: 18px 10px 18px 10px; } }
        @media (max-width: 900px) { .sidebar { display: none; } .main-board { padding: 7px; } }
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
            <div class="profile-name">${target.nickname}님의 프로필</div>
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
                                <c:when test="${fn:trim(trustScore.grade) eq '새싹맘'}">🌱 새싹맘</c:when>
                                <c:when test="${fn:trim(trustScore.grade) eq '도토리맘'}">🥜 도토리맘</c:when>
                                <c:when test="${fn:trim(trustScore.grade) eq '캡숑맘'}">👑 캡숑맘</c:when>
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
        if (grade === '캡숑맘') {
            text = `${target.nickname}님은 최고 등급 달성! 👑`;
        } else if (grade === '도토리맘') {
            text = `${target.nickname}님은 캡숑맘까지 <b>${30-totalScore}</b>점 남았어요!`;
        } else if (grade === '새싹맘') {
            text = `${target.nickname}님은 도토리맘까지 <b>${10-totalScore}</b>점 남았어요!`;
        }
        gaugeText.innerHTML = text;

    </script>
</body>
</html>
