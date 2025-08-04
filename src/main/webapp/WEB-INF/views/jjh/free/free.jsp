<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자유 게시판</title>
    <style>
        body {
            margin: 0;
            font-family: 'Arial', sans-serif;
            background: #f5f5f5;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 200px;
            height: 100%;
            background: #f6a500;
            color: white;
            padding: 40px 20px;
            box-sizing: border-box;
        }

        .sidebar h2 {
            font-size: 24px;
            margin-bottom: 40px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar li {
            margin-bottom: 20px;
            font-weight: bold;
            cursor: pointer;
        }

        .main {
            margin-left: 240px;
            padding: 40px;
        }

        .search-bar-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .search-bar input {
            width: 70%;
            max-width: 600px;
            padding: 10px 15px;
            font-size: 16px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }

        .write-btn {
            padding: 10px 18px;
            background-color: #ff6f61;
            color: white;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            transition: background 0.2s;
        }

        .card:hover {
            background: #f0f0f0;
        }

        .card-left {
            display: flex;
            align-items: center;
        }

        .card-left img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 20px;
        }

        .card-content {
            max-width: 600px;
        }

        .quote {
            font-size: 18px;
            font-style: italic;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .content {

            font-size: 16px;
        }

        .desc {
            color: #777;
            font-size: 14px;
        }

        .register-btn {
            background: black;
            color: white;
            padding: 10px 16px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
        }


    </style>
</head>
<body>

<div class="sidebar">
    <h2>logo</h2>
    <ul>
        <li>마이페이지</li>
        <li>범죄 예방 지도</li>
        <li>커뮤니티</li>
        <li>제보 및 신고</li>
        <li>정보 공유</li>
    </ul>
</div>

<div class="main">
    <div class="search-bar-container">
        <form class="search-bar" method="get" action="/free/search">
            <input type="text" name="searchContent" placeholder="제목, 내용으로 검색" />
            <button type="submit">검색</button>
        </form>
        <a class="write-btn" href="free/write">글 작성</a>
    </div>

    <c:forEach items="${freeboardList}" var="free">
        <div class="card" onclick="location.href='/free/detail?id=${free.id}'">
            <div class="card-left">
                <img src="/images/default-profile.png" alt="profile" />
                <div class="card-content">
                    <div class="quote">${free.title}</div>
                    <div class="content">${free.content}</div>
                    <div class="desc">${free.nickname} ·
                        <fmt:formatDate value="${free.created_at}" pattern="yyyy-MM-dd" /> ·
                        좋아요 ${free.like_count} · 조회수 ${free.view_count}
                    </div>
                </div>
            </div>
            <button class="register-btn">Register</button>
        </div>
    </c:forEach>

	<div>
		<c:choose>
			<%-- 1페이지인 경우에 이전 활성화 X --%>
			<c:when test="${paging.page <= 1 }">
				<span>[이전]</span>
			</c:when>
			<c:otherwise>
				<%-- 1페이지가 아닌 경우 : 이전 페이지 클릭 시 현재 페이지보다 1만큼 작은 페이지 요청 --%>
				<a href="/free?page=${paging.page - 1 }">[이전]</a>
			</c:otherwise>
		</c:choose>

		<c:forEach begin="${paging.startPage }" end="${paging.endPage }"
			step="1" var="i">
			<c:choose>
				<%-- 요청한 페이지에 있는 경우 현재 페이지 번호는 텍스트만 보이도록 설정 --%>
				<c:when test="${i == paging.page}">
					<span>${i }</span>
				</c:when>
				<c:otherwise>
					<a href="/free?page=${i }">${i }</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>

		<c:choose>
			<%-- 요청한 페이지에 있는 경우 현재 페이지 번호는 텍스트만 보이도록 설정 --%>
			<c:when test="${paging.page >= paging.maxPage}">
				<span>[다음]</span>
			</c:when>
			<c:otherwise>
				<a href="/free?page=${paging.page + 1 }">[다음]</a>
			</c:otherwise>
		</c:choose>
	</div>
</div>

</body>
</html>
