<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>신고 접수</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <h3 class="mb-3">신고 접수된 목록</h3>
    <c:if test="${not empty editSuccess}">
      <div class="alert alert-success" role="alert">
        ${editSuccess}
      </div>
    </c:if>

  <table class="table table-hover align-middle">
    <thead>
      <tr><th>신고자 ID</th><th>게시판</th><th>신고 내용</th><th>승인</th><th>반려</th></tr>
    </thead>
    <tbody>
    <c:forEach var="report" items="${reportList}">
      <tr>
        <td>${report.reporterId}</td>
        <td>
          ${report.targetBoard} /
          <a href="${pageContext.request.contextPath}/${fn:toLowerCase(report.targetBoard)}/${report.targetContentId}">
            ${report.targetContentId}
          </a>
        </td>
        <td><c:out value="${report.description}"/></td>
        <td>
          <form method="post" action="${pageContext.request.contextPath}/report/${report.id}/approve" style="display:inline;">
            <button type="submit" class="btn btn-sm btn-primary">승인</button>
          </form>
        </td>
        <td>
          <form method="post" action="${pageContext.request.contextPath}/report/${report.id}/reject" style="display:inline;">
            <button type="submit" class="btn btn-sm btn-outline-danger">반려</button>
          </form>
        </td>

      </tr>
    </c:forEach>
    </tbody>
  </table>
</body>
</html>
