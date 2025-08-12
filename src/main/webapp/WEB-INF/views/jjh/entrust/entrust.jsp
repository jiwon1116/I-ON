<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>위탁 게시판</title>
  <c:set var="CTX" value="${pageContext.request.contextPath}" />

  <!-- libs -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <!-- 페이지 전용 CSS -->
  <link href="${CTX}/resources/css/list.css" rel="stylesheet">
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- 메인 콘텐츠 -->
<div class="main-content">

  <!-- 상단 검색 & 글쓰기 -->
  <div class="d-flex justify-content-between align-items-center mb-4">
    <form class="d-flex search-bar" role="search" method="get" action="${CTX}/entrust">
      <input class="form-control me-2" type="search" name="searchContent"
             placeholder="제목, 내용으로 검색" value="${param.searchContent}">
      <button class="search-btn" type="submit" aria-label="검색">
        <i class="bi bi-search"></i>
      </button>
    </form>
    <a class="btn btn-dark" href="${CTX}/entrust/write">글쓰기</a>
  </div>

  <!-- 목록 -->
  <c:if test="${empty entrustboardList}">
    <div class="text-center mt-5 text-muted">게시글이 없습니다.</div>
  </c:if>

  <c:forEach items="${entrustboardList}" var="entrust">
    <a href="${CTX}/entrust/${entrust.id}" class="card-link">
      <div class="card">
        <p class="quote">“${entrust.title}”</p>
        ${entrust.content}
        <div class="d-flex justify-content-between align-items-center mt-2">
          <div class="d-flex align-items-center">
            <img src="${CTX}/images/default-profile.png" alt="profile">
            <div class="ms-2">
              <div class="fw-semibold">
                <a href="${CTX}/othermemberprofile/checkprofile?nickname=${entrust.nickname}">
                  ${entrust.nickname}
                </a>
              </div>
              <div class="text-muted">
                <fmt:formatDate value="${entrust.created_at}" pattern="yyyy.MM.dd"/>
                · 좋아요 ${entrust.like_count} · 조회수 ${entrust.view_count}
              </div>
            </div>
          </div>
          <span class="text-muted">▶</span>
        </div>
      </div>
    </a>
  </c:forEach>

  <!-- 페이지네이션 (요청한 스타일 유지) -->
  <nav aria-label="Page navigation">
    <ul class="pagination mt-4 justify-content-center">

      <!-- 이전 -->
      <c:choose>
        <c:when test="${paging.page <= 1}">
          <li class="page-item disabled"><a class="page-link">← Previous</a></li>
        </c:when>
        <c:otherwise>
          <li class="page-item">
            <a class="page-link" href="${CTX}/entrust?page=${paging.page - 1}&searchContent=${param.searchContent}">
              ← Previous
            </a>
          </li>
        </c:otherwise>
      </c:choose>

      <!-- 번호 -->
      <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
        <c:choose>
          <c:when test="${i eq paging.page}">
            <li class="page-item active"><a class="page-link" href="#">${i}</a></li>
          </c:when>
          <c:otherwise>
            <li class="page-item">
              <a class="page-link" href="${CTX}/entrust?page=${i}&searchContent=${param.searchContent}">${i}</a>
            </li>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <!-- 다음 -->
      <c:choose>
        <c:when test="${paging.page >= paging.maxPage}">
          <li class="page-item disabled"><a class="page-link">Next →</a></li>
        </c:when>
        <c:otherwise>
          <li class="page-item">
            <a class="page-link" href="${CTX}/entrust?page=${paging.page + 1}&searchContent=${param.searchContent}">
              Next →
            </a>
          </li>
        </c:otherwise>
      </c:choose>

    </ul>
  </nav>
</div>

</body>
</html>
