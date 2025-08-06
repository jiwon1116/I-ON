<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내가 쓴 글</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .board-card { max-width: 420px; min-width: 320px; flex: 1; margin: 10px; border-radius: 22px; border: 1.5px solid #ffc779; box-shadow: 0 2px 10px rgba(0,0,0,0.04);}
        .board-title { font-size: 1.15rem; font-weight: bold; color: #ff9000; padding: 18px 0 0 20px;}
        .board-scroll { max-height: 350px; overflow-y: auto; }
        .post-card { background: #fffbe7; border-radius: 12px; margin: 12px 16px; padding: 14px 14px 10px 14px; box-shadow: 0 1px 6px rgba(255, 176, 2, 0.10);}
        .post-card-title { font-size: 1rem; font-weight: 500; color: #fc9601;}
        .post-card-meta { color: #8a8a8a; font-size: 12px; margin-bottom: 2px;}
        .post-card-footer { text-align: right;}
        .main-row { display: flex; flex-wrap: wrap; gap: 32px; justify-content: center; }
        @media (max-width: 1100px) {.main-row { flex-direction: column; align-items: center;}}
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="container mt-5 mb-5">
    <h2 class="mb-4">내가 쓴 글</h2>
    <security:authentication property="principal.username" var="loginUserId"/>

    <div class="main-row">
        <!-- 정보공유 게시판 -->
        <div class="card board-card">
            <div class="board-title">📢 정보공유</div>
            <div class="board-scroll">
                <c:choose>
                    <c:when test="${not empty flagPosts}">
                        <c:forEach var="post" items="${flagPosts}">
                            <div class="post-card mb-2">
                                <div class="post-card-title">
                                    <a href="${pageContext.request.contextPath}/flag/${post.id}" style="color:inherit; text-decoration:none;">
                                        ${post.title}
                                    </a>
                                </div>
                                <div class="post-card-meta">
                                    <fmt:formatDate value="${post.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                                    | 조회수: ${post.view_count} | 좋아요: ${post.like_count}
                                </div>
                                <div class="post-card-text" style="font-size:14px; color:#444;">
                                    <c:out value="${fn:length(post.content) > 60 ? fn:substring(post.content, 0, 58) + '...' : post.content}" />
                                </div>
                                <div class="post-card-footer">
                                    <c:if test="${loginUserId eq post.userId}">
                                        <a href="${pageContext.request.contextPath}/flag/update/${post.id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
                                        <a href="${pageContext.request.contextPath}/flag/delete/${post.id}" class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted my-5">아직 내가 작성한 글이 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 자유 게시판 -->
        <div class="card board-card">
            <div class="board-title">💬 자유</div>
            <div class="board-scroll">
                <c:choose>
                    <c:when test="${not empty freePosts}">
                        <c:forEach var="post" items="${freePosts}">
                            <div class="post-card mb-2">
                                <div class="post-card-title">
                                    <a href="${pageContext.request.contextPath}/free/${post.id}" style="color:inherit; text-decoration:none;">
                                        ${post.title}
                                    </a>
                                </div>
                                <div class="post-card-meta">
                                    <fmt:formatDate value="${post.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                                    | 조회수: ${post.view_count} | 좋아요: ${post.like_count}
                                </div>
                                <div class="post-card-text" style="font-size:14px; color:#444;">
                                    <c:out value="${fn:length(post.content) > 60 ? fn:substring(post.content, 0, 58) + '...' : post.content}" />
                                </div>
                                <div class="post-card-footer">
                                    <c:if test="${loginUserId eq post.userId}">
                                        <a href="${pageContext.request.contextPath}/free/update/${post.id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
                                        <a href="${pageContext.request.contextPath}/free/delete/${post.id}" class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted my-5">아직 내가 작성한 글이 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 실종 게시판 -->
        <div class="card board-card">
            <div class="board-title">🔍 실종</div>
            <div class="board-scroll">
                <c:choose>
                    <c:when test="${not empty missPosts}">
                        <c:forEach var="post" items="${missPosts}">
                            <div class="post-card mb-2">
                                <div class="post-card-title">
                                    <a href="${pageContext.request.contextPath}/miss/${post.id}" style="color:inherit; text-decoration:none;">
                                        ${post.title}
                                    </a>
                                </div>
                                <div class="post-card-meta">
                                    <fmt:formatDate value="${post.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                                    | 조회수: ${post.view_count} | 좋아요: ${post.like_count}
                                </div>
                                <div class="post-card-text" style="font-size:14px; color:#444;">
                                    <c:out value="${fn:length(post.content) > 60 ? fn:substring(post.content, 0, 58) + '...' : post.content}" />
                                </div>
                                <div class="post-card-footer">
                                    <c:if test="${loginUserId eq post.userId}">
                                        <a href="${pageContext.request.contextPath}/miss/update/${post.id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
                                        <a href="${pageContext.request.contextPath}/miss/delete/${post.id}" class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted my-5">아직 내가 작성한 글이 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 위탁 게시판 -->
        <div class="card board-card">
            <div class="board-title">🤝 위탁</div>
            <div class="board-scroll">
                <c:choose>
                    <c:when test="${not empty entrustPosts}">
                        <c:forEach var="post" items="${entrustPosts}">
                            <div class="post-card mb-2">
                                <div class="post-card-title">
                                    <a href="${pageContext.request.contextPath}/entrust/${post.id}" style="color:inherit; text-decoration:none;">
                                        ${post.title}
                                    </a>
                                </div>
                                <div class="post-card-meta">
                                    <fmt:formatDate value="${post.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                                    | 조회수: ${post.view_count} | 좋아요: ${post.like_count}
                                </div>
                                <div class="post-card-text" style="font-size:14px; color:#444;">
                                    <c:out value="${fn:length(post.content) > 60 ? fn:substring(post.content, 0, 58) + '...' : post.content}" />
                                </div>
                                <div class="post-card-footer">
                                    <c:if test="${loginUserId eq post.userId}">
                                        <a href="${pageContext.request.contextPath}/entrust/update/${post.id}" class="btn btn-sm btn-outline-secondary me-1">수정</a>
                                        <a href="${pageContext.request.contextPath}/entrust/delete/${post.id}" class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted my-5">아직 내가 작성한 글이 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="text-end mt-5">
        <a href="${pageContext.request.contextPath}/mypage" class="btn btn-secondary">🏠 메인으로</a>
    </div>
</div>
</body>
</html>
