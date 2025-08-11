<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>재학증명서 상세</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
  <h3 class="mb-3">재학증명서 상세</h3>

  <c:set var="d" value="${detail}"/>
  <div class="mb-3">
    <div><b>ID:</b> ${d.id}</div>
    <div><b>유저ID:</b> ${d.userId} / <b>닉네임:</b> ${d.nickname}</div>
    <div><b>자녀:</b> ${d.childName} (${d.childAge}) / ${d.childBirth}</div>
    <div><b>학교/학년:</b> ${d.childSchool} / ${d.childGrade}</div>
    <div><b>상태:</b> ${d.status}</div>
    <div><b>등록일:</b> ${d.createdAt}</div>
    <div class="mt-3"><b>파일 경로:</b> ${d.filePath}</div>
  </div>

  <div id="msg" class="alert d-none"></div>

  <form id="approveForm" class="d-inline-block me-2">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <input type="hidden" name="reviewer" value="${pageContext.request.userPrincipal.name}"/>
    <button type="submit" class="btn btn-success">승인</button>
  </form>

  <form id="rejectForm" class="d-inline-block">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <input type="hidden" name="reviewer" value="${pageContext.request.userPrincipal.name}"/>
    <input type="text" name="reason" class="form-control d-inline-block w-auto me-2" placeholder="반려 사유" required>
    <button type="submit" class="btn btn-danger">반려</button>
  </form>

  <a class="btn btn-link ms-2" href="<c:url value='/cert/admin/list'/>">← 목록</a>

<script>
const id = '${d.id}';
const msg = document.getElementById('msg');

async function post(url, form){
  const fd = new FormData(form);
  const res = await fetch(url, { method: 'POST', body: fd });
  const data = await res.json().catch(()=>({}));
  return {ok: res.ok, data};
}

document.getElementById('approveForm').addEventListener('submit', async (e)=>{
  e.preventDefault();
  const {ok, data} = await post('<c:url value="/cert/admin/${d.id}/approve"/>', e.target);
  msg.className = 'alert ' + (ok && data.ok ? 'alert-success' : 'alert-danger');
  msg.textContent = ok && data.ok ? '승인되었습니다.' : (data.error || '승인 실패');
  msg.classList.remove('d-none');
});

document.getElementById('rejectForm').addEventListener('submit', async (e)=>{
  e.preventDefault();
  const {ok, data} = await post('<c:url value="/cert/admin/${d.id}/reject"/>', e.target);
  msg.className = 'alert ' + (ok && data.ok ? 'alert-success' : 'alert-danger');
  msg.textContent = ok && data.ok ? '반려되었습니다.' : (data.error || '반려 실패');
  msg.classList.remove('d-none');
});
</script>
</body>
</html>
