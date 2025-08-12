<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>실종 게시판</title>
  <c:set var="CTX" value="${pageContext.request.contextPath}" />

  <!-- libs -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <!-- 리스트 전용 CSS (포인트 #FFC112) -->
  <link href="${CTX}/resources/css/list.css" rel="stylesheet">
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- 메인 콘텐츠 -->
<div class="main-content">

  <!-- 상단 검색 & 글쓰기 -->
  <div class="d-flex justify-content-between align-items-center mb-4">
    <form class="d-flex search-bar" role="search" method="get" action="${CTX}/miss">
      <input class="form-control me-2" type="search" name="searchContent"
             placeholder="제목, 내용으로 검색" value="${param.searchContent}">
      <button class="search-btn" type="submit" aria-label="검색">
        <i class="bi bi-search"></i>
      </button>
    </form>
    <a class="btn btn-dark" href="${CTX}/miss/write">글쓰기</a>
  </div>

  <!-- 목록 -->
  <c:if test="${empty missboardList}">
    <div class="text-center mt-5 text-muted">게시글이 없습니다.</div>
  </c:if>

  <c:forEach items="${missboardList}" var="miss">
    <a href="${CTX}/miss/${miss.id}" class="card-link">
      <div class="card">
        <p class="quote">“${miss.title}”</p>
        ${miss.content}
        <div class="d-flex justify-content-between align-items-center mt-2">
          <div class="d-flex align-items-center">

            <div class="ms-2">
              <div class="fw-semibold">
                <a href="${CTX}/othermemberprofile/checkprofile?nickname=${miss.nickname}">
                  ${miss.nickname}
                </a>
              </div>
              <div class="text-muted">
                <fmt:formatDate value="${miss.created_at}" pattern="yyyy.MM.dd"/>
                · 좋아요 ${miss.like_count} · 조회수 ${miss.view_count}
              </div>
            </div>
          </div>
          <span class="text-muted">▶</span>
        </div>
      </div>
    </a>
  </c:forEach>

  <!-- 페이지네이션 (네가 준 스타일 클래스 유지) -->
  <nav aria-label="Page navigation">
    <ul class="pagination mt-4 justify-content-center">
      <!-- 이전 -->
      <c:choose>
        <c:when test="${paging.page <= 1}">
          <li class="page-item disabled"><a class="page-link">← Previous</a></li>
        </c:when>
        <c:otherwise>
          <li class="page-item">
            <a class="page-link" href="${CTX}/miss?page=${paging.page - 1}&searchContent=${param.searchContent}">
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
              <a class="page-link" href="${CTX}/miss?page=${i}&searchContent=${param.searchContent}">${i}</a>
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
            <a class="page-link" href="${CTX}/miss?page=${paging.page + 1}&searchContent=${param.searchContent}">
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
