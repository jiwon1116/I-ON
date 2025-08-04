
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        .sidebar {
            width: 220px;
            height: 100vh;
            background-color: #f6a623;
            position: fixed;
            padding-top: 40px;
            color: #fff;
        }
        .sidebar a {
            color: #fff;
            display: block;
            padding: 15px 30px;
            text-decoration: none;
            font-weight: bold;
        }
        .sidebar a:hover {
            background-color: rgba(255,255,255,0.2);
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

<!-- 사이드바 -->
<div class="sidebar">
    <div class="text-center mb-4">
        <h4>logo</h4>
    </div>
    <a href="#">📌 마이페이지</a>
    <a href="#">🗺️ 범죄 예방 지도</a>
    <a href="#">💬 커뮤니티</a>
    <a href="#">🚨 제보 및 신고</a>
    <a href="#">📚 정보 공유</a>
</div>

<!-- 메인 콘텐츠 -->
<div class="main-content">

    <!-- 상단 검색 & 글쓰기 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <form class="d-flex search-bar" role="search">
            <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
            <button class="btn btn-outline-dark" type="submit">🔍</button>
        </form>
        <a href="${pageContext.request.contextPath}/info/save" class="btn btn-dark">✏ 글쓰기</a>
    </div>

    <!-- 게시글 카드 반복 -->
    <c:forEach var="content" items="${postList}">
        <a href="${pageContext.request.contextPath}/info/detail?id=${content.id}" class="card-link">
            <div class="card">
                <p class="quote">“${content.content}”</p>paging.jsp
                <div class="d-flex justify-content-between align-items-center mt-2">
                    <div class="d-flex align-items-center">
                        <img src="${pageContext.request.contextPath}/resources/img/default-profile.png" alt="기본프로필">
                        <div class="ms-2">
                            <div class="fw-semibold">${content.title}</div>
                        </div>
                    </div>
                    <span class="text-muted">▶</span>
                </div>
            </div>
        </a>
    </c:forEach>

    <!-- 페이징 -->
    <nav aria-label="Page navigation">
        <ul class="pagination mt-4">
            <c:choose>
             <%-- 1페이지인 경우 이전 비활성화 --%>
                <c:when test="${paging.page <= 1}">
                    <li class="page-item disabled"><a class="page-link">← Previous</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/info/paging?page=${paging.page - 1}">← Previous</a></li>
                </c:otherwise>
            </c:choose>

            <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                <c:choose>
                    <c:when test="${i eq paging.page}">
                        <li class="page-item active">
                      <a class="page-link" href="#">

                        ${i}</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                        <a class="page-link" href="/info/paging?page=${i}">${i}</a></li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
             <%-- 마지막 페이지일 경우 다음 비활성화 --%>
                <c:when test="${paging.page >= paging.maxPage}">
                    <li class="page-item disabled"><a class="page-link">Next →</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/info/paging?page=${paging.page + 1}">Next →</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</div>

</body>
</html>
