<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body style="background-color: #f9f9f9;">
<div class="container mt-5">

    <!-- 게시글 상세 -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-warning text-white fw-bold">게시글 상세</div>
        <div class="card-body">
            <h4 class="card-title">${flag.title}</h4>
            <div class="mb-3 text-muted small">
                <img src="${pageContext.request.contextPath}/images/default-profile.png" style="width:24px; height:24px; border-radius:50%;" />
                ${flag.nickname} ·

            </div>
            <p class="card-text">${flag.content}</p>
            <div class="text-end">
                <a href="${pageContext.request.contextPath}/flag/update/${flag.id}" class="btn btn-outline-secondary btn-sm">수정</a>
                <a href="${pageContext.request.contextPath}/flag/delete/${flag.id}" class="btn btn-outline-dark btn-sm"
                   onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
            </div>
        </div>
    </div>

    <!-- 댓글 작성 -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-warning text-white fw-bold">💬 댓글 작성</div>
        <div class="card-body">
            <form id="commentForm">
                <input type="hidden" name="post_id" id="post_id" value="${flag.id}"/>
                <div class="mb-2">
                    <input type="text" class="form-control" id="nickname" name="nickname"
                           value="${sessionScope.loginNickname != null ? sessionScope.loginNickname : ''}"
                           placeholder="닉네임 입력" ${sessionScope.loginNickname != null ? "readonly" : ""} required/>
                </div>
                <div class="mb-2">
                    <textarea class="form-control" id="content" name="content" placeholder="댓글을 입력하세요" required></textarea>
                </div>
                <div class="text-end">
                    <button type="submit" class="btn btn-primary">댓글 등록</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 댓글 출력 영역 -->
    <div id="commentList">
        <c:forEach var="comment" items="${flagCommentDTOList}">
            <div class="card mb-2">
                <div class="card-body">
                    <p class="card-text">${comment.content}</p>
                    <footer class="blockquote-footer">
                        ${comment.nickname} |

                        <button class="btn btn-sm btn-outline-danger float-end"
                                onclick="deleteComment(${comment.id}, ${comment.post_id})">삭제</button>
                    </footer>
                </div>
            </div>
        </c:forEach>
    </div>

</div>

<script>
$(document).ready(function () {
    // 댓글 등록
    $('#commentForm').submit(function (e) {
        e.preventDefault();
        const nickname = $('#nickname').val();
        const content = $('#content').val();
        const post_id = $('#post_id').val();

        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/comment/write',
            data: {nickname, content, post_id},
            success: function (data) {
                $('#commentList').empty();
                data.forEach(function (comment) {
                    const html = `
                        <div class="card mb-2">
                            <div class="card-body">
                                <p class="card-text">${comment.content}</p>
                                <footer class="blockquote-footer">
                                    ${comment.nickname} | ${comment.created_at}
                                    <button class="btn btn-sm btn-outline-danger float-end"
                                            onclick="deleteComment(${comment.id}, ${comment.post_id})">삭제</button>
                                </footer>
                            </div>
                        </div>`;
                    $('#commentList').append(html);
                });
                $('#content').val('');
            },
            error: function (xhr, status, error) {
                console.log("댓글 등록 실패:", error);
            }
        });
    });
});

// 댓글 삭제
function deleteComment(id, post_id) {
    if (!confirm("정말 삭제하시겠습니까?")) return;

    $.ajax({
        type: 'POST',
        url: '${pageContext.request.contextPath}/comment/delete',
        data: {id, post_id},
        success: function (data) {
            $('#commentList').empty();
            data.forEach(function (comment) {
                const html = `
                    <div class="card mb-2">
                        <div class="card-body">
                            <p class="card-text">${comment.content}</p>
                            <footer class="blockquote-footer">
                                ${comment.nickname} | ${comment.created_at}
                                <button class="btn btn-sm btn-outline-danger float-end"
                                        onclick="deleteComment(${comment.id}, ${comment.post_id})">삭제</button>
                            </footer>
                        </div>
                    </div>`;
                $('#commentList').append(html);
            });
        }
    });
}
</script>
</body>
</html>
