<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내가 쓴 글</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #fff; }
        .main-box {
            background: #ffeb99;
            border-radius: 20px;
            margin: 150px auto 0 auto;
            max-width: 900px;
            padding: 36px 36px 32px 36px;
            box-shadow: 0 8px 24px rgba(255,200,70,0.11);
        }
        .nav-pills .nav-link.active {
            background-color: #ffc107 !important;
            color: #fff !important;
            font-weight: bold;
        }
        .nav-pills .nav-link {
            color: #ffa600 !important;
            font-weight: bold;
            font-size: 1.07rem;
        }
        .tab-content {
            border-radius: 18px;
            margin-top: 24px;
            padding: 25px 18px 18px 18px;
            min-height: 320px;
        }
        .scroll-area {
            max-height: 500px;
            overflow-y: auto;
            padding-right: 5px;
        }
        .card {
            border-radius: 14px;
            box-shadow: 0 2px 9px rgba(255, 198, 50, 0.09);
            margin-bottom: 18px;
        }
        .card-title {
            color: #fc9000;
            font-weight: 600;
        }
        .card-text {
            color: #333;
        }
        .post-meta {
            color: #888; font-size: 13px; margin-bottom: 4px;
        }
        .card-footer {
            background: none;
            border-top: none;
            padding-top: 4px;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="container mt-5 mb-5">
    <div class="main-box">
        <ul class="nav nav-pills mb-3 justify-content-center" id="postTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="free-tab" data-bs-toggle="pill" data-bs-target="#free" type="button" role="tab">자유 게시판</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="miss-tab" data-bs-toggle="pill" data-bs-target="#miss" type="button" role="tab">실종 게시판</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="entrust-tab" data-bs-toggle="pill" data-bs-target="#entrust" type="button" role="tab">위탁 게시판</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="flag-tab" data-bs-toggle="pill" data-bs-target="#flag" type="button" role="tab">신고 게시판</button>
            </li>
        </ul>
        <div class="tab-content" id="postTabContent">
            <!-- 자유 게시판 -->
            <div class="tab-pane fade show active" id="free" role="tabpanel">
                <div class="scroll-area">
                    <c:forEach var="post" items="${freePosts}">
                        <div class="card">
                            <div class="card-body">
                                <div class="card-title">
                                    <a href="${pageContext.request.contextPath}/free/${post.id}" style="color:inherit; text-decoration:none;">
                                        "${post.title}"
                                    </a>
                                </div>
                                <div class="post-meta">
                                    작성일: <c:out value="${post.created_at}" /> | 조회수: ${post.view_count} | 좋아요: ${post.like_count}
                                </div>
                                <p class="card-text">
                                    <c:out value="${fn:length(post.content) > 60 ? fn:substring(post.content, 0, 58) + '...' : post.content}" />
                                </p>
                            </div>
                            <div class="card-footer text-end">
                                <a href="${pageContext.request.contextPath}/free/update/${post.id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
                                <a href="${pageContext.request.contextPath}/free/delete/${post.id}" class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty freePosts}">
                        <div class="text-center text-muted py-5">아직 내가 작성한 자유 게시글이 없습니다.</div>
                    </c:if>
                </div>
            </div>
            <!-- 실종 게시판 -->
            <div class="tab-pane fade" id="miss" role="tabpanel">
                <div class="scroll-area">
                    <c:forEach var="post" items="${missPosts}">
                        <div class="card">
                            <div class="card-body">
                                <div class="card-title">
                                    <a href="${pageContext.request.contextPath}/miss/${post.id}" style="color:inherit; text-decoration:none;">
                                        "${post.title}"
                                    </a>
                                </div>
                                <div class="post-meta">
                                    작성일: <c:out value="${post.created_at}" /> | 조회수: ${post.view_count}
                                </div>
                                <p class="card-text">
                                    <c:out value="${fn:length(post.content) > 60 ? fn:substring(post.content, 0, 58) + '...' : post.content}" />
                                </p>
                            </div>
                            <div class="card-footer text-end">
                                <a href="${pageContext.request.contextPath}/miss/update/${post.id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
                                <a href="${pageContext.request.contextPath}/miss/delete/${post.id}" class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty missPosts}">
                        <div class="text-center text-muted py-5">아직 내가 작성한 실종 게시글이 없습니다.</div>
                    </c:if>
                </div>
            </div>
            <!-- 위탁 게시판 -->
            <div class="tab-pane fade" id="entrust" role="tabpanel">
                <div class="scroll-area">
                    <c:forEach var="post" items="${entrustPosts}">
                        <div class="card">
                            <div class="card-body">
                                <div class="card-title">
                                    <a href="${pageContext.request.contextPath}/entrust/${post.id}" style="color:inherit; text-decoration:none;">
                                        "${post.title}"
                                    </a>
                                </div>
                                <div class="post-meta">
                                    작성일: <c:out value="${post.created_at}" />
                                </div>
                                <p class="card-text">
                                    <c:out value="${fn:length(post.content) > 60 ? fn:substring(post.content, 0, 58) + '...' : post.content}" />
                                </p>
                            </div>
                            <div class="card-footer text-end">
                                <a href="${pageContext.request.contextPath}/entrust/update/${post.id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
                                <a href="${pageContext.request.contextPath}/entrust/delete/${post.id}" class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty entrustPosts}">
                        <div class="text-center text-muted py-5">아직 내가 작성한 위탁 게시글이 없습니다.</div>
                    </c:if>
                </div>
            </div>
            <!-- 신고 게시판 -->
            <div class="tab-pane fade" id="flag" role="tabpanel">
                <div class="scroll-area">
                    <c:forEach var="post" items="${flagPosts}">
                        <div class="card">
                            <div class="card-body">
                                <div class="card-title">
                                    <a href="${pageContext.request.contextPath}/flag/${post.id}" style="color:inherit; text-decoration:none;">
                                        "${post.title}"
                                    </a>
                                </div>
                                <div class="post-meta">
                                    작성일: <c:out value="${post.created_at}" />
                                </div>
                                <p class="card-text">
                                    <c:out value="${fn:length(post.content) > 60 ? fn:substring(post.content, 0, 58) + '...' : post.content}" />
                                </p>
                            </div>
                            <div class="card-footer text-end">
                                <a href="${pageContext.request.contextPath}/flag/update/${post.id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
                                <a href="${pageContext.request.contextPath}/flag/delete/${post.id}" class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty flagPosts}">
                        <div class="text-center text-muted py-5">아직 내가 작성한 신고 게시글이 없습니다.</div>
                    </c:if>
                </div>
            </div>

        </div>
        <div class="text-end mt-4">
            <a href="${pageContext.request.contextPath}/mypage" class="btn btn-warning">메인으로</a>
        </div>
    </div>
</div>
<!-- 부트스트랩 JS CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>