<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>실종 게시판</title>
  <script src="https://code.jquery.com/jquery-latest.min.js"></script>
  <style>
    body {
      margin: 0;
      font-family: "Noto Sans KR", sans-serif;
      background-color: #fff8e7;
    }

    /* 상단바 스타일 */
    /* 네비게이션 바 */
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

    /* ✅ hover 시 텍스트 색상만 밝아짐 */
    .main-menu:hover {
      color: #ffffffcc; /* 연한 흰색 */
    }

    /* ✅ 활성 탭 (흰색 배경 & 검정 텍스트) */
    .main-menu.active {
      background-color: white;
      color: #222;
      z-index: 2;
      margin-bottom: 0; /* ❗ 빠져나오지 않도록 */
    }

    /* ✅ 서브 메뉴 */
    .sub-menu {
      display: none;
      position: absolute;
      top: 100%;
      left: 0;
      width: 100%; /* ✅ 메인 메뉴와 너비 일치 */
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

    /* ✅ hover 시 텍스트 색상만 진해짐 */
    .sub-menu li:hover {
      color: #000;
    }

    /* 오른쪽 아이콘 */
    .icons {
      display: flex;
      gap: 16px;
      font-size: 20px;
      padding-bottom: 10px;
    }

    /* 게시글 스타일 */
    .post-container {
      max-width: 900px;
      margin: 40px auto;
      background: #fff;
      padding: 32px;
      border-radius: 18px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }
    .post-title {
      font-size: 22px;
      font-weight: bold;
      margin-bottom: 12px;
    }
    .post-meta {
      color: #999;
      font-size: 14px;
      margin-bottom: 24px;
    }
    .post-content {
      white-space: pre-wrap;
      line-height: 1.6;
      font-size: 16px;
      margin-bottom: 20px;
    }
    .post-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      font-size: 14px;
      color: #777;
      cursor:pointer;
    }


    /* 댓글 스타일 */
    .comments-section {
      margin-top: 40px;
    }
    .comment-form {
      display: flex;
      gap: 10px;
      margin-top: 16px;
    }
    .comment-form input[type=text] {
      padding: 8px 10px;
      flex: 1;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 14px;
    }
    .comment-form button {
      padding: 8px 16px;
      background-color: #ffc727;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: bold;
    }
    .comment-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 16px;
      text-align: center;
    }
    .comment-table th, .comment-table td {
      padding: 10px;
      border: 1px solid #ddd;
      font-size: 14px;
    }

    .preview-img {
      max-width: 250px;
      border-radius: 10px;
      margin-top: 10px;
    }

    .comment-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-top: 24px;
    }

    .comment-card {
      display: flex;
      padding: 16px;
      background: #fff;
      border-radius: 12px;
      border: 1px solid #eee;
      align-items: flex-start;
    }

    .comment-avatar img {
      width: 48px;
      height: 48px;
      border-radius: 50%;
      object-fit: cover;
    }

    .comment-body {
      margin-left: 12px;
      flex: 1;
    }

    .comment-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 14px;
      color: #555;
      margin-bottom: 6px;
    }

    .comment-nickname {
      font-weight: bold;
    }

    .comment-date {
      font-size: 12px;
      color: #aaa;
      margin-left: auto;
      margin-right: 8px;
    }

    .comment-delete {
      font-size: 12px;
      color: #999;
      cursor: pointer;
    }

    .comment-delete:hover {
      color: #f44;
    }

    .comment-content {
      font-size: 15px;
      color: #333;
      white-space: pre-wrap;
    }

    .comment-input-wrapper {
      display: flex;
      margin-top: 24px;
      border: 1px solid #ccc;
      border-radius: 12px;
      overflow: hidden;
      background: #fff;
    }

    .comment-input-wrapper textarea {
      flex: 1;
      padding: 12px;
      border: none;
      resize: none;
      font-size: 14px;
      outline: none;
    }

    .comment-input-wrapper button {
      background-color: #ffc727;
      border: none;
      padding: 0 20px;
      font-weight: bold;
      font-size: 14px;
      cursor: pointer;
    }

    .like-btn .heart {
        font-size: 1.4em;
        vertical-align: middle;
        transition: color 0.15s;
    }
    .like-btn.liked .heart {
        color: #f44336;
    }
    .like-btn .heart {
        color: #fff;
        text-shadow: 0 0 2px #d1d1d1;
    }
    .like-btn {
        border: 1.5px solid #f44336 !important;
    }
  </style>
</head>
<body>

<!-- ✅ 상단바 시작 -->
<header>
  <nav class="top-nav">
    <div class="logo-section">
      <img src="/logo.png" alt="logo">
    </div>
    <ul class="nav-tabs">
      <li class="main-menu">
        마이페이지
      </li>
      <li class="main-menu">
        범죄 예방 지도
      </li>
      <li class="main-menu active">
        커뮤니티
        <ul class="sub-menu">
          <li>자유</li>
          <li>위탁</li>
          <li>실종 및 유괴</li>
        </ul>
      </li>
      <li class="main-menu">
        제보 및 신고
      </li>
      <li class="main-menu">
        정보 공유
      </li>
    </ul>
    <div class="icons">
      <span class="icon">🔔</span>
      <span class="icon">✉️</span>
    </div>
  </nav>
</header>

<!-- ✅ 상단바 끝 -->

<div class="post-container">
    <div class="post-title">${miss.title}</div>
    <div class="post-meta">${miss.nickname}</div>
    <div class="post-content">${miss.content}</div>

    <c:forEach items="${fileList}" var="file">
    <c:if test="${file.originalFileName.endsWith('.jpg') || file.originalFileName.endsWith('.png')}">
      <img class="preview-img" src="/miss/preview?fileName=${file.storedFileName}" />
    </c:if>
    </c:forEach>

    <div class="mb-2">
        <button type="button" class="btn like-btn ${miss != null && miss.liked ? 'liked' : ''}" id="likeBtn">
            <span class="heart">${miss != null && miss.liked ? '❤️' : '🤍'}</span>
            <span id="likeCount">${miss != null ? miss.like_count : 0}</span>
        </button>
    </div>

    <div class="post-actions">
    <span onclick="updateFn()">수정</span>
    <span onclick="deleteFn()">삭제</span>
    <span>신고</span>
    </div>

    <div class="comment-input-wrapper">
      <input id="nickname" placeholder="작성자"></textarea>
      <textarea id="content" placeholder="댓글을 작성해주세요"></textarea>
      <button onclick="commentWrite()">작성</button>
    </div>

    <div class="comment-list">
      <c:forEach items="${commentList}" var="comment">
        <div class="comment-card">
          <div class="comment-avatar">
            <img src="/img/avatar${comment.id % 3 + 1}.png" alt="profile" />
          </div>
          <div class="comment-body">
            <div class="comment-header">
              <span class="comment-nickname">${comment.nickname}</span>
              <span class="comment-date"><fmt:formatDate value="${comment.created_at}" pattern="yyyy.MM.dd"/></span>
              <span class="comment-delete" onclick="commentDelete(${comment.id})">삭제</span>
            </div>
            <div class="comment-content">${comment.content}</div>
          </div>
        </div>
      </c:forEach>
    </div>

</div>

<script>
  const updateFn = () => {
    location.href = "/miss/update/${miss.id}";
  }
  const deleteFn = () => {
    const confirmed = confirm("정말 삭제하시겠습니까?");
    if (confirmed) {
      location.href = "/miss/delete?id=${miss.id}";
    }
  }


  const commentDelete = (commentId) => {
    const confirmed = confirm("댓글을 삭제하시겠습니까?");
    if (confirmed) {
      location.href = "/missComment/delete?id=" + commentId;
    }
  }
  const commentWrite = () => {
    const nickname = document.getElementById("nickname").value;
    const content = document.getElementById("content").value;
    const postId = "${miss.id}";
    $.ajax({
      type: "post",
      url: "/missComment/save",
      data: {
        nickname: nickname,
        content: content,
        post_id: postId
      },
      dataType: "json",
      success: function(commentList) {
        location.reload();
      },
      error: function() {
        alert("댓글 등록 실패");
      }
    });
  }
</script>
<script>
    $(document).ready(function () {
    // 좋아요 버튼
        $('#likeBtn').click(function(){
            const missId = '${miss.id}';
            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/missLike/like/' + missId,
                success: function(data){
                    if(data.error){
                        alert(data.error);
                        return;
                    }
                    $('#likeCount').text(data.likeCount);
                    $('#likeCountDisplay').text(data.likeCount);
                    // 하트 토글
                    if(data.liked){
                        $('#likeBtn').addClass('liked');
                        $('#likeBtn .heart').text('❤️');
                    } else {
                        $('#likeBtn').removeClass('liked');
                        $('#likeBtn .heart').text('🤍');
                    }
                },
                error: function(xhr) {
                    try {
                        const data = JSON.parse(xhr.responseText);
                        alert(data.error || "좋아요 처리 실패!");
                    } catch (e) {
                        alert("좋아요 처리 실패!");
                    }
                }
            });
        });

    });
</script>
</body>
</html>
