<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아동 범죄 예방 콘텐츠</title>
    <style>
        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #fdfdfd;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 24px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .search-input {
            width: 300px;
            padding: 10px 16px;
            border: 1px solid #ccc;
            border-radius: 24px;
            font-size: 14px;
            outline: none;
        }

        .search-input:focus {
            border-color: #ffb800;
            box-shadow: 0 0 6px #ffb800aa;
        }

        .filter-buttons button {
            background-color: #ffb800;
            color: white;
            font-weight: bold;
            border: none;
            padding: 10px 20px;
            border-radius: 30px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .filter-buttons button:hover {
            background-color: #ffaa00;
        }

        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 24px;
        }

        .card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.06);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.12);
        }

        .card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            display: block;
        }

        .card .card-body {
            padding: 16px;
        }

        .card .title {
            font-weight: bold;
            font-size: 16px;
            color: #222;
            margin-bottom: 6px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .card .author {
            font-size: 13px;
            color: #777;
        }

        /* Pagination */
        nav[aria-label="Page navigation"] {
            margin-top: 50px;
            text-align: center;
        }

        ul.pagination {
            list-style: none;
            padding: 0;
            display: inline-flex;
            gap: 8px;
        }

        .page-item a.page-link {
            display: block;
            padding: 10px 14px;
            text-decoration: none;
            border: 1px solid #ddd;
            border-radius: 8px;
            color: #333;
            font-weight: bold;
            transition: all 0.2s;
        }

        .page-item.active a.page-link,
        .page-item a.page-link:hover {
            background-color: #ffb800;
            color: white;
            border-color: #ffb800;
        }

        .page-item.disabled a.page-link {
            color: #bbb;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="top-bar">
        <input type="text" class="search-input" placeholder="검색어를 입력하세요..."/>
        <div class="filter-buttons">
            <button onclick="writeFn()">글 작성하기</button>
        </div>
    </div>

    <div class="card-grid">
        <c:forEach var="content" items="${postList}">
            <div class="card" onclick="location.href='/info/detail?id=${content.id}'">
                <img src="${content.imageUrl != null ? content.imageUrl : '/resources/images/default.jpg'}" alt="카드 이미지">
                <div class="card-body">
                    <div class="title">${content.title}</div>
                    <div class="author">${content.writer != null ? content.writer : 'admin'}</div>
                </div>
            </div>
        </c:forEach>
    </div>

    <nav aria-label="Page navigation">
        <ul class="pagination">
            <c:choose>
                <c:when test="${paging.page <= 1}">
                    <li class="page-item disabled"><a class="page-link">← Previous</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/info/paging?page=${paging.page - 1}">← Previous</a>
                    </li>
                </c:otherwise>
            </c:choose>

            <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
                <c:choose>
                    <c:when test="${i eq paging.page}">
                        <li class="page-item active"><a class="page-link">${i}</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/info/paging?page=${i}">${i}</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:choose>
                <c:when test="${paging.page >= paging.maxPage}">
                    <li class="page-item disabled"><a class="page-link">Next →</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/info/paging?page=${paging.page + 1}">Next →</a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</div>

<script>
    function writeFn() {
        location.href = "/info/save";
    }
</script>
</body>
</html>
