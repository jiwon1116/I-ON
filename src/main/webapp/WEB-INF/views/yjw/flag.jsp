<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커뮤니티</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- 페이지 전용 CSS -->
      <link href="${CTX}/resources/css/list.css" rel="stylesheet" />
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- 메인 콘텐츠 -->
<div class="main-content">

    <!-- 상단 검색 & 글쓰기 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <form class="d-flex search-bar" role="search" method="get" action="${pageContext.request.contextPath}/flag/search">
            <input class="form-control me-2" type="search" name="keyword" placeholder="제목 또는 내용을 검색하세요" value="${param.keyword}">
            <button class="search-btn" type="submit" aria-label="검색">
                    <i class="bi bi-search"></i>
                  </button>
        </form>
        <a href="${pageContext.request.contextPath}/flag/write" class="btn btn-dark">글쓰기</a>
    </div>

    <!-- 게시글 카드 반복 -->
    <c:if test="${empty postList}">
        <div class="text-center mt-5 text-muted">검색 결과가 없습니다.</div>
    </c:if>

    <c:forEach var="post" items="${postList}">
        <a href="${pageContext.request.contextPath}/flag/${post.id}" class="card-link">
            <div class="card">
                <p class="quote">“${post.title}”</p>
                ${post.content}
                <div class="d-flex justify-content-between align-items-center mt-2">
                    <div class="d-flex align-items-center">

                        <div class="ms-2">
                            <div class="fw-semibold">
                               <a href="${pageContext.request.contextPath}/othermemberprofile/checkprofile?nickname=${post.nickname}">${post.nickname}</a>
                                <span class="badge
                                    <c:choose>
                                        <c:when test="${post.status == 'PENDING'}">bg-warning text-dark</c:when>
                                        <c:when test="${post.status == 'APPROVED'}">bg-success</c:when>
                                        <c:when test="${post.status == 'REJECTED'}">bg-danger</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>
                                    ms-2" style="font-size:0.8rem;">
                                    <c:choose>
                                        <c:when test="${post.status == 'PENDING'}">승인대기</c:when>
                                        <c:when test="${post.status == 'APPROVED'}">승인됨</c:when>
                                        <c:when test="${post.status == 'REJECTED'}">반려됨</c:when>
                                        <c:otherwise>${post.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="text-muted" style="font-size: 0.9rem;">
                                조회수: ${post.view_count}, 좋아요: ${post.like_count}
                            </div>
                        </div>
                    </div>
                    <span class="text-muted">▶</span>
                </div>
            </div>
        </a>
    </c:forEach>

    <!-- 동적 페이지네이션 -->
    <nav aria-label="Page navigation">
        <ul class="pagination mt-4 justify-content-center">
            <!-- 이전 버튼 -->
            <c:choose>
                <c:when test="${paging.page <= 1}">
                    <li class="page-item disabled"><a class="page-link">← Previous</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/flag/paging?page=${paging.page - 1}">← Previous</a>
                    </li>
                </c:otherwise>
            </c:choose>
            <!-- 페이지 숫자 반복 -->
            <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
                <c:choose>
                    <c:when test="${i eq paging.page}">
                        <li class="page-item active"><a class="page-link" href="#">${i}</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/flag/paging?page=${i}">${i}</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <!-- 다음 버튼 -->
            <c:choose>
                <c:when test="${paging.page >= paging.maxPage}">
                    <li class="page-item disabled"><a class="page-link">Next →</a></li>
                </c:when>
                <c:otherwise>
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/flag/paging?page=${paging.page + 1}">Next →</a>
                    </li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>
</div>

</body>
</html>
