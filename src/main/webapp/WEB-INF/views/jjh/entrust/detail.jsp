<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>위탁 게시판</title>
    <!-- badge.js가 API 호출할 때 쓸 컨텍스트 -->
    <meta name="ctx" content="${pageContext.request.contextPath}"/>

    <script src="https://code.jquery.com/jquery-latest.min.js"></script>

    <script src="${pageContext.request.contextPath}/resources/js/badge.js"></script>

  <style>
    body {
      margin: 0;
      font-family: "Noto Sans KR", sans-serif;
      background-color: #fff8e7;
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

<div class="post-container">
    <div class="post-title">${entrust.title}</div>

    <!-- 작성자 닉네임 + 배지 -->
    <div class="post-meta">
      <c:if test="${not empty entrust.nickname}">
        <span class="js-user" data-nickname="${entrust.nickname}">${entrust.nickname}</span>
      </c:if>
    </div>

    <div class="post-content">${entrust.content}</div>

    <c:forEach items="${fileList}" var="file">
      <c:if test="${file.originalFileName.endsWith('.jpg') || file.originalFileName.endsWith('.png')}">
        <img class="preview-img" src="/entrust/preview?fileName=${file.storedFileName}" />
      </c:if>
    </c:forEach>

    <div class="mb-2">
        <button type="button" class="btn like-btn ${entrust != null && entrust.liked ? 'liked' : ''}" id="likeBtn">
            <span class="heart">${entrust != null && entrust.liked ? '❤️' : '🤍'}</span>
            <span id="likeCount">${entrust != null ? entrust.like_count : 0}</span>
        </button>
    </div>
    <!-- 스크립트에서 갱신하는 표시 -->
    좋아요: <span id="likeCountDisplay">${entrust != null ? entrust.like_count : 0}</span>

    <div class="post-actions">
      <!-- 로그인 유저아이디 확보(헤더에서 이미 했다면 중복되어도 OK) -->
      <security:authentication property="principal.username" var="loginUserId"/>
      <c:if test="${loginUserId eq entrust.userId || isAdmin}">
        <span onclick="updateFn()">수정</span>
        <span onclick="deleteFn()">삭제</span>
      </c:if>
    </div>

    <div class="comment-input-wrapper">
      <input type="hidden" id="nickname" value="${member.nickname}" />
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
              <!-- 댓글 닉네임 + 배지 -->
              <span class="comment-nickname">
                <span class="js-user" data-nickname="${comment.nickname}">${comment.nickname}</span>
              </span>
              <span class="comment-date"><fmt:formatDate value="${comment.created_at}" pattern="yyyy.MM.dd"/></span>
              <c:if test="${loginUserId eq comment.userId || isAdmin}">
                <span class="comment-delete" onclick="commentDelete('${comment.id}')">삭제</span>
              </c:if>
            </div>
            <div class="comment-content">${comment.content}</div>
          </div>
        </div>
      </c:forEach>
    </div>

</div>

<script>
  const updateFn = () => {
    location.href = "/entrust/update/${entrust.id}";
  }
  const deleteFn = () => {
    const confirmed = confirm("정말 삭제하시겠습니까?");
    if (confirmed) {
      location.href = "/entrust/delete?id=${entrust.id}";
    }
  }

  const commentDelete = (commentId) => {
    const confirmed = confirm("댓글을 삭제하시겠습니까?");
    if (confirmed) {
      location.href = "/entrustComment/delete?id=" + commentId;
    }
  }

  const commentWrite = () => {
    const nickname = document.getElementById("nickname").value;
    const content = document.getElementById("content").value.trim();
    const postId = "${entrust.id}";

    if (!postId || !content) {
      alert("내용을 입력해주세요.");
      return;
    }

    $.ajax({
      type: "post",
      url: "/entrustComment/save",
      data: { content, post_id: postId, nickname },
      dataType: "json",
      success: function() { location.reload(); },
      error: function() { alert("댓글 등록 실패"); }
    });
  }
</script>

<script>
  $(function () {
    // 좋아요 버튼
    $('#likeBtn').click(function(){
      const entrustId = '${entrust.id}';
      $.ajax({
        type: 'POST',
        url: '${pageContext.request.contextPath}/entrustLike/like/' + entrustId,
        success: function(data){
          if(data.error){ alert(data.error); return; }
          $('#likeCount').text(data.likeCount);
          $('#likeCountDisplay').text(data.likeCount);
          if(data.liked){
            $('#likeBtn').addClass('liked');
            $('#likeBtn .heart').text('❤️');
          } else {
            $('#likeBtn').removeClass('liked');
            $('#likeBtn .heart').text('🤍');
          }
        },
        error: function(xhr){
          try { const d = JSON.parse(xhr.responseText); alert(d.error || "좋아요 처리 실패!"); }
          catch(e){ alert("좋아요 처리 실패!"); }
        }
      });
    });
  });
</script>
</body>
</html>