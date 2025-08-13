<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>위탁 게시판 - 글쓰기</title>
  <c:set var="CTX" value="${pageContext.request.contextPath}" />
  <link rel="stylesheet" href="${CTX}/resources/css/write.css">
</head>
<body>

  <jsp:include page="/WEB-INF/views/header.jsp" />

  <div class="info-page-wrap">
    <div class="info-form-card">
      <form id="writeForm" action="${CTX}/entrust/write" method="post" enctype="multipart/form-data">
        <div class="info-form-grid">

          <div class="info-group">
            <label for="title" class="info-label">제목</label>
            <input type="text" id="title" name="title" placeholder="제목을 입력해주세요" required class="info-input" />
          </div>

          <div class="info-group">
            <label for="nickname" class="info-label">작성자</label>
            <input type="text" id="nickname" name="nickname" value="${member.nickname}" readonly class="info-input" />
          </div>

          <div class="info-group">
            <label for="uploadFiles" class="info-label">파일 업로드</label>
            <input type="file" id="uploadFiles" name="uploadFiles" multiple class="info-input-file" />
          </div>

          <div class="info-group">
            <label for="content" class="info-label">내용</label>
            <textarea id="content" name="content" rows="8" placeholder="내용을 입력해주세요" required class="info-textarea"></textarea>
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
