<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기</title>
    <meta name="ctx" content="${pageContext.request.contextPath}"/>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 5 모달 동작 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 전역 배지 스크립트 (※ header.jsp에서 이미 포함되어 있으면 이 줄은 제거하세요) -->
    <script src="${pageContext.request.contextPath}/resources/js/badge.js"></script>

    <style>
        .like-btn .heart { font-size: 1.4em; vertical-align: middle; transition: color 0.15s; }
        .like-btn.liked .heart { color: #f44336; }
        .like-btn { border: 1.5px solid #f44336 !important; }
    </style>
</head>
<body>
<div class="container mt-5">
<%@ include file="/WEB-INF/views/header.jsp" %>

    <!-- 게시글 상세 -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-warning text-white fw-bold">게시글 상세</div>
        <div class="card-body">
            <h4 class="card-title">${flag != null ? flag.title : ''}</h4>

            <div class="mb-3 text-muted small">
                <c:if test="${flag != null}">
                    <!-- 닉네임 + 배지 -->
                    <span class="js-user" data-nickname="${flag.nickname}">${flag.nickname}</span>
                </c:if>

                <c:if test="${not empty flag.city}">
                    <span class="ms-2 badge bg-light text-dark border">
                        ${flag.city} ${flag.district}
                    </span>
                </c:if>
            </div>

            <p class="card-text">${flag != null ? flag.content : ''}</p>

            <%-- 파일 리스트 --%>
            <c:if test="${not empty fileList}">
                <h6 class="mt-4">첨부 파일</h6>
                <ul style="list-style: none; padding-left: 0;">
                    <c:forEach var="file" items="${fileList}">
                        <li>
                            <c:choose>
                                <c:when test="${file.storedFileName.endsWith('.jpg') || file.storedFileName.endsWith('.png') || file.storedFileName.endsWith('.jpeg') || file.storedFileName.endsWith('.gif')}">
                                    <img src="${pageContext.request.contextPath}/flag/preview?fileName=${file.storedFileName}" alt="${file.originalFileName}" style="max-width: 300px; margin: 10px 0;">
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/flag/preview?fileName=${file.storedFileName}" target="_blank">
                                        ${file.originalFileName}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                </ul>
            </c:if>

            <div class="text-end mb-2">
                <!-- 수정/삭제 버튼 -->
                <security:authentication property="principal.username" var="loginUserId"/>
                <c:if test="${loginUserId eq flag.userId or isAdmin}">
                    <a href="${pageContext.request.contextPath}/flag/update/${flag.id}">수정</a>
                    <a href="${pageContext.request.contextPath}/flag/delete/${flag.id}"
                       onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                </c:if>

                <!-- 신고 버튼(로그인 && 본인 글 아님) -->
                <c:if test="${loginUserId ne flag.userId}">
                    <button type="button" class="btn btn-outline-danger btn-sm ms-2" id="reportBtn">🚩 신고</button>
                </c:if>
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
                        <label for="reportReason" class="form-label">신고 사유</label>
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

            <!-- 좋아요 버튼 -->
            <div class="mb-2">
                <button type="button" class="btn like-btn ${flag.liked ? 'liked' : ''}" id="likeBtn">
                    <span class="heart">${flag.liked ? '❤️' : '🤍'}</span>
                    <span id="likeCount">${flag.like_count}</span>
                </button>
            </div>

            <div class="text-muted mt-2">
                작성일:
                <c:if test="${flag != null && flag.created_at != null}">
                    <fmt:formatDate value="${flag.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                </c:if>
                <br />
                조회수: <span id="viewCount">${flag != null ? flag.view_count : 0}</span>
                | 좋아요: <span id="likeCountDisplay">${flag != null ? flag.like_count : 0}</span>
            </div>

            <div class="text-end mt-3">
                <a href="${pageContext.request.contextPath}/flag" class="btn btn-secondary">📄 목록으로 가기</a>
            </div>
        </div>
    </div>

    <!-- 댓글 작성 -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-warning text-white fw-bold">💬 댓글 작성</div>
        <div class="card-body">
            <form id="commentForm">
                <input type="hidden" name="post_id" id="post_id" value="${flag != null ? flag.id : ''}"/>
                <div class="mb-2"></div>
                <div class="mb-2">
                    <textarea class="form-control" id="content" name="content" placeholder="댓글을 입력하세요"></textarea>
                </div>
                <div class="text-end">
                    <button type="submit" class="btn btn-primary" id="submitCommentBtn">댓글 등록</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 댓글 출력 영역 (서버 렌더링) -->
    <div id="commentList">
        <c:if test="${not empty flagCommentDTOList}">
            <c:forEach var="comment" items="${flagCommentDTOList}">
                <div class="card mb-2">
                    <div class="card-body">
                        <p class="card-text">${comment.content}</p>
                        <footer class="blockquote-footer">
                            <span class="js-user" data-nickname="${comment.nickname}">${comment.nickname}</span>
                            | <fmt:formatDate value="${comment.created_at}" pattern="yyyy-MM-dd HH:mm:ss" />
                            <c:if test="${comment.userId eq loginUserId or isAdmin}">
                                <button class="btn btn-sm btn-outline-danger float-end"
                                        onclick="deleteComment(${comment.id},${comment.post_id})">삭제</button>
                            </c:if>
                        </footer>
                    </div>
                </div>
            </c:forEach>
        </c:if>
    </div>
</div>

<script>
    $(document).ready(function () {
        // 댓글 등록 → 성공 시 전체 새로고침
        $('#commentForm').submit(function (e) {
            e.preventDefault();
            const content = $('#content').val();
            const post_id = $('#post_id').val();

            if (!post_id || !content) return alert("내용을 입력해주세요.");

            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/FlagComment/write',
                data: { content: content, post_id: post_id },
                dataType: 'json',
                success: function() {
                    window.location.reload();
                },
                error: function() {
                    alert("댓글 등록 실패");
                }
            });
        });

        // 신고 버튼
        $('#reportBtn').click(function(){
            var modal = new bootstrap.Modal(document.getElementById('reportModal'));
            modal.show();
        });

        // 신고 폼 제출
        $('#reportForm').submit(function(e){
            e.preventDefault();

            const postId = $('input[name="postId"]').val();
            const reason = $('#reportReason').val();
            if(!reason.trim()) return alert("신고 사유를 입력해주세요.");

            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/flag/report',
                contentType: 'application/json',
                data: JSON.stringify({ targetId: postId, targetType: "POST", type: "ABUSE", content: reason }),
                success: function(){
                    alert('신고가 접수되었습니다.');
                    const modal = bootstrap.Modal.getInstance(document.getElementById('reportModal'));
                    modal && modal.hide();
                },
                error: function(){
                    alert("신고 접수에 실패했습니다.");
                }
            });
        });

        // 좋아요 버튼 (비동기 토글 유지)
        $('#likeBtn').click(function(){
            const flagId = '${flag.id}';
            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/flagLike/like/' + flagId,
                success: function(data){
                    if(data.error){
                        alert(data.error);
                        return;
                    }
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
                error: function(){
                    alert('좋아요 처리 실패!');
                }
            });
        });
    });

    // 댓글 삭제 → 성공 시 전체 새로고침
    function deleteComment(id, post_id) {
        if (!confirm("정말 삭제하시겠습니까?")) return;
        if (!id || !post_id) return alert("잘못된 댓글/게시글 정보입니다.");

        $.ajax({
            type: 'get',
            url: '${pageContext.request.contextPath}/FlagComment/delete?id=' + id + '&post_id=' + post_id,
            dataType: 'json',
            success: function () {
                window.location.reload();
            },
            error: function () {
                alert("댓글 삭제 실패");
            }
        });
    }
</script>
</body>
</html>
