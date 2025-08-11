<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>내 자녀 등록 내역</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="mb-0">내 자녀 등록 내역</h3>
    <a class="btn btn-primary btn-sm" href="<c:url value='/cert/upload'/>">자녀 등록하기</a>
  </div>

  <c:choose>
    <c:when test="${empty items}">
      <div class="text-muted">등록된 내역이 없습니다.</div>
    </c:when>
    <c:otherwise>
      <table class="table table-hover align-middle">
        <thead>
          <tr>
            <th>자녀</th><th>생년월일</th><th>학교/학년</th>
            <th>상태</th><th>등록일</th><th>비고</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="it" items="${items}">
          <tr>
            <td>${it.childName} <c:if test="${it.childAge != null}">(${it.childAge})</c:if></td>
            <td>${it.childBirth}</td>
            <td>${it.childSchool} / ${it.childGrade}</td>
            <td>
              <span class="badge
                ${it.status == 'APPROVED' ? 'bg-success' : (it.status == 'REJECTED' ? 'bg-danger' : 'bg-secondary')}">
                ${it.status}
              </span>
            </td>
            <td>${it.createdAt}</td>
            <td>
              <c:if test="${it.status == 'REJECTED'}">
                반려사유: ${it.rejectReason}
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</body>
</html>
