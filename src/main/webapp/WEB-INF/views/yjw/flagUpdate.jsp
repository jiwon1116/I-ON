<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시글 수정</title>
  <c:set var="CTX" value="${pageContext.request.contextPath}" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${CTX}/resources/css/update.css">
</head>
<body>

  <jsp:include page="/WEB-INF/views/header.jsp" />

  <div class="info-page-wrap">
    <div class="info-form-card">
      <form id="updateForm" action="${CTX}/flag/update" method="post" enctype="multipart/form-data">
        <div class="info-form-grid">

          <input type="hidden" name="id" value="${flag.id}" />

          <div class="info-group">
            <label for="title" class="info-label">제목</label>
            <input type="text" id="title" name="title" value="${flag.title}" required class="info-input" />
          </div>

          <div class="info-group">
            <label for="content" class="info-label">내용</label>
            <textarea id="content" name="content" required class="info-textarea">${flag.content}</textarea>
          </div>

          <c:if test="${not empty fileList}">
            <h6 class="mt-2">기존 첨부 파일</h6>
            <ul class="info-file-list">
              <c:forEach var="file" items="${fileList}">
                <li>
                  <c:choose>
                    <c:when test="${file.storedFileName.endsWith('.jpg') || file.storedFileName.endsWith('.jpeg') || file.storedFileName.endsWith('.png') || file.storedFileName.endsWith('.gif')}">
                      <img src="${CTX}/flag/preview?fileName=${file.storedFileName}" alt="${file.originalFileName}">
                    </c:when>
                    <c:otherwise>
                      <a href="${CTX}/flag/preview?fileName=${file.storedFileName}" target="_blank">${file.originalFileName}</a>
                    </c:otherwise>
                  </c:choose>
                  <label class="ms-2">
                    <input type="checkbox" name="deleteFile" value="${file.id}"> 삭제
                  </label>
                </li>
              </c:forEach>
            </ul>
          </c:if>

          <div class="info-group">
            <label for="boardFile" class="info-label">새 파일 첨부</label>
            <input type="file" id="boardFile" name="boardFile" class="info-input-file" />
          </div>

          <div class="info-actions">
            <button type="button" class="info-btn info-btn-secondary" onclick="history.back()">뒤로가기</button>
            <button type="button" class="info-btn info-btn-primary" onclick="updatefinish()">수정</button>
          </div>

        </div>
      </form>
    </div>
  </div>

  <script>
    function updatefinish(){
      if(!confirm('정말 수정하시겠습니까?')) return;
      const form = document.getElementById('updateForm');
      const required = form.querySelectorAll('[required]');
      for(const el of required){
        if(!el.value.trim()){ alert('모든 항목을 작성해주세요!'); el.focus(); return; }
      }
      form.submit();
    }
  </script>
</body>
</html>
