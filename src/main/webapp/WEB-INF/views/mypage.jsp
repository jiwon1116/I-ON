<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="session-id" content="${pageContext.session.id}">
  <title>마이페이지</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://kit.fontawesome.com/65ecdc8e2b.js" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

  <style>
    /* == 페이지 전체 스크롤 금지 == */
    html,body{height:100%;overflow:hidden}
    body{margin:0;background:#F8F9FA;font-family:'Pretendard','Apple SD Gothic Neo',Arial,sans-serif}

    /* == 좌우 레이아웃 == */
    .mypage-layout{display:flex;height:100vh;overflow:hidden}

    /* == 사이드바 (모바일에서도 유지) == */
    .sidebar{width:160px;background:#fff;border-right:1.5px solid #eee;display:flex;flex-direction:column;align-items:center}
    .profile-img{width:72px;height:72px;border-radius:50%;object-fit:cover;margin-top:36px;margin-bottom:8px;background:#ddd url('https://img.icons8.com/ios-glyphs/60/000000/user.png') center/46px no-repeat}
    .profile-name{font-weight:600;font-size:1rem;color:#444;margin-bottom:6px}
    .profile-edit-btn,.logout-btn{display:block;white-space:nowrap;width:120px;text-align:center;border:none;background:#f8f9fa;color:#666;font-size:.85rem;border-radius:10px;padding:6px 10px;margin-top:6px;cursor:pointer;transition:background .15s}
    .profile-edit-btn:hover,.logout-btn:hover{background:#f1f1f1;color:#222}
    .sidebar-bottom{margin-top:auto;padding:18px 0}
    @media (max-width:900px){ .sidebar{width:140px} }
    @media (max-width:560px){ .sidebar{width:120px} }

    /* == 우측 메인 == */
    .mypage-main{flex:1 1 0;display:flex;flex-direction:column;min-width:0;min-height:0}

    /* 헤더 */
    .main-header{flex:0 0 56px;height:56px;background:#D9D9D9;display:flex;align-items:center;justify-content:flex-end;padding:0 16px;border-bottom:1.5px solid #eee}
    .icon-btn{position:relative;border:0;outline:0;background:transparent;appearance:none;font-size:22px;margin-left:14px;color:#333;cursor:pointer}
    .icon-btn:focus{outline:0;box-shadow:none}
    .unread-count-badge{position:absolute;top:-6px;right:-8px;background:#ff3b30;color:#fff;border-radius:999px;padding:2px 6px;font-size:10px;line-height:1}

    /* === 메인 보드: 3행 그리드 (auto, auto, 1fr)로 고정 === */
    .main-board{
      height:calc(100vh - 56px);          /* 헤더 제외 높이를 확실히 계산 */
      display:grid;
      grid-template-rows:auto auto 1fr;   /* 위–위–아래(남는 높이) */
      row-gap:14px;
      padding:16px;
      overflow:hidden;
      min-height:0;
    }

    /* 위 타일 2×2 고정 */
    .top-tiles{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px;min-height:0}

    /* 미니카드 3열 */
    .mini-cards{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;min-height:0}

    /* 하단 2칸: 남는 높이 모두 먹음 */
    .bottom-grid{
      display:grid;
      grid-template-columns:2fr 1fr !important; /* 인라인 스타일 있어도 강제 */
      gap:14px;
      min-height:0;
      height:100%;                  /* main-board의 1fr 전부 차지 */
      align-items:stretch;
    }

    /* 카드/타일 공통 (작고 둥글게) */
    .tile{
    position:relative;
    display:flex;
    align-items:center;
    gap:10px;
    height:52px;
    padding:5px 12px;
    background:#fff;
    border:none;
    border-radius:22px;
    box-shadow:0 4px 10px rgba(20,30,58,.06)}
    .tile img{width:26px;height:26px}
    .tile span{font-size:15px;color:#333}
    .tile a.stretched-link{position:absolute;inset:0;border-radius:22px}

    .card{background:#fff;border-radius:22px;box-shadow:0 4px 10px rgba(20,30,58,.06);border:none}
    .card .card-body{padding:16px}

    /* 하단 카드가 정확히 같은 높이가 되도록 */
    .bottom-grid > .card{display:flex;flex-direction:column;height:100%;min-height:0}
    .bottom-grid > .card .card-body{flex:1 1 auto;display:flex;flex-direction:column;min-height:0}

    /* 내 소식만 스크롤 */
    .news-card{flex:1 1 auto;min-height:0}
    .notify-scroll{flex:1 1 auto;min-height:0;overflow:auto;-webkit-overflow-scrolling:touch}

    /* 도넛/게이지 */
    .donut-box{display:flex;flex-direction:column;align-items:center;justify-content:center}
    .donut-box canvas{width:200px!important;height:200px!important;max-width:100%}
    .donut-labels{display:flex;gap:10px;justify-content:center;flex-wrap:wrap;margin-top:8px;font-size:13px}
    .donut-label-dot{display:inline-block;width:10px;height:10px;border-radius:5px;margin-right:4px}
    .donut-grade-badge{display:flex;align-items:center;gap:6px;margin-top:2px;font-size:15px;font-weight:600}
    .trust-gauge-wrap{margin-top:10px;width:100%;max-width:220px}
    .trust-gauge-bar-bg{width:100%;height:14px;background:#eee;border-radius:9px;overflow:hidden}
    .trust-gauge-bar{height:100%;background:#FFC112;border-radius:9px 0 0 9px;width:0;transition:width .9s cubic-bezier(.23,1.01,.32,1)}
    .trust-gauge-label{font-size:.9rem;text-align:right;margin-top:4px;color:#666}

    /* 반응형 */
    @media (max-width:992px){
      .mini-cards{grid-template-columns:repeat(2,minmax(0,1fr))}
      .bottom-grid{grid-template-columns:1.6fr 1fr !important}
      .donut-box canvas{width:180px!important;height:180px!important}
    }
    @media (max-width:560px){
      .top-tiles{grid-template-columns:1fr}
      .mini-cards{grid-template-columns:1fr}
      .bottom-grid{grid-template-columns:1fr !important}
      .donut-box canvas{width:160px!important;height:160px!important}
    }
    /* 1) dvh 지원 브라우저에선 그걸로 정확히 맞추기 */
    @supports (height: 100dvh) {
      .mypage-layout{ height: 100dvh; }
      .main-board{ height: calc(100dvh - 56px); } /* 헤더 제외 */
    }

    /* 2) dvh 미지원(iOS Safari 등)을 위한 폴백: JS가 --vh 넣어줌 */
    @supports not (height: 100dvh) {
      .mypage-layout{ height: calc(var(--vh, 1vh) * 100); }
      .main-board{ height: calc(calc(var(--vh, 1vh) * 100) - 56px); }
    }

    /* 3) 바닥 패딩을 살짝 줄여 완전 밀착(원하면 0으로) */
    .main-board{ padding-bottom: 8px; }  /* 기존 16px → 8px */

    /* 모든 카드에 동일한 내부 여백(가장자리 띠) 추가 */
    .card{
      padding: 20px !important;   /* 필요하면 10~16px로 조절 */
      box-sizing: border-box;
    }

    /* 카드 내부 본문은 기존처럼 유지 (많아 보이면 12px로) */
    .card .card-body{
      padding: 20px;
    }

    /* 상단 타일(소통/제보/아동범죄/지도)도 살짝 여백 확대 */
    .tile{
      padding: 8px 16px !important;  /* 세로 8px, 좌우 16px */
    }

    /* 하단 두 카드(내 소식/신뢰도)도 스크롤 영역 유지 */
    .bottom-grid > .card .card-body{
      flex: 1 1 auto;
      min-height: 0;
      display: flex;
      flex-direction: column;
    }

    .top-tiles .tile{
      padding: 15px 20px !important;
      min-height: 56px;
      height: auto !important;
      box-sizing: border-box;
    }

    /* 아이콘/텍스트 사이 살짝 여유 원하면 */
    .top-tiles .tile img { margin-left: 2px; }
  </style>
</head>

<body>
<c:if test="${not empty editSuccess}">
  <script>alert('${editSuccess}');</script>
</c:if>

<div class="mypage-layout">
  <!-- 사이드바 -->
  <aside class="sidebar">
    <div style="display:flex; flex-direction:column; align-items:center; width:100%;">
      <img id="profileImgPreview"
           src="<c:choose>
                   <c:when test='${not empty member.profile_img}'>/profile/img/${member.profile_img}</c:when>
                   <c:otherwise>https://img.icons8.com/ios-glyphs/60/000000/user.png</c:otherwise>
                </c:choose>"
           class="profile-img" alt="프로필 이미지"
           data-bs-toggle="modal" data-bs-target="#profileImgModal" style="cursor:pointer;">
      <div class="profile-name">${member.nickname}</div>
      <button type="button" class="profile-edit-btn mt-1" data-bs-toggle="modal" data-bs-target="#profileImgModal">이미지 수정하기</button>
    </div>
    <div class="sidebar-bottom">
      <button class="logout-btn" onclick="location.href='/logout'">로그아웃</button>
    </div>
  </aside>

  <!-- 프로필 이미지 업로드 모달 -->
  <div class="modal fade" id="profileImgModal" tabindex="-1" aria-labelledby="profileImgModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <form id="profileImgForm" enctype="multipart/form-data">
          <div class="modal-header">
            <h5 class="modal-title" id="profileImgModalLabel">프로필 이미지 수정</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3 text-center">
              <img id="modalProfilePreview"
                   src="<c:choose>
                           <c:when test='${not empty member.profile_img}'>/profile/img/${member.profile_img}</c:when>
                           <c:otherwise>https://img.icons8.com/ios-glyphs/60/000000/user.png</c:otherwise>
                        </c:choose>"
                   class="profile-img" style="width:100px;height:100px;" alt="미리보기">
            </div>
            <input type="file" name="profileImg" id="modalProfileImgInput" accept="image/*" class="form-control"/>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            <button type="submit" class="btn btn-warning">저장하기</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- 오른쪽 메인 -->
  <div class="mypage-main">
    <div class="main-header">
      <button id="alertBtn" type="button" class="icon-btn" data-bs-html="true" data-bs-container="body" title="알림">
        <i class="fas fa-bell"></i>
        <span id="notify-unread-count" class="badge unread-count-badge" style="display:none"></span>
      </button>
      <a href="/chat" class="icon-btn" title="쪽지" style="text-decoration:none">
        <i class="fas fa-envelope"></i>
        <c:if test="${totalUnreadCount > 0}">
          <span id="total-unread-count" class="badge unread-count-badge">${totalUnreadCount}</span>
        </c:if>
      </a>
    </div>

    <div id="popover-content" class="d-none"></div>

    <!-- 메인 보드 -->
    <div class="main-board">
      <!-- 상단 4개 타일 -->
      <div class="cards-grid top-tiles">
        <div class="tile">
          <a href="/free" class="stretched-link"></a>
          <img src="https://img.icons8.com/color/48/speech-bubble--v1.png" alt="">
          <span>소통 커뮤니티</span>
        </div>
        <div class="tile">
          <a href="/flag" class="stretched-link"></a>
          <img src="https://img.icons8.com/color/48/faq.png" alt="">
          <span>제보 및 신고 커뮤니티</span>
        </div>
        <div class="tile">
          <a href="/info" class="stretched-link"></a>
          <img src="https://img.icons8.com/color/48/police-badge.png" alt="">
          <span>아동 범죄 발생</span>
        </div>
        <div class="tile">
          <a href="/map/" class="stretched-link"></a>
          <img src="https://img.icons8.com/color/48/worldwide-location.png" alt="">
          <span>어린이 범죄 예방 지도</span>
        </div>
      </div>

      <!-- 미니 타일 3개 -->
      <div class="mini-grid mini-cards">
        <div class="card"><div class="card-body">
          <span>자녀 등록</span><br>
          <a href="/cert/my" class="btn btn-warning btn-sm mt-2">바로가기</a>
        </div></div>
        <div class="card"><div class="card-body">
          <span>내가 작성한 글</span><br>
          <a href="/myPost" class="btn btn-warning btn-sm mt-2">바로가기</a>
        </div></div>
        <div class="card"><div class="card-body">
          <span>내가 작성한 댓글</span><br>
          <a href="/myComment" class="btn btn-warning btn-sm mt-2">바로가기</a>
        </div></div>
      </div>

      <!-- 하단 2칸: 내 소식 / 신뢰도 -->
      <div class="cards-grid bottom-grid" style="grid-template-columns:2fr 1fr">
        <!-- 내 소식 (여기만 스크롤) -->
        <div class="card big">
          <div class="card-body news-card">
            <span>내 소식</span>
            <div class="notify-scroll">
              <div class="notification-list" id="notifyList">
                <c:forEach var="notify" items="${notifyList}">
                  <c:choose>
                    <c:when test="${notify.type == 'COMMENT'}">
                      <div class="notification-item" style="padding:10px 0;border-bottom:1px solid #f0f0f0;">
                        <div class="notify-header"><span class="notify-icon">[댓글]💬</span></div>
                        <div class="notify-content">${notify.content}</div>
                        <div class="d-flex gap-2 mt-1">
                          <button class="btn btn-sm btn-outline-secondary" onclick="deleteNotify(${notify.id})">삭제</button>
                          <a class="btn btn-sm btn-outline-primary" href="/${notify.related_board}/${notify.related_post_id}">게시물 이동</a>
                        </div>
                        <div class="notify-date small text-muted">
                          <fmt:formatDate value="${notify.created_at}" pattern="yyyy-MM-dd HH:mm" />
                        </div>
                      </div>
                    </c:when>

                    <c:when test="${notify.type == 'DANGER_ALERT'}">
                      <input type="hidden" class="danger-alert" value="${notify.content}" />
                      <div class="notification-item" style="padding:10px 0;border-bottom:1px solid #f0f0f0;">
                        <div class="notify-header"><span class="notify-icon">[위험]🚨</span></div>
                        <div class="notify-content">${notify.content}</div>
                        <div class="d-flex gap-2 mt-1">
                          <button class="btn btn-sm btn-outline-secondary" onclick="deleteNotify(${notify.id})">삭제</button>
                          <a class="btn btn-sm btn-outline-primary" href="/${notify.related_board}/${notify.related_post_id}">게시물 이동</a>
                        </div>
                        <div class="notify-date small text-muted">
                          <fmt:formatDate value="${notify.created_at}" pattern="yyyy-MM-dd HH:mm" />
                        </div>
                      </div>
                    </c:when>
                  </c:choose>
                </c:forEach>
              </div>

              <!-- 지역 위험 알림 모달 -->
              <div class="modal fade" id="dangerModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header"><h5 class="modal-title">📢 위험 알림</h5></div>
                    <div class="modal-body"></div>
                    <div class="modal-footer"><button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button></div>
                  </div>
                </div>
              </div>
            </div><!-- /notify-scroll -->
          </div>
        </div>

        <!-- 신뢰도 점수판 -->
        <div class="card big">
          <div class="card-body trust-card" style="position:relative">
            <div class="d-flex align-items-center mb-2" style="gap:10px;">
              <span style="font-weight:600;font-size:1.08rem;">신뢰도 점수판</span>
              <span class="donut-grade-badge">
                <c:choose>
                  <c:when test="${fn:trim(trustScore.grade) eq '새싹 보호자'}">🌱 새싹 보호자</c:when>
                  <c:when test="${fn:trim(trustScore.grade) eq '안심 지킴이'}">🏠 안심 지킴이</c:when>
                  <c:when test="${fn:trim(trustScore.grade) eq '최고 안전 수호자'}">🏆 최고 안전 수호자</c:when>
                </c:choose>
                (${trustScore.totalScore}점)
              </span>
            </div>

            <div class="donut-box">
              <canvas id="trustDonut"></canvas>
              <div class="donut-labels">
                <span><span class="donut-label-dot" style="background:#4bc0c0"></span>제보 ${trustScore.reportCount}</span>
                <span><span class="donut-label-dot" style="background:#f6a623"></span>위탁 ${trustScore.entrustCount}</span>
                <span><span class="donut-label-dot" style="background:#63a4fa"></span>댓글 ${trustScore.commentCount}</span>
              </div>
              <div class="trust-gauge-wrap">
                <div class="trust-gauge-bar-bg"><div class="trust-gauge-bar" id="trustGaugeBar"></div></div>
                <div class="trust-gauge-label" id="trustGaugeText"></div>
              </div>
            </div>

            <button type="button" class="btn btn-light rounded-circle"
                    style="position:absolute; top:20px; right:22px; width:28px; height:28px; padding:0; border:1.5px solid #eee; color:#888;"
                    data-bs-toggle="modal" data-bs-target="#trustScoreModal">
              <i class="fas fa-question"></i>
            </button>
          </div>
        </div>

        <!-- 신뢰도 안내 모달 -->
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
                  <li>
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
      </div><!-- /하단 그리드 -->
    </div><!-- /main-board -->
  </div><!-- /mypage-main -->
</div><!-- /mypage-layout -->

<script>
  // 프로필 이미지 미리보기
  document.getElementById('modalProfileImgInput').addEventListener('change', function(event) {
    const reader = new FileReader();
    reader.onload = function(e) {
      document.getElementById('modalProfilePreview').src = e.target.result;
    };
    if (event.target.files.length > 0) {
      reader.readAsDataURL(event.target.files[0]);
    }
  });

  // 이미지 업로드
  $('#profileImgForm').on('submit', function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    $.ajax({
      url: '/profile/upload',
      type: 'POST',
      data: formData,
      contentType: false,
      processData: false,
      success: function(result) {
        $('#profileImgPreview').attr('src', result.profileImgUrl || 'https://img.icons8.com/ios-glyphs/60/000000/user.png');
        var modal = bootstrap.Modal.getInstance(document.getElementById('profileImgModal'));
        modal.hide();
        alert('프로필 이미지가 변경되었습니다.');
      },
      error: function() { alert('업로드 실패'); }
    });
  });

  // 도넛 차트
  const reportCount = Number('${trustScore.reportCount}');
  const entrustCount = Number('${trustScore.entrustCount}');
  const commentCount = Number('${trustScore.commentCount}');
  const ctx = document.getElementById('trustDonut').getContext('2d');
  new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['제보','위탁','댓글'],
      datasets: [{
        data: [reportCount, entrustCount, commentCount],
        backgroundColor: ['#4bc0c0','#f6a623','#63a4fa'],
        borderWidth: 0
      }]
    },
    options: {
      cutout: '65%',
      plugins: { legend:{display:false}, tooltip:{callbacks:{label:(c)=> c.label+': '+c.raw+'개'}} }
    }
  });

  // 게이지바
  const totalScore = Number('${trustScore.totalScore}');
  const grade = '${fn:trim(trustScore.grade)}';
  const gaugeBar = document.getElementById('trustGaugeBar');
  const gaugeText = document.getElementById('trustGaugeText');
  const maxScore = 30;
  const percent = Math.min((totalScore / maxScore) * 100, 100);
  setTimeout(()=>{gaugeBar.style.width = percent + '%';}, 300);

  let text = '';
  if (grade === '최고 안전 수호자') {
    text = '최고 등급 달성! 🏆';
  } else if (grade === '안심 지킴이') {
    text = '최고 안전 수호자까지 <b>' + Math.max(0, 30 - totalScore) + '</b>점 남았어요!';
  } else { // 새싹 보호자
    text = '안심 지킴이까지 <b>' + Math.max(0, 10 - totalScore) + '</b>점 남았어요!';
  }
  gaugeText.innerHTML = text;
</script>

<!-- 알림 팝오버 -->
<script>
document.addEventListener("DOMContentLoaded", async function () {
  var btn = document.getElementById("alertBtn");
  if (!btn) return;
  var base = "${pageContext.request.contextPath}" || "";

  try {
    var res = await fetch(base + "/notify/list", { credentials: "same-origin" });
    if (!res.ok) throw new Error("HTTP " + res.status);
    var items = await res.json();

    var unreadCount = items.filter(n => !n.isRead).length;
    var badge = document.getElementById("notify-unread-count");
    if (badge) {
      if (unreadCount > 0) { badge.textContent = unreadCount; badge.style.display = "inline-block"; }
      else { badge.style.display = "none"; }
    }

    items.sort((a,b)=>(b.created_at||0)-(a.created_at||0));

    var html = '<div style="max-height:220px; overflow-y:auto;">'
             +   '<ul class="list-unstyled mb-0">';
    if (items.length) {
      for (var i=0;i<items.length;i++){
        var n = items[i];
        var text = (n && n.content) ? n.content : '';
        var board = (n && n.related_board) ? n.related_board : "";
        var pid   = (n && n.related_post_id) ? n.related_post_id : "";
        var link  = base + "/" + board + "/" + pid;

        html += '<li style="padding:6px 0; border-bottom:1px solid #f0f0f0;">'
             +   '<a href="'+link+'" style="text-decoration:none; color:inherit;">'+text+'</a>'
             +   '<button type="button" class="notify-delete" data-id="'+n.id+'"'
             +           ' style="margin-left:8px;background:none;border:none;cursor:pointer;">❌</button>'
             + '</li>';
      }
    } else {
      html += '<li style="padding:10px;">알림이 없습니다🙂</li>';
    }
    html +=   '</ul></div>';

    new bootstrap.Popover(btn, {
      html:true, container:'body', placement:'bottom', trigger:'click',
      title:'알림', content:html, sanitize:false
    });

  } catch (e) {
    console.error("notify popover error:", e);
    var fallback = '<div style="max-height:220px; overflow-y:auto;">'
                 +   '<ul class="list-unstyled mb-0"><li>알림을 불러오지 못했습니다</li></ul>'
                 + '</div>';
    new bootstrap.Popover(btn, {
      html:true, container:'body', placement:'bottom', trigger:'click',
      title:'알림', content:fallback
    });
  }
});

// 문서 위임 삭제
document.addEventListener('click', function(e){
  if (e.target && e.target.classList.contains('notify-delete')) {
    const id = e.target.getAttribute('data-id');
    deleteNotify(id);
    e.target.closest('li')?.remove();
  }
});

function deleteNotify(id){
  if (!confirm("이 알림을 삭제할까요?")) return;
  const base = "${pageContext.request.contextPath}" || "";
  fetch(base + "/notify/delete/" + id, { method:"DELETE", credentials:"same-origin" })
    .then(res=>{ if(!res.ok) throw new Error("삭제 실패: "+res.status); return res.text(); })
    .then(()=> window.location.reload())
    .catch(()=> alert("삭제 중 오류가 발생했습니다."));
}
</script>
<script>
  function setVhUnit(){
    document.documentElement.style.setProperty('--vh', (window.innerHeight * 0.01) + 'px');
  }
  window.addEventListener('resize', setVhUnit);
  window.addEventListener('orientationchange', setVhUnit);
  setVhUnit();
</script>
</body>
</html>
