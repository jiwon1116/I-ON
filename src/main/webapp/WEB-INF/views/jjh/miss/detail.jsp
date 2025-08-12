<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>실종 게시판</title>
  <meta name="ctx" content="${pageContext.request.contextPath}"/>

  <!-- CSS: 공통 + 상세 (detail.css에 너가 준 스타일이 있다고 가정) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/detail.css"/>

  <!-- 라이브러리/스크립트 -->
  <script src="https://code.jquery.com/jquery-latest.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/badge.js"></script>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="board-wrap">

  <!-- ===== 글 본문 ===== -->
  <article class="post">
    <header class="post-head">
      <h1 class="post-title">${miss.title}</h1>

      <div class="post-meta">
        <span class="avatar"></span>
        <div>
          <c:if test="${not empty miss.nickname}">
            <span class="js-user" data-nickname="${miss.nickname}">
              <a href="${pageContext.request.contextPath}/othermemberprofile/checkprofile?nickname=${miss.nickname}">
                ${miss.nickname}
              </a>
            </span>
          </c:if>
        </div>

        <div class="ms-auto d-flex align-items-center gap-3">
          <security:authentication property="principal.username" var="loginUserId"/>
          <c:if test="${loginUserId eq miss.userId || isAdmin}">
            <a href="javascript:void(0)" class="link" onclick="updateFn()">수정</a>
            <a href="javascript:void(0)" class="link" onclick="deleteFn()">삭제</a>
          </c:if>
          <c:if test="${loginUserId ne miss.userId}">
            <button type="button" id="reportBtn" class="btn btn-sm btn-outline-danger">🚩 신고</button>
          </c:if>
        </div>
      </div>
    </header>

    <div class="post-body">
      ${miss.content}
    </div>

    <!-- 첨부 -->
    <c:if test="${not empty fileList}">
      <section class="attach">
        <ul>
          <c:forEach items="${fileList}" var="file">
            <c:choose>
              <c:when test="${file.originalFileName.endsWith('.jpg') || file.originalFileName.endsWith('.png') || file.originalFileName.endsWith('.jpeg') || file.originalFileName.endsWith('.gif')}">
                <li>
                  <img class="preview-img"
                       src="${pageContext.request.contextPath}/miss/preview?fileName=${file.storedFileName}"
                       alt="${file.originalFileName}" />
                </li>
              </c:when>
              <c:otherwise>
                <li>
                  <a href="${pageContext.request.contextPath}/miss/preview?fileName=${file.storedFileName}" target="_blank">
                    ${file.originalFileName}
                  </a>
                </li>
              </c:otherwise>
            </c:choose>
          </c:forEach>
        </ul>
      </section>
    </c:if>

    <!-- 하단 액션 -->
    <div class="post-actions">
          <div class="stats">
            <span><i class="bi bi-heart-fill text-danger"></i><span id="likeCountDisplay">${miss != null ? miss.like_count : 0}</span></span>
            <span><i class="bi bi-chat-left-text"></i>${commentList != null ? commentList.size() : 0}</span>
            <span class="text-muted">조회 <span id="viewCount">${miss.view_count}</span></span>
          </div>

      <!-- 좋아요 버튼: 기존 스크립트 훅(id/class) 유지 -->
      <button type="button" class="btn-like ${miss != null && miss.liked ? 'liked' : ''}" id="likeBtn">
        <span class="heart">${miss != null && miss.liked ? '❤️' : '🤍'}</span>
        <span id="likeCount">${miss != null ? miss.like_count : 0}</span>
      </button>
    </div>
  </article>

  <!-- ===== 신고 모달 ===== -->
  <div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <form id="reportForm">
        <div class="modal-content">
          <div class="modal-header bg-danger text-white">
            <h5 class="modal-title" id="reportModalLabel">게시글 신고</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>
          <div class="modal-body">
            <input type="hidden" name="postId" value="${miss.id}" />
            <div class="mb-3">
              <label for="reportType" class="form-label">신고 유형</label>
              <select class="form-select" name="type" id="reportType" required>
                <option value="" hidden selected>-- 신고 유형 선택 --</option>
                <option value="CURSE">욕설/비방</option>
                <option value="SPAM">스팸/광고</option>
                <option value="IMPROPER">부적절한 콘텐츠</option>
              </select>
              <label for="reportReason" class="form-label mt-2">신고 사유</label>
              <textarea class="form-control" name="reason" id="reportReason" required placeholder="신고 사유를 입력하세요"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            <button type="submit" class="btn btn-danger">신고하기</button>
          </div>
        </div>
      </form>
    </div>
  </div>

  <!-- ===== 댓글 입력 ===== -->
  <form class="cmt-form" onsubmit="return false;">
    <input type="hidden" id="nickname" value="${member.nickname}" />
    <div class="cmt-input">
      <textarea id="content" placeholder="댓글을 작성해주세요"></textarea>
      <button type="button" class="cmt-send" onclick="commentWrite()">작성</button>
    </div>
  </form>

  <!-- ===== 댓글 목록 ===== -->
  <section class="comments">
    <div class="comments-head">
      댓글 <span class="text-muted">(${commentList != null ? commentList.size() : 0})</span>
    </div>
    <div id="commentList">
      <c:forEach items="${commentList}" var="comment">
        <div class="cmt-item">
          <div class="cmt-top">
            <span class="avatar"></span>
            <div class="flex-grow-1">
              <span class="js-user" data-nickname="${comment.nickname}">
                <a href="${pageContext.request.contextPath}/othermemberprofile/checkprofile?nickname=${comment.nickname}">
                  ${comment.nickname}
                </a>
              </span>
              <span class="ms-2"><fmt:formatDate value="${comment.created_at}" pattern="yyyy.MM.dd"/></span>
            </div>
            <security:authentication property="principal.username" var="loginUserId"/>
            <c:if test="${loginUserId eq comment.userId || isAdmin}">
              <div class="cmt-actions">
                <button class="btn btn-sm btn-outline-danger" onclick="commentDelete('${comment.id}')">삭제</button>
              </div>
            </c:if>
          </div>
          <div class="cmt-body">${comment.content}</div>
        </div>
      </c:forEach>
      <c:if test="${empty commentList}">
        <div class="p-4 text-muted">첫 댓글을 남겨보세요.</div>
      </c:if>
    </div>
  </section>

</div><!-- /.board-wrap -->

<!-- ===== 기능 스크립트 (기존 로직 유지) ===== -->
<script>
  const updateFn = () => { location.href = "/miss/update/${miss.id}"; }
  const deleteFn = () => {
    if (confirm("정말 삭제하시겠습니까?")) {
      location.href = "/miss/delete?id=${miss.id}";
    }
  }
  const commentDelete = (commentId) => {
    if (confirm("댓글을 삭제하시겠습니까?")) {
      location.href = "/missComment/delete?id=" + commentId;
    }
  }
  const commentWrite = () => {
    const nickname = document.getElementById("nickname").value;
    const content  = document.getElementById("content").value;
    const postId   = "${miss.id}";
    if (!postId || !content) { alert("내용을 입력해주세요."); return; }

    $.ajax({
      type: "post",
      url: "/missComment/save",
      data: { content, post_id: postId, nickname },
      dataType: "json",
      success: function(){ location.reload(); },
      error:   function(){ alert("댓글 등록 실패"); }
    });
  }
</script>

<script>
  $(function () {
    // 좋아요
    $('#likeBtn').click(function(){
      const missId = '${miss.id}';
      $.ajax({
        type: 'POST',
        url: '${pageContext.request.contextPath}/missLike/like/' + missId,
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
          try{
            const data = JSON.parse(xhr.responseText);
            alert(data.error || "좋아요 처리 실패!");
          }catch(e){ alert("좋아요 처리 실패!"); }
        }
      });
    });

    // 신고 모달
    $('#reportBtn').click(function(){
      const modal = new bootstrap.Modal(document.getElementById('reportModal'));
      modal.show();
    });

    // 신고 제출
    $('#reportForm').submit(function(e){
      e.preventDefault();
      const postId = $('input[name="postId"]').val();
      const type   = $('#reportType').val();
      const reason = $('#reportReason').val();
      const board  = 'MISS';
      if(!reason.trim()) return alert("신고 사유를 입력해주세요.");

      const payload = { targetBoard: board, targetContentId: postId, type, description: reason };
      $.ajax({
        type: 'POST',
        url: '${pageContext.request.contextPath}/report',
        contentType: 'application/json; charset=UTF-8',
        dataType: 'text',
        data: JSON.stringify(payload),
        success: function(){
          alert('신고가 접수되었습니다.');
          const modal = bootstrap.Modal.getInstance(document.getElementById('reportModal'));
          modal && modal.hide();
        },
        error: function(){ alert("신고 접수에 실패했습니다."); }
      });
    });
  });
</script>

</body>
</html>
