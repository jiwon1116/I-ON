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
                ${flag.nickname}
            </div>
            <p class="card-text">${flag.content}</p>
                <c:if test="${not empty fileList}">
                    <h6 class="mt-4">첨부 파일</h6>
                    <ul>
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
            <div class="text-end">
                <a href="${pageContext.request.contextPath}/flag/update/${flag.id}" class="btn btn-outline-secondary btn-sm">수정</a>
                <a href="${pageContext.request.contextPath}/flag/delete/${flag.id}" class="btn btn-outline-dark btn-sm"
                   onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
            </div>
            <div class="text-end mt-3">
                <a href="${pageContext.request.contextPath}/flag" class="btn btn-secondary">📄 목록으로 가기</a>
            </div>

     <form action="/flag/like/${flag.id}" method="post">
         <button type="submit" class="btn btn-outline-danger">❤️ 좋아요 (${flag.like_count})</button>
     </form>



            <div class="text-muted">
                작성일: ${flag.created_at} <br />
                조회수: ${flag.view_count} | 좋아요: ${flag.like_count}
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
                    <button type="button" class="btn btn-primary" id="submitCommentBtn">댓글 등록</button>
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
                        ${comment.nickname} | ${comment.formattedCreatedAt}
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
        $('#submitCommentBtn').on('click', function () {
            const nickname = $('#nickname').val();
            const content = $('#content').val();
            const post_id = $('#post_id').val();

           $.ajax({
               type: 'POST',
               url: '/FlagComment/write',
               data: {
                   nickname: nickname,
                   content: content,
                   post_id: post_id
               },
               dataType: 'json',
               success: function (data) {
                   // 성공 처리
               },
               error: function (xhr, status, error) {
                   console.log("댓글 등록 실패:", error);
               }
           });

        });
    });

    function deleteComment(id, post_id) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.ajax({
            type: 'POST',
            url: window.location.origin + '/comment/delete',
            data: {id, post_id},
            success: function (data) {
                $('#commentList').empty();
                data.forEach(function (comment) {
                    const date = new Date(comment.created_at).toLocaleString();
                    const html = `
                        <div class="card mb-2">
                            <div class="card-body">
                                <p class="card-text">${comment.content}</p>
                                <footer class="blockquote-footer">
                                    ${comment.nickname} | ${date}
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
