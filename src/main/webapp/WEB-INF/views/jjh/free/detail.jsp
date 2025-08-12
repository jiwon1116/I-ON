<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>자유 게시판</title>
  <c:set var="CTX" value="${pageContext.request.contextPath}" />

  <!-- 페이지 전용 CSS (info-* 스타일이 들어있는 파일) -->
  <link rel="stylesheet" href="${CTX}/resources/css/common.css"/>
  <link rel="stylesheet" href="${CTX}/resources/css/detail.css"/>

  <!-- 라이브러리 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

  <!-- 배지 스크립트(헤더에서 이미 넣었다면 제거 가능) -->
  <script src="${CTX}/resources/js/badge.js"></script>
</head>
<body>

<!-- 헤더 include (contentType 충돌 방지용 jsp:include 권장) -->
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="info-page-wrap">
  <div class="info-card">

    <!-- 제목 + 우측 액션 -->
    <div class="info-head">
      <h1 class="info-title"><c:out value="${free.title}" /></h1>

      <div class="info-actions">
        <security:authentication property="principal.username" var="loginUserId"/>
        <c:if test="${loginUserId eq free.userId || isAdmin}">
          <button type="button" onclick="updateFn()">수정</button>
          <button type="button" onclick="deleteFn()">삭제</button>
        </c:if>
        <c:if test="${loginUserId ne free.userId}">
          <button type="button" id="reportBtn">신고</button>
        </c:if>
      </div>
    </div>

    <!-- 메타 -->
    <div class="info-meta">
      <c:if test="${not empty free.nickname}">
        <div class="info-author">
          <span class="js-user" data-nickname="${free.nickname}">
            <a href="${CTX}/othermemberprofile/checkprofile?nickname=${free.nickname}">
              <c:out value="${free.nickname}" />
            </a>
          </span>
        </div>
      </c:if>

      <div>
        <i class="bi bi-clock me-1"></i>
        <c:if test="${free.created_at != null}">
          <fmt:formatDate value="${free.created_at}" pattern="yyyy.MM.dd HH:mm"/>
        </c:if>
      </div>

      <div>
        <i class="bi bi-eye me-1"></i>
        <span id="viewCount">${free.view_count}</span>
      </div>
    </div>


    <!-- 첨부 이미지 그리드 -->
    <c:if test="${not empty fileList}">
      <div class="info-image-grid">
        <c:forEach items="${fileList}" var="file">
          <c:if test="${file.originalFileName.endsWith('.jpg') || file.originalFileName.endsWith('.png') || file.originalFileName.endsWith('.jpeg') || file.originalFileName.endsWith('.gif')}">
            <img src="${CTX}/free/preview?fileName=${file.storedFileName}" alt="${file.originalFileName}"/>
          </c:if>
        </c:forEach>
      </div>

      <!-- 이미지 외 파일 링크 -->
      <ul style="list-style:none; padding:0; margin-top:8px;">
        <c:forEach items="${fileList}" var="file">
          <c:if test="${!(file.originalFileName.endsWith('.jpg') || file.originalFileName.endsWith('.png') || file.originalFileName.endsWith('.jpeg') || file.originalFileName.endsWith('.gif'))}">
            <li>
              <a href="${CTX}/free/preview?fileName=${file.storedFileName}" target="_blank">
                <c:out value="${file.originalFileName}" />
              </a>
            </li>
          </c:if>
        </c:forEach>
      </ul>
    </c:if>

    <!-- 본문 -->
    <div class="info-content">
      <textarea readonly>${free.content}</textarea>
    </div>

    <!-- 좋아요/카운트 -->
    <div class="info-stats">
      <button type="button" class="info-like-btn ${free != null && free.liked ? 'liked' : ''}" id="likeBtn">
        <span class="heart">${free != null && free.liked ? '❤️' : '🤍'}</span>
        <span id="likeCount">${free != null ? free.like_count : 0}</span>
      </button>
      <span>좋아요: <span id="likeCountDisplay">${free != null ? free.like_count : 0}</span></span>
      <span>댓글: ${commentList != null ? commentList.size() : 0}</span>
    </div>

    <!-- 댓글 입력 -->
    <div class="info-comment-editor">
      <input type="hidden" id="nickname" value="${member.nickname}" />
      <textarea id="content" placeholder="댓글을 작성해주세요"></textarea>
      <button type="button" onclick="commentWrite()">작성</button>
    </div>

    <!-- 댓글 목록 -->
    <section class="info-comment-wrap">
      <div class="info-comment-list" id="commentList">
        <c:forEach items="${commentList}" var="comment">
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
                    <fmt:formatDate value="${comment.created_at}" pattern="yyyy.MM.dd"/>
                  </span>
                  <security:authentication property="principal.username" var="loginUserId"/>
                  <c:if test="${loginUserId eq comment.userId || isAdmin}">
                    <button class="info-btn-del" onclick="commentDelete('${comment.id}')">삭제</button>
                  </c:if>
                </div>
              </div>
              <div class="info-comment-content">${comment.content}</div>
            </div>
          </div>
        </c:forEach>
        <c:if test="${empty commentList}">
          <div class="p-4 text-muted">첫 댓글을 남겨보세요.</div>
        </c:if>
      </div>
    </section>

    <!-- 하단 버튼 -->
    <div class="info-bottom-actions">
      <button type="button" class="info-btn-secondary" onclick="location.href='${CTX}/free'">목록</button>
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
          <input type="hidden" name="postId" value="${free.id}" />
          <div class="mb-3">
            <label for="reportType" class="form-label">신고 유형</label>
            <select class="form-select" name="type" id="reportType" required>
              <option value="" hidden selected>-- 신고 유형 선택 --</option>
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
  // 수정/삭제
  const updateFn = () => { location.href = "${CTX}/free/update/${free.id}"; }
  const deleteFn = () => {
    if (confirm("정말 삭제하시겠습니까?")) {
      location.href = "${CTX}/free/delete?id=${free.id}";
    }
  }
  const commentDelete = (commentId) => {
    if (confirm("댓글을 삭제하시겠습니까?")) {
      location.href = "/comment/delete?id=" + commentId;
    }
  }

  // 댓글 등록
  const commentWrite = () => {
    const nickname = document.getElementById("nickname").value;
    const content  = document.getElementById("content").value.trim();
    const postId   = "${free.id}";
    if (!postId || !content) { alert("내용을 입력해주세요."); return; }

    $.ajax({
      type: "post",
      url: "/comment/save",
      data: { content, post_id: postId, nickname },
      dataType: "json",
      success: function(){ location.reload(); },
      error:   function(){ alert("댓글 등록 실패"); }
    });
  }

  // 좋아요
  $('#likeBtn').on('click', function(){
    const freeId = '${free.id}';
    $.ajax({
      type: 'POST',
      url: '${CTX}/freeLike/like/' + freeId,
      success: function(data){
        if(data && data.error){ alert(data.error); return; }
        $('#likeCount, #likeCountDisplay').text(data.likeCount);
        const $btn = $('#likeBtn');
        const $heart = $btn.find('.heart');
        if(data.liked){ $btn.addClass('liked'); $heart.text('❤️'); }
        else { $btn.removeClass('liked'); $heart.text('🤍'); }
      },
      error: function(xhr){
        try{ const d = JSON.parse(xhr.responseText); alert(d.error || "좋아요 처리 실패!"); }
        catch(e){ alert("좋아요 처리 실패!"); }
      }
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
    if(!reason.trim()) return alert("신고 사유를 입력해주세요.");

    const payload = { targetBoard:'FREE', targetContentId: postId, type, description: reason };
    $.ajax({
      type:'POST',
      url: '${CTX}/report',
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
</script>
</body>
</html>
