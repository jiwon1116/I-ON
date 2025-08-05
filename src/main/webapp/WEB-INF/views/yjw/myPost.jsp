<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내가 작성한 글 모아보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .card-title { font-weight: 600; }
        .card { transition: box-shadow 0.2s; }
        .card:hover { box-shadow: 0 6px 18px rgba(0,0,0,0.11); }
        .badge-board { font-size:0.95em; margin-right:7px;}
    </style>
</head>
<body class="bg-light">
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="container mt-4">
    <h4 class="mb-4">내가 작성한 글 (전체 게시판)</h4>
    <hr>

    <!-- 자유게시판 -->
    <c:if test="${not empty freePosts}">
        <h5 class="mt-4 text-primary">자유게시판</h5>
        <div class="row g-3 mb-3">
            <c:forEach var="post" items="${freePosts}">
                <div class="col-md-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body">
                            <span class="badge bg-primary-subtle badge-board">자유</span>
                            <a href="/free/detail/${post.id}" class="h6 card-title text-dark text-decoration-none">
                                ${post.title}
                            </a>
                            <div class="small text-muted mb-1">${post.createdAt} | 조회수 ${post.views}</div>
                            <a href="/free/detail/${post.id}" class="btn btn-warning btn-sm mt-2">
                                상세보기 <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <!-- 제보 및 신고 -->
    <c:if test="${not empty flagPost}">
        <h5 class="mt-4 text-danger">제보 및 신고 게시판</h5>
        <div class="row g-3 mb-3">
            <c:forEach var="post" items="${flagPost}">
                <div class="col-md-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body">
                            <span class="badge bg-danger-subtle badge-board">신고</span>
                            <a href="/flag/detail/${post.id}" class="h6 card-title text-dark text-decoration-none">
                                ${post.title}
                            </a>
                            <div class="small text-muted mb-1">${post.createdAt} | 조회수 ${post.views}</div>
                            <a href="/flag/detail/${post.id}" class="btn btn-warning btn-sm mt-2">
                                상세보기 <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <!-- 미아/아동범죄 -->
    <c:if test="${not empty missPosts}">
        <h5 class="mt-4 text-success">미아/아동범죄 게시판</h5>
        <div class="row g-3 mb-3">
            <c:forEach var="post" items="${missPosts}">
                <div class="col-md-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body">
                            <span class="badge bg-success-subtle badge-board">미아</span>
                            <a href="/miss/detail/${post.id}" class="h6 card-title text-dark text-decoration-none">
                                ${post.title}
                            </a>
                            <div class="small text-muted mb-1">${post.createdAt} | 조회수 ${post.views}</div>
                            <a href="/miss/detail/${post.id}" class="btn btn-warning btn-sm mt-2">
                                상세보기 <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <!-- 위탁 -->
    <c:if test="${not empty entrustPosts}">
        <h5 class="mt-4 text-warning">위탁 게시판</h5>
        <div class="row g-3 mb-3">
            <c:forEach var="post" items="${entrustPosts}">
                <div class="col-md-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body">
                            <span class="badge bg-warning-subtle badge-board">위탁</span>
                            <a href="/entrust/detail/${post.id}" class="h6 card-title text-dark text-decoration-none">
                                ${post.title}
                            </a>
                            <div class="small text-muted mb-1">${post.createdAt} | 조회수 ${post.views}</div>
                            <a href="/entrust/detail/${post.id}" class="btn btn-warning btn-sm mt-2">
                                상세보기 <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- 아무 글도 없을 때 안내 -->
    <c:if test="${empty freePosts and empty flagPosts and empty missPosts and empty entrustPosts}">
        <div class="text-center text-secondary py-5">
            <h5>작성한 글이 없습니다.</h5>
        </div>
    </c:if>
</div>
<!-- 아이콘 CDN -->
<script src="https://kit.fontawesome.com/65ecdc8e2b.js" crossorigin="anonymous"></script>
</body>
</html>
