<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>🎈자유 게시판</title>
  <c:set var="CTX" value="${pageContext.request.contextPath}" />
  <link rel="stylesheet" href="${CTX}/resources/css/update.css">
</head>
<body>

  <jsp:include page="/WEB-INF/views/header.jsp" />

  <div class="info-page-wrap">
    <div class="info-form-card">
      <form action="${CTX}/free/update/${free.id}" method="post" enctype="multipart/form-data" id="updateForm">
        <div class="info-form-grid">


          <input type="hidden" name="id" value="${free.id}" />

          <div class="info-group">
            <label for="title" class="info-label">제목</label>
            <input type="text" name="title" id="title" value="${free.title}" required class="info-input" />
          </div>

          <input type="hidden" name="id" value="${free.id}" />



          <div class="info-group">
            <label for="content" class="info-label">내용</label>
            <textarea name="content" id="content" rows="8" required class="info-textarea">${free.content}</textarea>
          </div>

        <div class="info-group">
          <label for="uploadFiles" class="info-label">파일 업로드</label>
          <input type="file" name="file" id="uploadFiles" multiple class="info-input-file" />
        </div>

          <div class="info-actions">
            <button type="button" class="info-btn info-btn-secondary" onclick="history.back()">뒤로가기</button>
            <button type="submit" class="info-btn info-btn-primary">수정하기</button>
          </div>

        </div>
      </form>
    </div>
  </div>

</body>
</html>
