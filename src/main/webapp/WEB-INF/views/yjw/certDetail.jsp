<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>재학증명서 상세</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    :root{
      --brand:#F2AC28; --bg:#F7F7F7; --text:#222; --muted:#808080;
      --card:#fff; --line:#e9e9e9; --shadow:0 10px 24px rgba(0,0,0,.06);
      --radius:16px; --ok:#16a34a; --bad:#dc2626; --wait:#6b7280;
    }
    *{box-sizing:border-box}
    body{margin:0; background:var(--bg); color:var(--text);
      font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Helvetica,Arial,sans-serif;}
    .wrap{min-height:100vh; padding:44px 16px; display:flex; justify-content:flex-start}
    .container-n{width:100%; max-width:1100px; margin:0 auto}

    .page-head{display:flex; align-items:flex-start; justify-content:space-between; gap:16px; margin-bottom:18px}
    .page-title{margin:0; font-weight:800; font-size:22px}
    .sub{color:var(--muted); font-size:14px; margin-top:6px}

    .card-n{background:var(--card); border-radius:var(--radius); box-shadow:var(--shadow); padding:20px}
    .grid{display:grid; grid-template-columns:1fr 1fr; gap:12px 22px}
    .row-lbl{color:#666; font-size:13px}
    .row-val{font-weight:600}
    @media (max-width: 800px){ .grid{grid-template-columns:1fr} }

    .chip{
      display:inline-flex; align-items:center; gap:6px;
      padding:6px 10px; border-radius:999px; font-weight:700; font-size:12px; border:1px solid;
    }
    .chip.ok{ color:var(--ok);  border-color:#bbf7d0; background:#ecfdf5;}
    .chip.bad{color:var(--bad); border-color:#fecdd3; background:#fff1f2;}
    .chip.wait{color:var(--wait); border-color:#e5e7eb; background:#f9fafb;}

    .preview{background:#fff; border:1px solid var(--line); border-radius:12px; padding:10px;
      display:flex; align-items:center; justify-content:center}
    .preview img{max-width:100%; max-height:70vh; border-radius:8px}

    .actions{display:flex; gap:10px; flex-wrap:wrap}
    .btn-brand{
      display:inline-flex; align-items:center; justify-content:center;
      height:40px; padding:0 14px; border:none; border-radius:12px; cursor:pointer; text-decoration:none;
      font-weight:700; font-size:14px; background:var(--brand); color:#111;
      box-shadow:0 8px 16px rgba(242,172,40,.25);
    }
    .btn-outline{background:#fff; color:#111; border:1px solid var(--line); box-shadow:none}
    .btn-danger-n{background:#ef4444; color:#fff; box-shadow:0 8px 16px rgba(239,68,68,.25)}
    .reason{height:40px; border:1px solid var(--line); border-radius:10px; padding:0 12px; outline:none}
    .reason:focus{border-color:var(--brand); box-shadow:0 0 0 4px rgba(242,172,40,.15)}

    .alert-n{border-radius:12px; padding:12px 14px; margin-top:14px}
    .alert-success-n{background:#ecfdf3; color:#166534; border:1px solid #bbf7d0}
    .alert-danger-n{background:#fff1f2; color:#991b1b; border:1px solid #fecdd3}
    .d-none{display:none}
  </style>
</head>
<body>
<div class="wrap">
  <div class="container-n">

    <div class="page-head">
      <div>
        <h3 class="page-title">재학증명서 상세</h3>
        <p class="sub">접수 내역을 확인하고 승인/반려를 진행하세요.</p>
      </div>

      <div class="actions">
        <form id="approveForm" class="d-flex gap-2 align-items-center">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <input type="hidden" name="reviewer" value="${pageContext.request.userPrincipal.name}"/>
          <button type="submit" class="btn-brand">승인</button>
        </form>
        <form id="rejectForm" class="d-flex gap-2 align-items-center">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <input type="hidden" name="reviewer" value="${pageContext.request.userPrincipal.name}"/>
          <input type="text" name="reason" class="reason" placeholder="반려 사유" required>
          <button type="submit" class="btn-danger-n btn-brand" style="height:40px;">반려</button>
        </form>
        <a class="btn-brand btn-outline" href="<c:url value='/cert/admin/list'/>">← 목록</a>
      </div>
    </div>

    <c:set var="d" value="${detail}"/>

    <div class="card-n mb-3">
      <div class="grid">
        <div>
          <div class="row-lbl">ID</div>
          <div class="row-val">${d.id}</div>
        </div>
        <div>
          <div class="row-lbl">등록일</div>
          <div class="row-val">${d.createdAt}</div>
        </div>

        <div>
          <div class="row-lbl">유저</div>
          <div class="row-val">${d.userId} / ${d.nickname}</div>
        </div>
        <div>
          <div class="row-lbl">상태</div>
          <div class="row-val">
            <c:choose>
              <c:when test="${d.status == 'APPROVED'}"><span class="chip ok">승인됨</span></c:when>
              <c:when test="${d.status == 'REJECTED'}"><span class="chip bad">반려됨</span></c:when>
              <c:otherwise><span class="chip wait">승인 대기</span></c:otherwise>
            </c:choose>
          </div>
        </div>

        <div>
          <div class="row-lbl">자녀</div>
          <div class="row-val">${d.childName} <c:if test="${d.childAge != null}">(${d.childAge})</c:if></div>
        </div>
        <div>
          <div class="row-lbl">생년월일</div>
          <div class="row-val">${d.childBirth}</div>
        </div>

        <div>
          <div class="row-lbl">학교</div>
          <div class="row-val">${d.childSchool}</div>
        </div>
        <div>
          <div class="row-lbl">학년</div>
          <div class="row-val">${d.childGrade}</div>
        </div>

        <c:if test="${d.status == 'REJECTED' && not empty d.rejectReason}">
          <div style="grid-column:1/-1">
            <div class="row-lbl">반려 사유</div>
            <div class="row-val" style="color:#991b1b;">${d.rejectReason}</div>
          </div>
        </c:if>
      </div>
    </div>

    <div class="card-n">
      <div class="row-lbl mb-2">증빙 이미지</div>
      <div class="preview">
        <img
          src="<c:url value='/cert/preview/${d.id}'/>"
          alt="재학증명서 미리보기">
      </div>

      <div id="msg" class="alert-n d-none"></div>
    </div>

  </div>
</div>

<script>
  const LIST_URL = '<c:url value="/cert"/>' + '?totalUnreadCount=0';

  const approveBtn = document.querySelector('#approveForm button');
  const rejectBtn  = document.querySelector('#rejectForm button');

  (function initLock(){
    const status = '${d.status}';
    if (status !== 'PENDING') {
      approveBtn.disabled = true;
      rejectBtn.disabled  = true;
    }
  })();

  function lockActions(lock){
    approveBtn.disabled = lock;
    rejectBtn.disabled  = lock;
  }

  async function post(url, form){
    const fd = new FormData(form);
    const res = await fetch(url, { method:'POST', body: fd });
    const data = await res.json().catch(()=>({}));
    return { ok: res.ok, data };
  }

  document.getElementById('approveForm').addEventListener('submit', async (e)=>{
    e.preventDefault();
    lockActions(true);
    try{
      const {ok, data} = await post('<c:url value="/cert/admin/${d.id}/approve"/>', e.target);
      if (ok && (data?.ok || data?.message)) {
        alert('승인되었습니다.');
        location.href = LIST_URL;
      } else {
        alert(data?.error || '승인 실패');
        lockActions(false);
      }
    }catch{
      alert('승인 중 오류가 발생했습니다.');
      lockActions(false);
    }
  });

  document.getElementById('rejectForm').addEventListener('submit', async (e)=>{
    e.preventDefault();
    const reason = e.target.reason?.value?.trim();
    if (!reason) { alert('반려 사유를 입력하세요.'); return; }

    lockActions(true);
    try{
      const {ok, data} = await post('<c:url value="/cert/admin/${d.id}/reject"/>', e.target);
      if (ok && (data?.ok || data?.message)) {
        alert('반려되었습니다.');
        location.href = LIST_URL;
      } else {
        alert(data?.error || '반려 실패');
        lockActions(false);
      }
    }catch{
      alert('반려 처리 중 오류가 발생했습니다.');
      lockActions(false);
    }
  });
</script>

</body>
</html>
