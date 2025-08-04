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
            <h4 class="card-title">${flag != null ? flag.title : ''}</h4>
            <div class="mb-3 text-muted small">${flag != null ? flag.nickname : ''}</div>
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

            <div class="text-end">
                <%-- 수정/삭제 버튼은 임시로 주석 --%>
                <%-- <a href="${pageContext.request.contextPath}/flag/update/${flag.id}" class="btn btn-outline-secondary btn-sm">수정</a>
                <a href="${pageContext.request.contextPath}/flag/delete/${flag.id}" class="btn btn-outline-dark btn-sm" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a> --%>
            </div>
            <div class="text-end mt-3">
                <a href="${pageContext.request.contextPath}/flag" class="btn btn-secondary">📄 목록으로 가기</a>
            </div>

            <%-- 좋아요 기능도 임시 주석
            <form action="/flag/like/${flag.id}" method="post">
                <button type="submit" class="btn btn-outline-danger">❤️ 좋아요 (${flag.like_count})</button>
            </form>
            --%>

            <div class="text-muted">
                <%-- 날짜/조회수 출력도 null 체크 --%>
                작성일:
                <c:if test="${flag != null && flag.created_at != null}">
                    <fmt:formatDate value="${flag.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                </c:if>
                <br />
                조회수: ${flag != null ? flag.view_count : 0} | 좋아요: ${flag != null ? flag.like_count : 0}
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
        <c:if test="${not empty flagCommentDTOList}">
            <c:forEach var="comment" items="${flagCommentDTOList}">
                <div class="card mb-2">
                    <div class="card-body">
                        <p class="card-text">${comment.content}</p>
                        <footer class="blockquote-footer">
                            ${comment.nickname} |
                            <fmt:formatDate value="${comment.created_at}" pattern="yyyy-MM-dd HH:mm:ss" />
                            <button class="btn btn-sm btn-outline-danger float-end"
                                    onclick="deleteComment(${comment.id}, ${comment.post_id})">삭제</button>
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
            const nickname = $('#nickname').val();
            const content = $('#content').val();
            const post_id = $('#post_id').val();

            // 값이 없을 때 에러 방지
            if (!nickname || !content || !post_id) {
                alert("닉네임, 내용, 게시글 ID를 입력하세요");
                return;
            }

            $.ajax({
                type: 'POST',
                 url: '${pageContext.request.contextPath}/comment/write',
                            data: {nickname, content, post_id},
                dataType: 'json',
                success: function (data) {
                    renderCommentList(data);
                    $('#content').val('');
                },
                error: function () {
                    alert("댓글 등록 실패");
                }
            });
        });
    });

    function deleteComment(id, post_id) {
        if (!confirm("정말 삭제하시겠습니까?")) return;
        if (!id || !post_id) {
            alert("잘못된 댓글/게시글 정보입니다.");
            return;
        }

        $.ajax({
            type: 'DELETE',
            url: `/FlagComment/delete/${id}?post_id=${post_id}`,
            dataType: 'json',
            success: function (data) {
                renderCommentList(data);
            },
            error: function () {
                alert("댓글 삭제 실패");
            }
        });
    }

    function renderCommentList(data) {
        $('#commentList').empty();
        if (!data || data.length === 0) {
            $('#commentList').append('<div class="text-center text-muted">댓글이 없습니다.</div>');
            return;
        }
        data.forEach(function (comment) {
            const dateText = comment.created_at ? new Date(comment.created_at).toLocaleString() : '날짜 없음';
            const html = `
                <div class="card mb-2">
                    <div class="card-body">
                        <p class="card-text">${comment.content}</p>
                        <footer class="blockquote-footer">
                            ${comment.nickname} | ${dateText}
                            <button class="btn btn-sm btn-outline-danger float-end"
                                    onclick="deleteComment(${comment.id}, ${comment.post_id})">삭제</button>
                        </footer>
                    </div>
                </div>`;
            $('#commentList').append(html);
        });
    }
</script>
</body>
</html>
