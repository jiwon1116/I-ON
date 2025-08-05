<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커뮤니티</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
        }


        .main-content {
            margin-left: 220px;
            padding: 40px;
        }

        .card-link {
            text-decoration: none;
            color: inherit;
        }

        .card {
            border-radius: 10px;
            padding: 20px;
            background-color: #fff;
            margin-bottom: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            transition: box-shadow 0.2s ease, background-color 0.2s ease;
        }

        .card:hover {
            background-color: #f1f1f1;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            cursor: pointer;
        }

        .card img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
        }

        .search-bar {
            max-width: 300px;
        }

        .quote {
            font-style: italic;
        }

       /* 모던 페이지네이션 스타일 */
                .pagination {
                        display: flex;
                        justify-content: center;
                        list-style: none;
                        padding: 0;
                        gap: 4px;
                    }

                    .pagination .page-item {
                        display: inline-block;
                    }

                    .pagination .page-link {
                        display: block;
                        padding: 6px 12px;
                        border-radius: 6px;
                        background-color: transparent;
                        color: #333;
                        text-decoration: none;
                        border: none;
                        font-weight: 500;
                        transition: background-color 0.2s ease;
                    }

                    .pagination .page-link:hover {
                        background-color: #e0e0e0;
                    }

                    .pagination .page-item.active .page-link {
                        background-color: #212121;
                        color: #fff;
                        pointer-events: none;
                    }

                    .pagination .page-item.disabled .page-link {
                        color: #aaa;
                        pointer-events: none;
                    }

                    .pagination .ellipsis {
                        padding: 6px 12px;
                        color: #999;
                    }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- 메인 콘텐츠 -->
<div class="main-content">


    <!-- 상단 검색 & 글쓰기 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <form class="d-flex search-bar" role="search" method="get" action="${pageContext.request.contextPath}/flag/search">
            <input class="form-control me-2" type="search" name="keyword" placeholder="제목 또는 내용을 검색하세요" value="${param.keyword}">
            <button class="btn btn-outline-dark" type="submit">🔍</button>
        </form>
        <a href="${pageContext.request.contextPath}/flag/write" class="btn btn-dark">✏ 글쓰기</a>
    </div>

    <!-- 게시글 카드 반복 -->
    <c:if test="${empty postList}">
        <div class="text-center mt-5 text-muted">검색 결과가 없습니다.</div>
    </c:if>

<c:forEach var="post" items="${postList}">
    <a href="${pageContext.request.contextPath}/flag/${post.id}" class="card-link">
        <div class="card">
            <p class="quote">“${post.title}”</p>${post.content}
            <div class="d-flex justify-content-between align-items-center mt-2">
                <div class="d-flex align-items-center">
                    <img src="https://www.w3schools.com/howto/img_avatar.png" alt="기본프로필">
                    <div class="ms-2">
                        <div class="fw-semibold">${post.nickname}</div>
                        <div class="text-muted" style="font-size: 0.9rem;">
                            조회수: ${post.view_count}, 좋아요: ${post.like_count}
                        </div>
                    </div>
                </div>
                <span class="text-muted">▶</span>
            </div>
        </div>
    </a>
</c:forEach>


    <!-- 동적 페이지네이션 -->
    <nav aria-label="Page navigation">
        <ul class="pagination mt-4 justify-content-center">

            <!-- 이전 버튼 -->
            <c:choose>
                <c:when test="${paging.page <= 1}">
                    <li class="page-item disabled"><a class="page-link">← Previous</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/flag/paging?page=${paging.page - 1}">← Previous</a>
                    </li>
                </c:otherwise>
            </c:choose>

            <!-- 페이지 숫자 반복 -->
            <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
                <c:choose>
                    <c:when test="${i eq paging.page}">
                        <li class="page-item active"><a class="page-link" href="#">${i}</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/flag/paging?page=${i}">${i}</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <!-- 다음 버튼 -->
            <c:choose>
                <c:when test="${paging.page >= paging.maxPage}">
                    <li class="page-item disabled"><a class="page-link">Next →</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/flag/paging?page=${paging.page + 1}">Next →</a>
                    </li>
                </c:otherwise>
            </c:choose>

        </ul>
    </nav>
</div>

</body>
</html>
