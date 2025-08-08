<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .like-btn .heart {
            font-size: 1.4em;
            vertical-align: middle;
            transition: color 0.15s;
        }
        .like-btn.liked .heart {
            color: #f44336;
        }
            color: #fff;
            text-shadow: 0 0 2px #d1d1d1;
        }
        .like-btn {
            border: 1.5px solid #f44336 !important;
        }
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
                ${flag != null ? flag.nickname : ''}

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
                <!-- 수정 버튼 추가 -->
                <security:authentication property="principal.username" var="loginUserId"/>
                <c:if test="${loginUserId eq flag.userId}">
                    <a href="${pageContext.request.contextPath}/flag/update/${flag.id}" ...>수정</a>
                    <a href="${pageContext.request.contextPath}/flag/delete/${flag.id}" ...>삭제</a>
                </c:if>

            </div>

            <!-- 좋아요 버튼 (하트 토글) -->
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
                <div class="mb-2">
                    <!-- nickname input 삭제!! -->
                </div>
                <div class="mb-2">
                    <textarea class="form-control" id="content" name="content" placeholder="댓글을 입력하세요"></textarea>
                </div>
                <div class="text-end">
                    <button type="submit" class="btn btn-primary" id="submitCommentBtn">댓글 등록</button>
                </div>
            </form>
        </div>
    </div>


    <!-- 댓글 출력 영역 -->
    <div id="commentList">
        <c:if test="${not empty flagCommentDTOList}">
            <c:forEach var="comment" items="${flagCommentDTOList}">
                <div class="card mb-2">
                    <div class="card-body">
                        <p class="card-text">${comment.content}</p>
                        <footer class="blockquote-footer">
                            ${comment.nickname} | ${dateText}
                            <fmt:formatDate value="${comment.created_at}" pattern="yyyy-MM-dd HH:mm:ss" />
                            <!-- comment.userId == 로그인한 유저의 userId일 때만 삭제 버튼 노출 -->
                            <c:if test="${comment.userId eq loginUserId}">
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
        // 댓글 등록
        $('#commentForm').submit(function (e) {
            e.preventDefault();
            const content = $('#content').val();
            const post_id = $('#post_id').val();

                 if (!post_id || !content) {
                                  alert("내용을 입력해주세요.");
                          return;
                  }

            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/FlagComment/write',
                data: {
                    content: $('#content').val(),
                    post_id: $('#post_id').val()
                },
                dataType: 'json',
                success: function(data) {
                    renderCommentList(data);
                    $('#content').val('');
                    location.reload();
                },
                error: function() {
                    alert("댓글 등록 실패");
                }
            });

        });


        // 좋아요 버튼
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
                    // 하트 토글
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

    // ↓↓↓ 아래 함수들은 document ready 블록 밖에서 선언!
    function deleteComment(id, post_id) {
    console.log("삭제 클릭:", id, post_id); // 이거 추가해서 값 확인


        if (!confirm("정말 삭제하시겠습니까?")) return;
        if (!id || !post_id) {
            alert("잘못된 댓글/게시글 정보입니다.");
            return;
        }

        $.ajax({
            type: 'get',
            url: '/FlagComment/delete?id=' + id + '&post_id=' + post_id,
            dataType: 'json',
            success: function (data) {
                renderCommentList(data);
                location.reload();

            },
            error: function () {
                alert("댓글 삭제 실패");
            }
        });
    }

    function renderCommentList(data) {

        if (!data || data.length === 0) {
            $('#commentList').append('<div class="text-center text-muted">댓글이 없습니다.</div>');
            return;
        }

           $('#commentList').empty();
                const flagId = $('#post_id').val();

        data.forEach(function (comment) {
            const dateText = comment.created_at ? new Date(comment.created_at).toLocaleString() : '날짜 없음';
            const html = `
                <div class="card mb-2">
                    <div class="card-body">
                        <p class="card-text">${comment.content}</p>
                        <footer class="blockquote-footer">
                            ${comment.nickname} | ${dateText}
                            <button class="btn btn-sm btn-outline-danger float-end"
                                    onclick="deleteComment(${comment.id}, ${flagId})">삭제</button>
                        </footer>
                    </div>
                </div>`;
            $('#commentList').append(html);
        });
    }
</script>
</body>
</html>
