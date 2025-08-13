<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<style>

html, body {
	height: 100%;
	margin: 0;
	background: #F8F9FA;
	font-family: 'Pretendard', 'Apple SD Gothic Neo', Arial, sans-serif;
	overflow-x: hidden;
}

.mypage-layout {
	display: flex;
	height: 100vh;
}

.sidebar {
	width: 250px;
	background: #fff;
	border-right: 1.5px solid #eee;
	display: flex;
	flex-direction: column;
	align-items: center;
	padding-top: 36px;
}

.profile-section {
	display: flex;
	flex-direction: column;
	align-items: center;
	width: 100%;
	padding: 0 10px;
}

.profile-img {
	width: 72px;
	height: 72px;
	border-radius: 50%;
	object-fit: cover;
	margin-bottom: 8px;
	background: #ddd
		url('https://img.icons8.com/ios-glyphs/60/000000/user.png') center/46px
		no-repeat;
	cursor: pointer;
}

.profile-name {
	font-weight: 600;
	font-size: 1rem;
	color: #444;
	margin-bottom: 6px;
	word-break: keep-all;
	text-align: center;
}

.profile-edit-btn, .logout-btn {
	display: block;
	width: 100%;
	text-align: center;
	border: 1px solid #e0e0e0;
	background: #f8f9fa;
	color: #666;
	font-size: .85rem;
	border-radius: 10px;
	padding: 6px 10px;
	margin-top: 6px;
	cursor: pointer;
	transition: background .15s;
	text-decoration: none !important;
}

.profile-edit-btn:hover, .logout-btn:hover {
	background: #f1f1f1;
	color: #222;
}

.sidebar-bottom {
	margin-top: auto;
	padding: 18px 0;
	width: 100%;
}

.mypage-main {
	flex: 1 1 0;
	display: flex;
	flex-direction: column;
	min-width: 0;
	min-height: 0;
}

.main-header {
	flex: 0 0 70px;
	height: 70px;
	background: #D9D9D9;
	display: flex;
	align-items: center;
	justify-content: flex-end;
	padding: 0 16px;
	border-bottom: 1.5px solid #eee;
}

.icon-btn {
	position: relative;
	border: 0;
	outline: 0;
	background: transparent;
	font-size: 22px;
	margin-left: 14px;
	color: #333;
	padding: 0 7px;
	cursor: pointer;
}

.unread-count-badge {
	position: absolute;
	top: -6px;
	right: -8px;
	background: #ff3b30;
	color: #fff;
	border-radius: 999px;
	padding: 2px 6px;
	font-size: 10px;
	line-height: 1;
}

.main-board {
	height: calc(100vh - 70px);
	display: grid;
	grid-template-rows: auto auto 1fr;
	row-gap: 16px;
	padding: 50px 200px;
	box-sizing: border-box;
	overflow: hidden;
}

.top-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 16px;
}

.top-grid .card {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 12px;
}

.top-grid .card a.stretched-link {
	position: absolute;
	inset: 0;
	border-radius: 16px;
}

.top-grid .card img {
	width: 32px;
	height: 32px;
}

.top-grid .card span {
	font-size: 15px;
	font-weight: 500;
	color: #333;
}

.middle-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 16px;
}

.bottom-grid {
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 16px;
	height: 100%;
	min-height: 0;
}

.card {
	position: relative;
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 4px 10px rgba(20, 30, 58, .06);
	border: none;
	padding: 20px;
	display: flex;
	flex-direction: column;
}

.card-body {
	flex: 1;
	display: flex;
	flex-direction: column;
	gap: 5px;
}

.news-card {
	height: 100%;
	min-height: 0;
	display: flex;
	flex-direction: column;
	overflow: hidden;
}

.news-card .card-body {
	flex: 1 1 0;
	min-height: 0;
	display: flex;
	flex-direction: column;
	padding-bottom: 0;
}

.news-card .notify-scroll {
	flex: 1 1 0;
	min-height: 0;
	overflow-y: auto;
	-webkit-overflow-scrolling: touch;
	padding-right: 10px;
}

.notification-item {
	padding: 10px 0;
	border-bottom: 1px solid #f0f0f0;
}

.trust-card {
	display: flex;
	flex-direction: column;
	align-items: center;
	text-align: center;
	overflow: hidden;
}

.donut-box {
	width: 100%;
	max-width: 180px;
	margin: 10px auto;
}

.donut-labels {
	display: flex;
	justify-content: center;
	gap: 7px;
	flex-wrap: wrap;
	margin-top: 10px;
	font-size: 12px;
}

.donut-grade-badge {
	font-size: 0.9rem;
}

.trust-gauge-wrap {
	display: flex;
	flex-direction: column;
	align-items: center;
}

.trust-gauge-label {
	display: block;
	width: auto;
	align-self: center;
	margin-top: 6px;
	text-align: center;
	white-space: nowrap;
}

.trust-gauge-bar-bg {
	position: relative;
	width: 145px;
	height: 8px;
	background: #e9ecef;
	border-radius: 999px;
	margin: 8px auto 6px;
	overflow: hidden;
}

.trust-gauge-bar {
	position: absolute;
	left: 0;
	top: 0;
	bottom: 0;
	width: 0;
	background: #ffc107;
	border-radius: 999px;
	transition: width .5s ease-in-out;
}

.donut-label-dot {
	display: inline-block;
	width: 8px;
	height: 8px;
	border-radius: 50%;
	margin-right: 4px;
}

@media ( max-width : 992px) {
	html, body {
		height: auto;
		overflow-x: hidden;
	}
	.mypage-layout {
		flex-direction: column;
		height: auto !important;
		min-height: 100vh;
		overflow: visible !important;
	}
	.sidebar {
		width: 100%;
		height: auto;
		border-right: none;
		border-bottom: 1.5px solid #eee;
		flex-direction: row;
		align-items: center;
		padding: 12px;
		gap: 10px;
		background: #D9D9D9;
	}
	.profile-section {
		flex-direction: row;
		gap: 10px;
		align-items: center;
		width: auto;
	}
	.profile-img {
		width: 48px;
		height: 48px;
		margin: 0;
	}
	.profile-name {
		font-size: .95rem;
		margin: 0;
	}
	.profile-edit-btn {
		display: none;
	}
	.mobile-actions, .sidebar-bottom {
		margin-left: auto;
		display: flex;
		align-items: center;
		gap: 10px;
	}
	.logout-btn {
		width: auto;
		font-size: .8rem;
		padding: 6px 12px;
		margin-left: 25px;
	}
	.main-header {
		display: none;
	}
	.main-board {
		height: auto !important;
		padding: 16px !important;
		overflow: visible !important;
		grid-template-rows: auto auto auto;
	}
	.top-grid, .middle-grid, .bottom-grid {
		grid-template-columns: 1fr;
	}
	.bottom-grid {
		gap: 16px;
	}
	.card {
		padding: 16px;
	}

	.news-card {
		height: auto;
		min-height: 200px;
	}
	.news-card .card-body {
		flex: 1;
		display: flex;
		flex-direction: column;
		min-height: 0;
	}
	.news-card .notify-scroll {
		flex: 1;
		overflow-y: auto;
		-webkit-overflow-scrolling: touch;
		padding-right: 0;
	}
}

@media ( min-width : 1200px) {
	.trust-card {
		overflow: hidden;
		padding: 0px;
	}
	.trust-card .card-body {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		gap: 5px;
		padding-bottom: 10px;
	}
	.trust-card .donut-box {
		max-width: 140px;
		margin: 5px auto 0;
	}
	#trustDonut {
		width: 100% !important;
		height: auto !important;
		aspect-ratio: 1/1;
		display: block;
	}
	.trust-card .donut-labels {
		margin-top: 5px;
		font-size: 11px;
	}
	.donut-grade-badge {
		font-size: 0.85rem;
	}
	.trust-gauge-wrap {
		margin-top: 5px;
	}
	.trust-gauge-label {
		font-size: 0.8rem;
		text-align: center;
	}
	.trust-card button {
		top: 10px;
		right: 12px;
		width: 24px;
		height: 24px;
		font-size: 0.7rem;
	}
	.trust-card button i {
		font-size: 0.6rem;
	}
}
.trust-card .donut-box {
	max-width: clamp(170px, 30vw, 205px) !important;
	margin: 6px auto 6px;
}

.trust-card .donut-labels {
	margin-top: 6px;
	font-size: 11.5px;
}

.trust-gauge-bar-bg {
	width: clamp(150px, 55%, 190px);
	height: 8px;
	margin: 8px auto 4px;
}

.trust-gauge-label {
	margin: 2px auto 0;
	text-align: center;
	white-space: normal;
	line-height: 1.25;
}

.trust-card .card-body {
	padding-bottom: 12px !important;
}

@media ( min-width : 992px) {
	.sidebar-bottom {
		padding: 18px 10px 45px 10px;
		text-align: center;
	}
	.sidebar-bottom .logout-btn {
		display: inline-block;
		width: auto;
		padding: 6px 14px;
		border-radius: 10px;
	}
}
</style>
</head>

<body>
	<c:if test="${not empty editSuccess}">
		<script>alert('${editSuccess}');</script>
	</c:if>

	<div class="mypage-layout">

		<aside class="sidebar">
			<div class="profile-section">
				<img id="profileImgPreview" src="<c:choose><c:when test='${not empty member.profile_img}'>/profile/img/${member.profile_img}</c:when><c:otherwise>https://img.icons8.com/ios-glyphs/60/000000/user.png</c:otherwise></c:choose>" class="profile-img" alt="프로필 이미지" data-bs-toggle="modal" data-bs-target="#profileImgModal">
				<div>
					<div class="profile-name">${member.nickname}</div>
					<security:authorize access="isAuthenticated() and principal.memberDTO.provider == 'LOCAL'">
						<a href="/edit" class="profile-edit-btn mt-1">회원 정보 수정</a>
					</security:authorize>

					<security:authorize access="isAuthenticated() and principal.memberDTO.provider == 'NAVER'">
						<a href="/naver-edit" class="profile-edit-btn mt-1">회원 정보 수정</a>
					</security:authorize>
				</div>
			</div>

			<div class="sidebar-right d-flex d-lg-none">
				<div class="mobile-actions">
					<button id="alertBtnSm" type="button" class="icon-btn" title="알림">
						<i class="fas fa-bell"></i> <span id="notify-unread-count-sm" class="badge unread-count-badge" style="display: none"></span>
					</button>

					<a href="/chat" class="icon-btn" title="쪽지" style="text-decoration: none"> <i class="fas fa-envelope"></i> <span id="total-unread-count" class="badge unread-count-badge" style="display: none"></span>
					</a>
				</div>
				<button class="logout-btn logout-btn-sm" onclick="location.href='/logout'">로그아웃</button>
			</div>

			<div class="sidebar-bottom d-none d-lg-block">
				<button class="logout-btn" onclick="location.href='/logout'">로그아웃</button>

				<security:authorize access="isAuthenticated()">
					<form action="/withdraw" method="post" onsubmit="return confirm('정말 회원을 탈퇴하시겠습니까?');" style="margin-top: 8px;">
						<input type="hidden" name="_method" value="delete" /> <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<button type="submit" style="background: none; border: none; padding: 0; margin-top: 6px; color: #888; font-size: 0.85rem; cursor: pointer;">회원 탈퇴</button>
					</form>
				</security:authorize>
			</div>

		</aside>


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
								<img id="modalProfilePreview" src="<c:choose><c:when test='${not empty member.profile_img}'>/profile/img/${member.profile_img}</c:when><c:otherwise>https://img.icons8.com/ios-glyphs/60/000000/user.png</c:otherwise></c:choose>" class="profile-img" style="width: 100px; height: 100px;" alt="미리보기">
							</div>
							<input type="file" name="profileImg" id="modalProfileImgInput" accept="image/*" class="form-control" />
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-warning">저장하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>


		<div class="mypage-main">
			<div class="main-header">
				<button id="alertBtn" type="button" class="icon-btn" data-bs-html="true" data-bs-container="body" title="알림">
					<i class="fas fa-bell"></i> <span id="notify-unread-count" class="badge unread-count-badge" style="display: none"></span>
				</button>
				<a href="/chat" class="icon-btn" title="쪽지" style="text-decoration: none"> <i class="fas fa-envelope"></i> <span id="total-unread-count-sm" class="badge unread-count-badge" style="display: none"></span>
				</a>

			</div>

			<div id="popover-content" class="d-none"></div>


			<div class="main-board">
				<div class="top-grid">
					<div class="card">

						<a href="/free" class="stretched-link"></a> <img src="https://img.icons8.com/color/48/speech-bubble--v1.png" alt=""> <span>소통 커뮤니티</span>
					</div>

					<div class="card">

						<a href="/flag" class="stretched-link"></a> <img src="https://img.icons8.com/color/48/faq.png" alt=""> <span>제보 및 신고 커뮤니티</span>
					</div>

					<div class="card">

						<a href="/info" class="stretched-link"></a> <img src="https://img.icons8.com/color/48/police-badge.png" alt=""> <span>아동 범죄 발생</span>
					</div>

					<div class="card">

						<a href="/map/" class="stretched-link"></a> <img src="https://img.icons8.com/color/48/worldwide-location.png" alt=""> <span>어린이 범죄 예방 지도</span>
					</div>
				</div>

				<div class="middle-grid">

					<div class="card">
						<div class="card-body">
							<span>자녀 등록</span><br> <a href="/cert/my" class="btn btn-warning btn-sm mt-2">바로가기</a>
						</div>
					</div>
					<div class="card">
						<div class="card-body">
							<span>내가 작성한 글</span><br> <a href="/myPost" class="btn btn-warning btn-sm mt-2">바로가기</a>
						</div>
					</div>
					<div class="card">
						<div class="card-body">
							<span>내가 작성한 댓글</span><br> <a href="/myComment" class="btn btn-warning btn-sm mt-2">바로가기</a>
						</div>
					</div>
				</div>


				<div class="bottom-grid">
					<div class="card news-card">
						<div class="card-body">
							<h6 class="mb-3">내 소식</h6>

							<div class="notify-scroll">
								<div class="notification-list" id="notifyList">
									<c:forEach var="notify" items="${notifyList}">
										<c:choose>
											<c:when test="${notify.type == 'COMMENT'}">

												<div class="notification-item">

													<div class="notify-header">
														<span class="notify-icon">[댓글]💬</span>
													</div>
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

												<div class="notification-item">

													<div class="notify-header">
														<span class="notify-icon">[위험]🚨</span>
													</div>
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

								<div class="modal fade" id="dangerModal" tabindex="-1" role="dialog">
									<div class="modal-dialog" role="document">
										<div class="modal-content">
											<div class="modal-header">
												<h5 class="modal-title">📢 위험 알림</h5>
											</div>
											<div class="modal-body"></div>
											<div class="modal-footer">
												<button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
											</div>
										</div>
									</div>
								</div>

							</div>
						</div>
					</div>

					<div class="card trust-card">
						<div class="card-body">
							<div class="d-flex align-items-center mb-2">
								<span style="font-weight: 600; font-size: 1.08rem;">신뢰도 점수판</span> <span class="donut-grade-badge"> <c:choose>
										<c:when test="${fn:trim(trustScore.grade) eq '새싹 보호자'}">🌱 새싹 보호자</c:when>
										<c:when test="${fn:trim(trustScore.grade) eq '안심 지킴이'}">🏠 안심 지킴이</c:when>
										<c:when test="${fn:trim(trustScore.grade) eq '최고 안전 수호자'}">🏆 최고 안전 수호자</c:when>
									</c:choose> (${trustScore.totalScore}점)
								</span>
							</div>

							<div class="donut-box">
								<canvas id="trustDonut"></canvas>
								<div class="donut-labels">
									<span><span class="donut-label-dot" style="background: #4bc0c0"></span>제보 ${trustScore.reportCount}</span> <span><span class="donut-label-dot" style="background: #f6a623"></span>위탁 ${trustScore.entrustCount}</span> <span><span class="donut-label-dot" style="background: #63a4fa"></span>댓글 ${trustScore.commentCount}</span>
								</div>
								<div class="trust-gauge-wrap">
									<div class="trust-gauge-bar-bg">
										<div class="trust-gauge-bar" id="trustGaugeBar"></div>
									</div>
									<div class="trust-gauge-label" id="trustGaugeText"></div>
								</div>
							</div>

							<button type="button" class="btn btn-light rounded-circle" style="position: absolute; top: 20px; right: 22px; width: 28px; height: 28px; padding: 0; border: 1.5px solid #eee; color: #888;" data-bs-toggle="modal" data-bs-target="#trustScoreModal">
								<i class="fas fa-question"></i>
							</button>
						</div>
					</div>

					<div class="modal fade" id="trustScoreModal" tabindex="-1" aria-labelledby="trustScoreModalLabel" aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="trustScoreModalLabel">신뢰도 점수판 안내</h5>
									<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
								</div>
								<div class="modal-body">
									<ul style="padding-left: 1rem;">
										<li><b>제보 횟수</b> : 신고/제보 게시글 수</li>
										<li><b>위탁 횟수</b> : 위탁 게시글 수</li>
										<li><b>댓글</b> : 내가 작성한 댓글 수</li>
										<li><span style="color: #40a048; font-weight: 500;">새싹 보호자(0~9)</span>, <span style="color: #a8743d; font-weight: 500;">안심 지킴이(10~29)</span>, <span style="color: #f6a623; font-weight: 500;">최고 안전 수호자(30+)</span></li>
									</ul>
									<div class="mt-2 text-secondary" style="font-size: 0.98rem;">활동량이 높을수록 점수가 오르고 등급이 상승합니다.</div>
								</div>

								<div class="modal-footer">
									<button type="button" class="btn btn-warning" data-bs-dismiss="modal">확인</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
  document.getElementById('modalProfileImgInput').addEventListener('change', function(event) {
    const reader = new FileReader();
    reader.onload = function(e) {
      document.getElementById('modalProfilePreview').src = e.target.result;
    };
    if (event.target.files.length > 0) {
      reader.readAsDataURL(event.target.files[0]);
    }
  });

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
  } else {
    text = '안심 지킴이까지 <b>' + Math.max(0, 10 - totalScore) + '</b>점 남았어요!';
  }
  gaugeText.innerHTML = text;
</script>

	<script>
  document.addEventListener("DOMContentLoaded", async function () {
    var base = "${pageContext.request.contextPath}" || "";

    var alertBtnIds = ["alertBtn", "alertBtnSm"];
    var notifyBadgeIds = ["notify-unread-count", "notify-unread-count-sm"];

    function setupPopover(btn, contentHtml) {
      if (!btn) return;
      new bootstrap.Popover(btn, {
        html: true,
        container: 'body',
        placement: 'bottom',
        trigger: 'click',
        title: '알림',
        content: contentHtml,
        sanitize: false
      });
    }

    try {
      var res = await fetch(base + "/notify/list", { credentials: "same-origin" });
      if (!res.ok) throw new Error("HTTP " + res.status);
      var items = await res.json();

      var unreadCount = items.filter(n => !n.isRead).length;
      notifyBadgeIds.forEach(function(id){
        var badge = document.getElementById(id);
        if (!badge) return;
        if (unreadCount > 0) { badge.textContent = unreadCount; badge.style.display = "inline-block"; }
        else { badge.style.display = "none"; }
      });

      items.sort((a,b)=>(b.created_at||0)-(a.created_at||0));

      var html = '<div style="max-height:220px; overflow-y:auto;">'
               +   '<ul class="list-unstyled mb-0">';
      if (items.length) {
        for (var i=0;i<items.length;i++){
          var n = items[i] || {};
          var text = n.content || '';
          var board = n.related_board || '';
          var pid   = n.related_post_id || '';
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

      alertBtnIds.forEach(function(id){
        var btn = document.getElementById(id);
        setupPopover(btn, html);
      });

    } catch (e) {
      console.error("notify popover error:", e);
      var fallback = '<div style="max-height:220px; overflow-y:auto;">'
                   +   '<ul class="list-unstyled mb-0"><li>알림을 불러오지 못했습니다</li></ul>'
                   + '</div>';
      alertBtnIds.forEach(function(id){
        var btn = document.getElementById(id);
        if (!btn) return;
        new bootstrap.Popover(btn, {
          html:true, container:'body', placement:'bottom', trigger:'click',
          title:'알림', content:fallback
        });
      });
    }
  });

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
    document.addEventListener("DOMContentLoaded", function () {
        let alerts = [];
        document.querySelectorAll(".danger-alert").forEach(el => {
            alerts.push(el.value);
        });

        if (alerts.length > 0) {
            let message = alerts.join("<br>");
            document.querySelector("#dangerModal .modal-body").innerHTML = message;
            let myModal = new bootstrap.Modal(document.getElementById('dangerModal'), {});
            myModal.show();
        }
    });
</script>
	<script>
    let stompClientHeader = null;
    let isHeaderConnected = false;
    const currentUserId = '${currentUserId}';

    function connectHeader() {
        if (isHeaderConnected) return;
        isHeaderConnected = true;

        const socket = new SockJS('${pageContext.request.contextPath}/chat');
        stompClientHeader = Stomp.over(socket);
        stompClientHeader.debug = null;

        stompClientHeader.connect({}, function (frame) {
            stompClientHeader.subscribe('/user/sub/chat/user/' + currentUserId, function (message) {
                updateHeaderBadge();
            });
        }, function(error) {
            isHeaderConnected = false;
        });
    }

    async function updateHeaderBadge() {
      try {
        const url = '${pageContext.request.contextPath}/chat/totalUnreadCount?_=' + Date.now();
        const res = await fetch(url);
        if (!res.ok) throw new Error('fetch 실패');
        const count = await res.json();

        ['total-unread-count','total-unread-count-sm'].forEach(id => {
          const el = document.getElementById(id);
          if (!el) return;
          if (count > 0) {
            el.textContent = count;
            el.style.display = 'inline';
          } else {
            el.style.display = 'none';
          }
        });
      } catch (e) {
        console.error('쪽지 뱃지 갱신 오류:', e);
      }
    }


    window.addEventListener('load', function() {
        connectHeader();
        updateHeaderBadge();
    });

    window.addEventListener('beforeunload', function() {
        if (stompClientHeader && stompClientHeader.connected) {
            stompClientHeader.disconnect();
        }
        isHeaderConnected = false;
    });
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