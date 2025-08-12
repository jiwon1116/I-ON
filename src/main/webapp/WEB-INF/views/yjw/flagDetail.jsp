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
  <!-- 페이지 전용 CSS -->
    <link href="${CTX}/resources/css/detail.css" rel="stylesheet" />

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

  <!-- 배지(헤더에서 이미 넣었으면 이 줄은 제거) -->
  <script src="${CTX}/resources/js/badge.js"></script>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="board-wrap">

  <!-- ===== 글 ===== -->
  <article class="post mb-3">
    <header class="post-head">
      <h1 class="post-title"><c:out value="${flag.title}" /></h1>

      <div class="post-meta">
        <span class="avatar"></span>
        <div>
          <span class="js-user" data-nickname="${flag.nickname}">
            <a href="${CTX}/othermemberprofile/checkprofile?nickname=${flag.nickname}">
              <c:out value="${flag.nickname}" />
            </a>
          </span>
          <span class="ms-2">
            <c:if test="${flag.created_at != null}">
              <fmt:formatDate value="${flag.created_at}" pattern="yyyy.MM.dd HH:mm"/>
            </c:if>
          </span>
          <c:if test="${not empty flag.city}"><span class="ms-2 text-muted">${flag.city} ${flag.district}</span></c:if>
        </div>

        <div class="ms-auto d-flex align-items-center gap-3">
          <security:authentication property="principal.username" var="loginUserId"/>
          <c:if test="${loginUserId eq flag.userId or isAdmin}">
            <a href="${CTX}/flag/update/${flag.id}" class="link">수정</a>
            <a href="${CTX}/flag/delete/${flag.id}" class="link"
               onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
          </c:if>
          <c:if test="${loginUserId ne flag.userId}">
            <a href="javascript:void(0)" id="reportBtn" class="link">신고</a>
          </c:if>
        </div>
      </div>
    </header>

    <div class="post-body">
      ${flag.content}
    </div>

    <!-- 첨부 -->
    <c:if test="${not empty fileList}">
      <section class="attach">
        <ul>
          <c:forEach var="file" items="${fileList}">
            <li>
              <c:set var="lower" value="${fn:toLowerCase(file.storedFileName)}"/>
              <c:choose>
                <c:when test="${fn:endsWith(lower, '.jpg') or fn:endsWith(lower, '.jpeg') or fn:endsWith(lower, '.png') or fn:endsWith(lower, '.gif')}">
                  <img src="${CTX}/flag/preview?fileName=${file.storedFileName}" alt="${file.originalFileName}">
                </c:when>
                <c:otherwise>
                  <a href="${CTX}/flag/preview?fileName=${file.storedFileName}" target="_blank">
                    <c:out value="${file.originalFileName}" />
                  </a>
                </c:otherwise>
              </c:choose>
            </li>
          </c:forEach>
        </ul>
      </section>
    </c:if>

    <!-- 하단 액션 -->
    <div class="post-actions">
      <div class="stats">
        <span><i class="bi bi-heart-fill text-danger"></i><span id="likeCountDisplay">${flag.like_count}</span></span>
        <span><i class="bi bi-chat-left-text"></i>${fn:length(flagCommentDTOList)}</span>
        <span class="text-muted">조회 <span id="viewCount">${flag.view_count}</span></span>
      </div>
      <button type="button" id="likeBtn" class="btn btn-like ${flag.liked ? 'liked' : ''}">
        <i class="bi ${flag.liked ? 'bi-heart-fill' : 'bi-heart'}"></i>
        <span id="likeCount">${flag.like_count}</span>
      </button>
    </div>
  </article>

  <!-- ===== 댓글 입력 ===== -->
  <form id="commentForm" class="cmt-form">
    <input type="hidden" name="post_id" id="post_id" value="${flag.id}"/>
    <div class="cmt-input">
      <textarea id="content" name="content" rows="1" placeholder="댓글을 작성해주세요"></textarea>
      <button type="submit" class="cmt-send">작성</button>
    </div>
  </form>

  <!-- ===== 댓글 목록 ===== -->
  <section class="comments">
    <div class="comments-head">댓글 <span class="text-muted">(${fn:length(flagCommentDTOList)})</span></div>
    <div id="commentList">
      <c:if test="${not empty flagCommentDTOList}">
        <c:forEach var="comment" items="${flagCommentDTOList}">
          <div class="cmt-item">
            <div class="cmt-top">
              <span class="avatar"></span>
              <div class="flex-grow-1">
                <span class="js-user" data-nickname="${comment.nickname}">
                  <a href="${CTX}/othermemberprofile/checkprofile?nickname=${comment.nickname}">
                    <c:out value="${comment.nickname}" />
                  </a>
                </span>
                <span class="ms-2"><fmt:formatDate value="${comment.created_at}" pattern="yyyy.MM.dd HH:mm"/></span>
              </div>
              <c:if test="${comment.userId eq loginUserId or isAdmin}">
                <div class="cmt-actions">
                  <button class="btn btn-sm btn-outline-danger"
                          onclick="deleteComment(${comment.id},${comment.post_id})">삭제</button>
                </div>
              </c:if>
            </div>
            <div class="cmt-body">
              ${comment.content}
            </div>
          </div>
        </c:forEach>
      </c:if>
      <c:if test="${empty flagCommentDTOList}">
        <div class="p-4 text-muted">첫 댓글을 남겨보세요.</div>
      </c:if>
    </div>
  </section>

</div><!-- /.board-wrap -->

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

  // 좋아요 토글
  $('#likeBtn').on('click', function(){
    const flagId = '${flag.id}';
    $.ajax({
      type: 'POST',
      url: CTX + '/flagLike/like/' + flagId,
      success: function(data){
        if(data && data.error){ alert(data.error); return; }
        $('#likeCount, #likeCountDisplay').text(data.likeCount);
        const $btn = $('#likeBtn');
        const $icon = $btn.find('.bi');
        if(data.liked){
          $btn.addClass('liked'); $icon.removeClass('bi-heart').addClass('bi-heart-fill');
        }else{
          $btn.removeClass('liked'); $icon.removeClass('bi-heart-fill').addClass('bi-heart');
        }
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
