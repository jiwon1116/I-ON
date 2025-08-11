<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>재학증명서 업로드</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
  <h3 class="fw-bold mb-2">재학증명서 제출</h3>
  <p class="text-muted">승인 완료 시 서비스 전체 이용이 가능합니다.</p>

  <!-- 서버에서 redirect+flash 로 보낸 메시지가 있을 때(컨트롤러가 @Controller인 경우) -->
  <c:if test="${not empty msg}">
    <div class="alert alert-success">${msg}</div>
  </c:if>
  <!-- AJAX 응답 메시지 영역 -->
  <div id="ajaxMsg" class="alert d-none" role="alert"></div>

 <form id="certForm"
       method="post"
       action="<c:url value='/cert/upload'/>"
       enctype="multipart/form-data"
       class="card p-4">

   <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

   <!-- 자녀 정보 -->
   <div class="mb-3">
     <label class="form-label">자녀 이름 <span class="text-danger">*</span></label>
     <input type="text" name="childName" class="form-control" required placeholder="예: 홍길동">
   </div>

   <div class="row g-3 mb-3">
     <div class="col-md-6">
       <label class="form-label">자녀 생년월일 <span class="text-danger">*</span></label>
       <input type="date" name="childBirth" class="form-control" required onchange="calcAge(this.value)">
     </div>
     <div class="col-md-6">
       <label class="form-label">나이(자동)</label>
       <input type="number" id="childAge" name="childAge" class="form-control" readonly>
     </div>
   </div>

   <div class="row g-3 mb-3">
     <div class="col-md-6">
       <label class="form-label">학교명</label>
       <input type="text" name="childSchool" class="form-control" placeholder="예: ION초등학교">
     </div>
     <div class="col-md-6">
       <label class="form-label">학년</label>
       <input type="text" name="childGrade" class="form-control" placeholder="예: 3학년">
     </div>
   </div>

   <div class="mb-3">
     <label class="form-label">증빙 이미지(JPG/PNG) <span class="text-danger">*</span></label>
     <input type="file" name="file" accept="image/*" class="form-control" required onchange="preview(event)">
   </div>

   <img id="thumb" class="rounded border mb-3" style="max-width:360px; display:none;">
   <button type="submit" class="btn btn-primary">제출</button>
 </form>

 <script>
 function preview(e){
   const img=document.getElementById('thumb');
   const f=e.target.files[0];
   if(!f){ img.style.display='none'; return; }
   img.src=URL.createObjectURL(f);
   img.style.display='block';
 }
 function calcAge(iso){
   const ageEl = document.getElementById('childAge');
   if(!iso){ ageEl.value=''; return; }
   const b = new Date(iso);
   const t = new Date();
   let age = t.getFullYear() - b.getFullYear();
   const m = t.getMonth() - b.getMonth();
   if (m < 0 || (m === 0 && t.getDate() < b.getDate())) age--;
   ageEl.value = age >= 0 ? age : '';
 }

 const form = document.getElementById('certForm');
 const msgBox = document.getElementById('ajaxMsg');
 form.addEventListener('submit', async (e) => {
   e.preventDefault();
   msgBox.className = 'alert d-none';
   msgBox.textContent = '';
   const fd = new FormData(form);
   try {
     const res = await fetch(form.action, { method: 'POST', body: fd });
     const data = await res.json().catch(()=>({}));
     if (res.ok && data.message) {
       msgBox.className = 'alert alert-success';
       msgBox.textContent = data.message;
       // form.reset(); document.getElementById('thumb').style.display='none';
     } else {
       msgBox.className = 'alert alert-danger';
       msgBox.textContent = data.error || data.message || `업로드 실패 (HTTP ${res.status})`;
     }
   } catch {
     msgBox.className = 'alert alert-danger';
     msgBox.textContent = '네트워크 오류가 발생했습니다.';
   }
 });
 </script>

</body>
</html>
