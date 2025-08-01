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
    font-family: sans-serif;
}

.container {
    display: flex;
    height: 100vh;
}

.sidebar {
    width: 220px;
    background-color: #333;
    color: white;
    padding: 20px;
}

.sidebar ul {
    list-style: none;
    padding: 0;
}

.sidebar li {
    margin: 20px 0;
    cursor: pointer;
}

.content {
    flex: 1;
    padding: 30px;
    background-color: #f8f8f8;
}

.top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
}

.search-input {
    width: 200px;
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.filter-buttons button {
    margin-left: 10px;
    padding: 7px 12px;
    border: 1px solid #ccc;
    background-color: white;
    cursor: pointer;
    border-radius: 4px;
}

.filter-buttons .active {
    background-color: #222;
    color: white;
}

.card-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 25px;
}

.card {
    background-color: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 10px;
    text-align: center;
}

.card img {
    width: 100%;
    height: 180px;
    background-color: #eee;
    object-fit: cover;
    border-radius: 6px;
    margin-bottom: 10px;
}

.card p {
    margin: 0;
    font-weight: 500;
}

   </style>
</head>
<body>
<div class="container">
    <!-- 사이드바 -->
    <aside class="sidebar">
        <ul>
            <li><strong>마이페이지</strong></li>
            <li>범죄 예방 지도</li>
            <li>커뮤니티</li>
            <li>제보 및 신고</li>
            <li>정보 공유</li>
        </ul>
    </aside>

    <!-- 메인 콘텐츠 -->
    <main class="content">
        <div class="top-bar">
            <input type="text" placeholder="Search" class="search-input" />
            <div class="filter-buttons">
                <button class="active" onclick="writeFn()" >글 작성하기</button>
                <button>버튼1</button>
                <button>버튼2</button>
                <button>Rating</button>
            </div>
        </div>
        <!-- 게시글 이미지 반복 -->
        <div class="card-grid">
            <c:forEach var="content" items="${contentList}">
                <div class="card">
                   <div>이미지</div>
                    <p>${content.title}</p>
                    <a href="/info/detail/${content.id}">${content.content}</a>
                    <strong></strong>
                </div>
            </c:forEach>
        </div>
    </main>
</div>
  <!-- 아래 관리자, 회원 확인 후 처리 -->
</body>

<script>
    const writeFn = () => {
        location.href = "/info/save";
    }
</script>

</html>
