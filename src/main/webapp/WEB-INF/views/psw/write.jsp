<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>I-ON</title>

  <style>
    :root{
      --info-primary: rgb(255,199,39);
      --info-border:#e5e7eb;
      --info-muted:#6b7280;
      --info-bg:#fff;
      --info-page:#fff9ed;
      --info-radius:12px;
    }

    body{ margin:0; font-family:'Noto Sans KR',system-ui,-apple-system,Segoe UI,Roboto,sans-serif; background:#fdfdfd; }

    /* 페이지 래퍼 */
    .info-page-wrap{ max-width:1040px; margin:0 auto; padding:40px 16px 72px; background:transparent; }

    /* 카드 */
    .info-form-card{
      max-width:860px; margin:0 auto; background:var(--info-bg);
      border:1px solid var(--info-border); border-radius:var(--info-radius);
      box-shadow:0 8px 24px rgba(0,0,0,.06); padding:28px;
    }


    /* 폼 레이아웃 */
    .info-form-grid{ display:grid; gap:18px; }
    .info-group{ display:grid; gap:8px; }

    .info-label{ font-size:15px; font-weight:700; color:#222; }

    .info-input,.info-textarea{
      width:100%; border:1px solid var(--info-border); border-radius:10px;
      padding:12px 14px; font-size:15px; outline:none; background:#fff;
    }
    .info-input:focus,.info-textarea:focus{ border-color:var(--info-primary); box-shadow:0 0 0 3px rgba(255,199,39,.2); }
    .info-textarea{ min-height:220px; resize:vertical; }

    /* 파일 입력(기능 유지: id/name 변경하지 않음) */
    .info-input-file{
      width:100%; border:1px solid var(--info-border); border-radius:10px;
      padding:10px 12px; background:#fff; font-size:14px; outline:none;
    }
    .info-input-file:focus{ border-color:var(--info-primary); box-shadow:0 0 0 3px rgba(255,199,39,.2); }
    .info-input-file::file-selector-button{
      margin-right:12px; padding:10px 16px; border:none; border-radius:10px;
      background:var(--info-primary); color:#222; font-weight:700; cursor:pointer;
    }
    .info-input-file::file-selector-button:hover{ filter:brightness(.95); }

    /* 액션 버튼 */
    .info-actions{ display:flex; justify-content:flex-end; gap:10px; margin-top:6px; }
    .info-btn{ border:1px solid transparent; border-radius:10px; padding:10px 20px; font-size:15px; cursor:pointer; transition:transform .05s ease, background .15s ease, border-color .15s ease; }
    .info-btn:active{ transform:translateY(1px); }
    .info-btn-secondary{ background:#fff; border-color:var(--info-border); color:#222; }
    .info-btn-secondary:hover{ border-color:#cfd3da; }
    .info-btn-primary{ background:var(--info-primary); color:#222; font-weight:700; }
    .info-btn-primary:hover{ filter:brightness(.95); }

    /* 반응형 */
    @media (max-width:1024px){ .info-form-card{ padding:24px; } }
    @media (max-width:768px){
      .info-page-wrap{ padding:28px 14px 56px; }
    }
    @media (max-width:480px){
      .info-form-card{ padding:20px; }
      .info-actions{ flex-direction:column; }
      .info-btn{ width:100%; }
    }
  </style>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="info-page-wrap">
  <div class="info-form-card">

    <!-- 기능 유지: id/action/method/enctype 동일 -->
    <form id="writeForm" action="${pageContext.request.contextPath}/info/save" method="post" enctype="multipart/form-data">
      <div class="info-form-grid">

        <div class="info-group">
          <label for="title" class="info-label">제목</label>
          <input type="text" id="title" name="title" placeholder="제목을 입력해주세요" required class="info-input" />
        </div>

        <div class="info-group">
          <label for="file" class="info-label">썸네일 이미지(필수)</label>
          <input type="file" class="info-input-file" id="file" name="file" required>
        </div>

        <div class="info-group">
          <label for="file" class="info-label">게시물 이미지(필수)</label>
          <input type="file" class="info-input-file" id="file" name="file" required>
        </div>

        <div class="info-group">
          <label for="content" class="info-label">내용</label>
          <textarea id="content" name="content" placeholder="내용을 입력해주세요" class="info-textarea"></textarea>
        </div>

        <div class="info-actions">
          <button type="button" class="info-btn info-btn-secondary" onClick="goBack()">뒤로가기</button>
          <button type="button" class="info-btn info-btn-primary" onClick="writeFinish()">등록하기</button>
        </div>
      </div>
    </form>
  </div>
</div>

<script>
function writeFinish() {
  const form = document.getElementById("writeForm");
  const requiredFields = form.querySelectorAll("input[required], textarea[required]");
  for (let field of requiredFields) {
    if (!field.value.trim()) {
      alert("모든 항목을 작성해주세요!");
      field.focus();
      return;
    }
  }
  alert("글 작성이 완료되었습니다🙂");
  form.submit();
}
function goBack(){ window.history.back(); }
</script>

</body>
</html>
