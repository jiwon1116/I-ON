<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글쓰기 - 커뮤니티</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 50px 20px;
            font-family: 'Segoe UI', sans-serif;
        }
        .write-card {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            padding: 40px;
        }
    </style>
</head>
<body>

<div class="write-card">
    <h4 class="mb-4 fw-bold text-primary">제보 및 신고 글 작성</h4>

    <form action="${pageContext.request.contextPath}/flag/save" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea class="form-control" id="content" name="content" rows="6" required></textarea>
        </div>

        <!-- 파일 업로드 -->
        <div class="mb-3">
            <label for="boardFile" class="form-label">파일 첨부 (선택)</label>
            <input type="file" class="form-control" id="boardFile" name="boardFile">
        </div>

        <!-- 닉네임 (임시) -->
        <input type="hidden" name="nickname" value="익명">

        <div class="d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}/flag" class="btn btn-outline-secondary">← 목록</a>
            <button type="submit" class="btn btn-primary">접수하기</button>
        </div>
    </form>
</div>

</body>
</html>
