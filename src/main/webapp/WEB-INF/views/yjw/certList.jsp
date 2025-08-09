<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>재학증명서 승인 대기</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <h3 class="mb-3">승인 대기 목록</h3>

  <table class="table table-hover align-middle">
    <thead>
      <tr><th>ID</th><th>유저ID</th><th>닉네임</th><th>등록일</th><th>보기</th></tr>
    </thead>
    <tbody>
    <c:forEach var="it" items="${items}">
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
</body>
</html>
