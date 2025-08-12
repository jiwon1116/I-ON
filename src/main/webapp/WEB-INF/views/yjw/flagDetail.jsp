<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>게시글 상세보기</title>
  <c:set var="CTX" value="${pageContext.request.contextPath}" />

  <!-- libs -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
  <!-- 페이지 전용 CSS (위 detail.css 내용으로 교체) -->
  <link href="${CTX}/resources/css/detail.css" rel="stylesheet" />

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${CTX}/resources/js/badge.js"></script>
</head>
<body>

<!-- 헤더는 jsp:include 로 (contentType 충돌 방지) -->
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="info-page-wrap">
  <div class="info-card">

    <!-- 상단: 제목 + 액션 -->
    <div class="info-head">
      <h1 class="info-title"><c:out value="${flag.title}" /></h1>

      <div class="info-actions">
        <security:authentication property="principal.username" var="loginUserId"/>
        <c:if test="${loginUserId eq flag.userId or isAdmin}">
          <a class="link" href="${CTX}/flag/update/${flag.id}">수정</a>
          <a class="link" href="${CTX}/flag/delete/${flag.id}"
             onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        </c:if>
        <c:if test="${loginUserId ne flag.userId}">
          <button type="button" id="reportBtn">신고</button>
        </c:if>
      </div>
    </div>

     <!-- 메타 -->
                <div class="info-meta">
                  <c:if test="${not empty flag.nickname}">
                    <div class="info-author">
                      <span class="js-user" data-nickname="${flag.nickname}">
                        <a href="${CTX}/othermemberprofile/checkprofile?nickname=${flag.nickname}">
                          <c:out value="${flag.nickname}" />
                        </a>
                      </span>
                    </div>
                  </c:if>

                  <div>
                    <i class="bi bi-clock me-1"></i>
                    <c:if test="${flag.created_at != null}">
                      <fmt:formatDate value="${flag.created_at}" pattern="yyyy.MM.dd HH:mm"/>
                    </c:if>
                  </div>

                  <div>
                    <i class="bi bi-eye me-1"></i>
                    <span id="viewCount">${flag.view_count}</span>
                  </div>
                </div>

    <!-- 첨부 이미지(있으면) -->
    <c:if test="${not empty fileList}">
      <c:set var="imgCount" value="0"/>
      <div class="info-image-grid">
        <c:forEach var="file" items="${fileList}">
          <c:set var="lower" value="${fn:toLowerCase(file.storedFileName)}"/>
          <c:if test="${fn:endsWith(lower, '.jpg') or fn:endsWith(lower, '.jpeg') or fn:endsWith(lower, '.png') or fn:endsWith(lower, '.gif')}">
            <img src="${CTX}/flag/preview?fileName=${file.storedFileName}" alt="${file.originalFileName}"/>
            <c:set var="imgCount" value="${imgCount + 1}"/>
          </c:if>
        </c:forEach>
      </div>
      <!-- 이미지 외 파일(문서 등) 링크 표시 -->
      <ul class="mt-2" style="list-style:none; padding:0;">
        <c:forEach var="file" items="${fileList}">
          <c:set var="lower" value="${fn:toLowerCase(file.storedFileName)}"/>
          <c:if test="${!(fn:endsWith(lower, '.jpg') or fn:endsWith(lower, '.jpeg') or fn:endsWith(lower, '.png') or fn:endsWith(lower, '.gif'))}">
            <li>
              <a href="${CTX}/flag/preview?fileName=${file.storedFileName}" target="_blank">
                <c:out value="${file.originalFileName}" />
              </a>
            </li>
          </c:if>
        </c:forEach>
      </ul>
    </c:if>

    <!-- 본문 -->
    <div class="info-content">
      <textarea readonly>${flag.content}</textarea>
    </div>

    <!-- 좋아요/카운트 -->
    <div class="info-stats">
      <button type="button" class="info-like-btn ${flag.liked ? 'liked' : ''}" id="likeBtn">
        <span class="heart">${flag.liked ? '❤️' : '🤍'}</span>
        <span id="likeCount">${flag.like_count}</span>
      </button>
      <span>좋아요: <span id="likeCountDisplay">${flag.like_count}</span></span>
      <span>댓글: ${fn:length(flagCommentDTOList)}</span>
    </div>

    <!-- 댓글 입력 -->
    <div class="info-comment-editor">
      <form id="commentForm" style="display:contents">
        <input type="hidden" name="post_id" id="post_id" value="${flag.id}"/>
        <textarea id="content" name="content" placeholder="댓글을 작성해주세요"></textarea>
        <button type="submit">작성</button>
      </form>
    </div>

    <!-- 댓글 목록 -->
    <section class="info-comment-wrap">
      <div class="info-comment-list" id="commentList">
        <c:if test="${not empty flagCommentDTOList}">
          <c:forEach var="comment" items="${flagCommentDTOList}">
            <div class="info-comment-item">
              <div class="info-comment-avatar"></div>
              <div class="info-comment-body">
                <div class="info-comment-row">
                  <div class="info-comment-writer">
                    <span class="js-user" data-nickname="${comment.nickname}">
                      <a href="${CTX}/othermemberprofile/checkprofile?nickname=${comment.nickname}">
                        <c:out value="${comment.nickname}" />
                      </a>
                    </span>
                  </div>
                  <div class="info-comment-meta">
                    <span class="info-comment-date">
                      <fmt:formatDate value="${comment.created_at}" pattern="yyyy.MM.dd HH:mm"/>
                    </span>
                    <security:authentication property="principal.username" var="loginUserId"/>
                    <c:if test="${comment.userId eq loginUserId or isAdmin}">
                      <button type="button" class="info-btn-del"
                              onclick="deleteComment(${comment.id},${comment.post_id})">삭제</button>
                    </c:if>
                  </div>
                </div>
                <div class="info-comment-content">
                  ${comment.content}
                </div>
              </div>
            </div>
          </c:forEach>
        </c:if>
        <c:if test="${empty flagCommentDTOList}">
          <div class="p-4 text-muted">첫 댓글을 남겨보세요.</div>
        </c:if>
      </div>
    </section>

    <!-- 하단 버튼 -->
    <div class="info-bottom-actions">
      <button type="button" class="info-btn-secondary" onclick="location.href='${CTX}/flag'">목록</button>
    </div>

  </div>
</div>

<!-- 신고 모달 -->
<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form id="reportForm">
      <div class="modal-content">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title" id="reportModalLabel">게시글 신고</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="postId" value="${flag.id}" />
          <div class="mb-3">
            <label for="reportType" class="form-label">신고 유형</label>
            <select class="form-select" name="type" id="reportType" required>
              <option value="">-- 신고 유형 선택 --</option>
              <option value="CURSE">욕설/비방</option>
              <option value="SPAM">스팸/광고</option>
              <option value="IMPROPER">부적절한 콘텐츠</option>
            </select>
            <label for="reportReason" class="form-label mt-2">신고 사유</label>
            <textarea class="form-control" name="reason" id="reportReason" rows="4" required placeholder="신고 사유를 입력하세요"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-brand text-dark">신고하기</button>
        </div>
      </div>
    </form>
  </div>
</div>

<script>
  const CTX = '${CTX}';

  // 댓글 등록
  $('#commentForm').on('submit', function (e) {
    e.preventDefault();
    const content = $('#content').val().trim();
    const post_id = $('#post_id').val();
    if (!post_id || !content) return alert("내용을 입력해주세요.");

    $.ajax({
      type: 'POST',
      url: CTX + '/FlagComment/write',
      data: { content, post_id },
      dataType: 'json',
      success: function(){ window.location.reload(); },
      error: function(){ alert("댓글 등록 실패"); }
    });
  });

  // 좋아요 토글 (이모지 하트 스타일)
  $('#likeBtn').on('click', function(){
    const flagId = '${flag.id}';
    $.ajax({
      type: 'POST',
      url: CTX + '/flagLike/like/' + flagId,
      success: function(data){
        if(data && data.error){ alert(data.error); return; }
        $('#likeCount, #likeCountDisplay').text(data.likeCount);
        const $btn = $('#likeBtn');
        const $heart = $btn.find('.heart');
        if(data.liked){ $btn.addClass('liked'); $heart.text('❤️'); }
        else { $btn.removeClass('liked'); $heart.text('🤍'); }
      },
      error: function(){ alert('좋아요 처리 실패!'); }
    });
  });

  // 신고 모달
  $('#reportBtn').on('click', function(){
    new bootstrap.Modal(document.getElementById('reportModal')).show();
  });

  // 신고 제출
  $('#reportForm').on('submit', function(e){
    e.preventDefault();
    const postId = $('input[name="postId"]').val();
    const type   = $('#reportType').val();
    const reason = $('#reportReason').val();
    if(!reason.trim()) return alert("신고 사유를 입력하세요.");

    const payload = { targetBoard:'FLAG', targetContentId: postId, type, description: reason };
    $.ajax({
      type:'POST',
      url: CTX + '/report',
      contentType:'application/json; charset=UTF-8',
      dataType:'text',
      data: JSON.stringify(payload),
      success: function(){
        alert('신고가 접수되었습니다.');
        bootstrap.Modal.getInstance(document.getElementById('reportModal'))?.hide();
      },
      error: function(){ alert("신고 접수에 실패했습니다."); }
    });
  });

  // 댓글 삭제
  function deleteComment(id, post_id){
    if(!confirm("정말 삭제하시겠습니까?")) return;
    $.ajax({
      type:'GET',
      url: CTX + '/FlagComment/delete?id='+id+'&post_id='+post_id,
      dataType:'json',
      success: function(){ window.location.reload(); },
      error: function(){ alert("댓글 삭제 실패"); }
    });
  }
  window.deleteComment = deleteComment;
</script>
</body>
</html>
