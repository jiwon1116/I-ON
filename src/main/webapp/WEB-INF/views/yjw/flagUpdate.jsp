<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
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
            top: 0;
            left: 0;
            padding-top: 40px;
            color: #fff;
        }

        .sidebar h4 {
            text-align: center;
            margin-bottom: 30px;
        }

        .sidebar a {
            display: block;
            color: #fff;
            padding: 15px 30px;
            text-decoration: none;
            font-weight: bold;
        }

        .sidebar a:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .main-content {
            margin-left: 220px;
            padding: 40px;
        }

        .update-box {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            max-width: 700px;
            margin: 0 auto;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .update-box h3 {
            font-weight: bold;
            margin-bottom: 30px;
        }

        .form-label {
            font-weight: bold;
            margin-top: 20px;
        }

        .form-control {
            padding: 12px;
            font-size: 15px;
            border-radius: 6px;
        }

        .form-control[readonly] {
            background-color: #eee;
        }

        .btn-submit {
            background-color: #f6a623;
            color: white;
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            margin-top: 30px;
            font-size: 16px;
            font-weight: bold;
        }

        .btn-submit:hover {
            background-color: #d89114;
        }
    </style>
</head>
<body>

<!-- 사이드바 -->
<div class="sidebar">
    <h4>logo</h4>
    <a href="#">마이페이지</a>
    <a href="#">범죄 예방 지도</a>
    <a href="#">커뮤니티</a>
    <a href="#">제보 및 신고</a>
    <a href="#">정보 공유</a>
</div>

<!-- 본문 영역 -->
<div class="main-content">
    <div class="update-box">
        <h3>글 수정</h3>
        <form action="${pageContext.request.contextPath}/flag/update" method="post">
            <label for="id" class="form-label">글 번호</label>
            <input type="text" id="id" name="id" class="form-control" value="${flag.id}" readonly />

            <label for="title" class="form-label">제목</label>
            <input type="text" id="title" name="title" class="form-control" value="${flag.title}" required />

            <label for="content" class="form-label">내용</label>
            <textarea id="content" name="content" rows="6" class="form-control" required>${flag.content}</textarea>

            <button type="submit" class="btn btn-submit" onclick="return confirm('수정하시겠습니까?')">수정하기</button>
        </form>
    </div>
</div>

</body>
</html>
