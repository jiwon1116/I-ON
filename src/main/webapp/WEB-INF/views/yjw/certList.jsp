<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>재학증명서 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <h3 class="mb-3">재학증명서 접수 내역</h3>

  <ul class="nav nav-tabs mb-3" role="tablist">
    <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-all" type="button" role="tab">전체</button></li>
    <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-pending" type="button" role="tab">승인 대기</button></li>
    <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-approved" type="button" role="tab">승인됨</button></li>
    <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-rejected" type="button" role="tab">반려됨</button></li>
  </ul>

  <div class="tab-content">

    <!-- 전체 -->
    <div class="tab-pane fade show active" id="tab-all" role="tabpanel">
      <table class="table table-hover align-middle">
        <thead><tr><th>ID</th><th>유저ID</th><th>닉네임</th><th>상태</th><th>등록일</th><th>보기</th></tr></thead>
        <tbody>
        <c:forEach var="it" items="${all}">
          <tr>
            <td>${it.id}</td>
            <td>${it.userId}</td>
            <td>${it.nickname}</td>
            <td>${it.status}</td>
            <td>${it.createdAt}</td>
            <td>
              <c:url value="/cert/admin/${it.id}/page" var="detailUrl"/>
              <a class="btn btn-sm btn-outline-primary" href="${detailUrl}">상세</a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- 승인 대기 -->
    <div class="tab-pane fade" id="tab-pending" role="tabpanel">
      <table class="table table-hover align-middle">
        <thead><tr><th>ID</th><th>유저ID</th><th>닉네임</th><th>등록일</th><th>보기</th></tr></thead>
        <tbody>
        <c:forEach var="it" items="${pending}">
          <tr>
            <td>${it.id}</td>
            <td>${it.userId}</td>
            <td>${it.nickname}</td>
            <td>${it.createdAt}</td>
            <td>
              <c:url value="/cert/admin/${it.id}/page" var="detailUrl"/>
              <a class="btn btn-sm btn-outline-primary" href="${detailUrl}">상세</a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- 승인됨 -->
    <div class="tab-pane fade" id="tab-approved" role="tabpanel">
      <table class="table table-hover align-middle">
        <thead><tr><th>ID</th><th>유저ID</th><th>닉네임</th><th>등록일</th><th>보기</th></tr></thead>
        <tbody>
        <c:forEach var="it" items="${approved}">
          <tr>
            <td>${it.id}</td>
            <td>${it.userId}</td>
            <td>${it.nickname}</td>
            <td>${it.createdAt}</td>
            <td>
              <c:url value="/cert/admin/${it.id}/page" var="detailUrl"/>
              <a class="btn btn-sm btn-outline-primary" href="${detailUrl}">상세</a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- 반려됨 -->
    <div class="tab-pane fade" id="tab-rejected" role="tabpanel">
      <table class="table table-hover align-middle">
        <thead><tr><th>ID</th><th>유저ID</th><th>닉네임</th><th>등록일</th><th>보기</th></tr></thead>
        <tbody>
        <c:forEach var="it" items="${rejected}">
          <tr>
            <td>${it.id}</td>
            <td>${it.userId}</td>
            <td>${it.nickname}</td>
            <td>${it.createdAt}</td>
            <td>
              <c:url value="/cert/admin/${it.id}/page" var="detailUrl"/>
              <a class="btn btn-sm btn-outline-primary" href="${detailUrl}">상세</a>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
