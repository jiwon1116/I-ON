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
            background-color: #f5f5f5;
        }

        .container {
            display: flex;
            height: 100vh;
        }

        /* 사이드바 */
        .sidebar {
            width: 240px;
            background-color: #ffcc47; /* 이미지와 유사한 노랑 */
            padding: 30px 20px;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar li {
            margin: 20px 0;
            font-size: 18px;
            font-weight: bold;
            color: #333;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .sidebar li:hover {
            color: #000;
            background-color: #ffeaa7;
            padding: 8px 12px;
            border-radius: 8px;
        }

        /* 메인 콘텐츠 */
        .content {
            flex: 1;
            padding: 40px 60px;
            overflow-y: auto;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .search-input {
            width: 280px;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 10px;
        }

        .filter-buttons button {
            padding: 12px 20px;
            border: none;
            background-color: #2d3436;
            color: white;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
        }

        /* 카드 스타일 */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 35px;
        }

        .card {
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            padding: 20px;
            transition: transform 0.2s ease;
        }

        .card:hover {
            transform: translateY(-6px);
        }

        .card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .card p {
            font-size: 17px;
            font-weight: 600;
            margin: 0 0 10px 0;
        }

        .card a {
            font-size: 14px;
            color: #666;
            text-decoration: none;
            display: block;
        }

        .card a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 사이드바 -->
    <aside class="sidebar">
        <ul>
            <li>📌 마이페이지</li>
            <li>🗺️ 범죄 예방 지도</li>
            <li>💬 커뮤니티</li>
            <li>🚨 제보 및 신고</li>
            <li>📚 정보 공유</li>
        </ul>
    </aside>

    <main class="content">
        <div class="top-bar">
            <input type="text" class="search-input" placeholder="검색어를 입력하세요..."/>
            <div class="filter-buttons">
                <button onclick="writeFn()">글 작성하기</button>
            </div>
        </div>

        <div class="card-grid">
            <c:forEach var="content" items="${contentList}">
                <div class="card">
                    <이미지>
                    <p>${content.title}</p>
                    <a href="/info/detail/${content.id}">${content.content}</a>
                </div>
            </c:forEach>
        </div>
    </main>
</div>

<script>
    function writeFn() {
        location.href = "/info/save";
    }
</script>
</body>
</html>
