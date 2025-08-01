<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커뮤니티</title>

    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/startbootstrap-sb-admin-2@4.1.4/css/sb-admin-2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        .sidebar {
            width: 220px;
            height: 100vh;
            background-color: #343a40;
            position: fixed;
            padding-top: 40px;
            color: #fff;
        }

        .sidebar a {
            color: #ddd;
            display: block;
            padding: 15px 20px;
            text-decoration: none;
        }

        .sidebar a:hover {
            background-color: #495057;
        }

        .main-content {
            margin-left: 220px;
            padding: 40px;
        }

        .card {
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .card img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }

        .pagination {
            justify-content: center;
        }
    </style>
</head>
<body>

<!-- 왼쪽 사이드바 -->
<div class="sidebar">
    <a href="#"> 마이페이지</a>
    <a href="#"> 범죄 예방 지도</a>
    <a href="#"> 커뮤니티</a>
    <a href="#"> 제보 및 신고</a>
    <a href="#"> 정보 공유</a>
</div>

<!-- 메인 콘텐츠 -->
<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4>커뮤니티</h4>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/flag/write" class="btn btn-primary">✏ 글쓰기</a>
            </a>
        </div>
    </div>

    <!-- 게시글 카드 반복 -->
    <c:forEach var="post" items="${postList}">
        <div class="card p-3">
            <blockquote class="blockquote mb-2">
                <p>"${post.content}"</p> <!-- ✅ 내용 출력 -->
            </blockquote>
            <div class="d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center">
                    <img src="${pageContext.request.contextPath}/resources/img/default-profile.png" alt="기본프로필" class="me-2">
                    <div>
                        <div>${post.title}</div> <!-- ✅ 제목 출력 -->
                        <small class="text-muted">조회수: ${post.viewCount}, 좋아요: ${post.likeCount}</small>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/flag/${post.id}" class="btn btn-dark btn-sm">상세보기</a>
            </div>
        </div>
    </c:forEach>

    <!-- 페이지네이션 -->
    <nav aria-label="Page navigation">
        <ul class="pagination mt-4">
            <li class="page-item disabled"><a class="page-link">← Previous</a></li>
            <li class="page-item active"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item disabled"><a class="page-link" href="#">...</a></li>
            <li class="page-item"><a class="page-link" href="#">68</a></li>
            <li class="page-item"><a class="page-link" href="#">Next →</a></li>
        </ul>
    </nav>
</div>

</body>
</html>
