<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>🎈자유 게시판 - 글쓰기</title>
  <c:set var="CTX" value="${pageContext.request.contextPath}" />
  <link rel="stylesheet" href="${CTX}/resources/css/write.css">
</head>
<body>

  <jsp:include page="/WEB-INF/views/header.jsp" />

  <div class="info-page-wrap">
    <div class="info-form-card">
      <form action="${CTX}/free/write" method="post" enctype="multipart/form-data" id="writeForm">
        <div class="info-form-grid">

          <div class="info-group">
            <label for="title" class="info-label">제목</label>
            <input type="text" name="title" id="title" placeholder="제목을 입력해주세요" required class="info-input" />
          </div>

          <div class="info-group">
            <label for="nickname" class="info-label">작성자</label>
            <input type="text" name="nickname" id="nickname" value="${member.nickname}" readonly class="info-input" />
          </div>

          <div class="info-group">
            <label for="uploadFiles" class="info-label">파일 업로드</label>
            <input type="file" name="uploadFiles" id="uploadFiles" multiple class="info-input-file" />
          </div>

          <div class="info-group">
            <label for="content" class="info-label">내용</label>
            <textarea name="content" id="content" rows="8" placeholder="내용을 입력해주세요" required class="info-textarea"></textarea>
          </div>

          <div class="info-actions">
            <button type="button" class="info-btn info-btn-secondary" onclick="history.back()">뒤로가기</button>
            <button type="submit" class="info-btn info-btn-primary">등록하기</button>
          </div>

        </div>
      </form>
    </div>
  </div>

</body>
</html>
