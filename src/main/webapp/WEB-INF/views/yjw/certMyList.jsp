<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>내 자녀 등록 내역</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <style>
    :root{
      --brand:#F2AC28; --bg:#F7F7F7; --text:#222; --muted:#808080;
      --card:#fff; --line:#e9e9e9; --shadow:0 10px 24px rgba(0,0,0,.06);
      --radius:16px;
      --ok:#16a34a; --bad:#dc2626; --wait:#6b7280;
    }
    *{box-sizing:border-box}
    body{
      margin:0; background:var(--bg); color:var(--text);
      font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Helvetica,Arial,sans-serif;
    }
    .wrap{min-height:100vh; padding:44px 16px; display:flex; justify-content:flex-start}
    .container{width:100%; max-width:1000px; margin:0 auto}

    .page-head{ display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:16px; }
    .page-title{margin:0; font-weight:800; font-size:22px}
    .sub{color:var(--muted); font-size:14px; margin:4px 0 0}

    .btn{
      display:inline-flex; align-items:center; justify-content:center; gap:8px;
      height:44px; padding:0 16px; border:none; border-radius:12px; cursor:pointer;
      font-weight:700; font-size:14px; text-decoration:none;
      transition:transform .05s ease;
      box-shadow:0 8px 16px rgba(242,172,40,.25);
      background:var(--brand); color:#111;
    }
    .btn:active{transform:translateY(1px)}
    .btn.outline{ background:#fff; color:#111; border:1px solid var(--line); box-shadow:none; }
    .btn.sm{ height:36px; padding:0 12px; font-size:13px; box-shadow:none; }

    .btn-brand{
      background: var(--brand) !important;
      color: #111 !important;
      border: none !important;
      box-shadow: 0 8px 16px rgba(242,172,40,.25) !important;
    }
    .btn-brand:active{ transform: translateY(1px); }
    .btn-brand:hover{ filter: brightness(.98); }

    .card{ background:var(--card); border-radius:var(--radius); box-shadow:var(--shadow); padding:20px; overflow:hidden; }
    .table-wrap{overflow-x:auto}
    table{ width:100%; border-collapse:separate; border-spacing:0; min-width:720px; }
    thead th{
      text-align:left; font-size:13px; color:#666; font-weight:700;
      padding:12px 14px; border-bottom:1px solid var(--line); background:#fafafa;
    }
    tbody td{ padding:14px; border-bottom:1px solid var(--line); vertical-align:middle; font-size:14px; }
    tbody tr:hover{background:#fcfcfc}

    .chip{ display:inline-flex; align-items:center; gap:6px; padding:6px 10px; border-radius:999px; font-weight:700; font-size:12px; border:1px solid; }
    .chip.ok{ color:var(--ok);  border-color:#bbf7d0; background:#ecfdf5;}
    .chip.bad{color:var(--bad); border-color:#fecdd3; background:#fff1f2;}
    .chip.wait{color:var(--wait); border-color:#e5e7eb; background:#f9fafb;}

    .empty{ display:flex; align-items:center; justify-content:center; text-align:center; color:var(--muted); padding:40px 10px; }

    .res-backdrop{
      position:fixed; inset:0; background:rgba(0,0,0,.35);
      display:none; align-items:center; justify-content:center; z-index:5000;
    }
    .res-backdrop.is-open{ display:flex !important; }

    .res-modal{
      width:100%; max-width:640px; background:#fff;
      border-radius:16px; box-shadow:var(--shadow); padding:20px;
      max-height:90vh; overflow:auto;
    }

    .modal-head{ display:flex; align-items:center; justify-content:space-between; margin-bottom:10px; }
    .modal-title{ margin:0; font-weight:800; font-size:18px; }
    .close-x{ border:none; background:transparent; font-size:22px; line-height:1; cursor:pointer; }
    .field{ margin-bottom:12px; }
    .field label{ display:block; font-size:14px; font-weight:700; margin-bottom:6px; }
    .input{
      width:100%; height:44px; border:1px solid var(--line); border-radius:10px; background:#fff;
      padding:0 12px; font-size:14px; outline:none; transition:border .15s, box-shadow .15s;
    }
    .input:focus{ border-color:var(--brand); box-shadow:0 0 0 4px rgba(242,172,40,.15); }
    .row{ display:flex; gap:12px; }
    .col{ flex:1; }
    .drop{ border:1.5px dashed #d9d9d9; border-radius:10px; padding:10px; display:flex; align-items:center; justify-content:space-between; gap:10px; background:#fff; cursor:pointer; }
    .thumb{ display:none; max-width:100%; border:1px solid var(--line); border-radius:10px; margin-top:10px; }
    .actions{ display:flex; gap:10px; justify-content:flex-end; margin-top:10px; }
    .alert{ border-radius:10px; padding:10px 12px; margin-top:8px; display:none; }
    .alert.err{ background:#fff1f2; color:#991b1b; border:1px solid #fecdd3; }

    @media (max-width: 1024px){
      .wrap{ padding:36px 14px; }
      .page-title{ font-size:20px; }
    }
    @media (max-width: 768px){
      .page-head{ flex-direction:column; align-items:flex-start; gap:8px; }
      .btn{ height:40px; padding:0 14px; font-size:13px; }
      .container{ max-width:100%; }
    }
    @media (max-width: 640px){
      table{ border:0; min-width:0; }
      thead{ display:none; }
      tbody, tr, td { display:block; width:100%; }
      tbody tr{
        background:#fff; border:1px solid var(--line); border-radius:12px;
        padding:10px 12px; box-shadow:var(--shadow); margin-bottom:12px;
      }
      tbody td{
        border:none; padding:8px 0; word-break:break-word;
      }
      tbody td + td{ border-top:1px dashed #eee; }
      tbody td::before{
        content: attr(data-label);
        display:block; font-size:12px; color:#777; margin-bottom:4px; font-weight:700;
      }
      .chip{ font-size:11px; padding:5px 8px; }

      .res-modal{ width:94vw; max-height:85vh; padding:16px; }
      .row{ flex-direction:column; gap:8px; }
    }
    @media (max-width: 480px){
      .actions{ flex-direction:column; align-items:stretch; }
      .btn.sm{ height:32px; padding:0 10px; font-size:12px; }
    }
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp" />
<div class="wrap">
  <div class="container">

    <div class="page-head">
      <div>
        <h1 class="page-title">내 자녀 등록 내역</h1>
        <p class="sub">제출/승인 현황을 확인할 수 있어요.</p>
      </div>
      <a class="btn btn-brand" href="<c:url value='/cert/upload'/>">자녀 등록하기</a>
    </div>

    <c:choose>
      <c:when test="${empty items}">
        <div class="card empty">
          아직 등록된 내역이 없습니다.
          <a class="btn outline" style="margin-left:12px" href="<c:url value='/cert/upload'/>">지금 등록</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="card table-wrap">
          <table>
            <thead>
            <tr>
              <th style="width:18%">자녀</th>
              <th style="width:16%">생년월일</th>
              <th style="width:26%">학교/학년</th>
              <th style="width:14%">상태</th>
              <th style="width:16%">등록일</th>
              <th style="width:20%">비고</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="it" items="${items}">
              <tr>
                <td data-label="자녀">
                  <strong>${it.childName}</strong>
                  <c:if test="${it.childAge != null}"><span style="color:#888;">(${it.childAge})</span></c:if>
                </td>
                <td data-label="생년월일">${it.childBirth}</td>
                <td data-label="학교/학년">${it.childSchool} <c:if test="${not empty it.childGrade}">/ ${it.childGrade}</c:if></td>
                <td data-label="상태">
                  <c:choose>
                    <c:when test="${it.status == 'APPROVED'}"><span class="chip ok">승인됨</span></c:when>
                    <c:when test="${it.status == 'REJECTED'}"><span class="chip bad">반려됨</span></c:when>
                    <c:otherwise><span class="chip wait">승인 대기</span></c:otherwise>
                  </c:choose>
                </td>
                <td data-label="등록일">${it.createdAt}</td>
                <td data-label="비고">
                  <c:if test="${it.status == 'REJECTED'}">
                    <button class="btn sm outline"
                            data-id="${it.id}"
                            data-name="${fn:escapeXml(it.childName)}"
                            data-birth="${it.childBirth}"
                            data-school="${fn:escapeXml(it.childSchool)}"
                            data-grade="${fn:escapeXml(it.childGrade)}"
                            onclick="handleOpenResubmit(this)">
                      수정 후 재제출
                    </button>
                    <div class="text-danger small mt-1">반려사유: ${it.rejectReason}</div>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<div id="resubmitBackdrop" class="res-backdrop">
  <div class="res-modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <div class="modal-head">
      <h3 id="modalTitle" class="modal-title">재제출</h3>
      <button class="close-x" type="button" onclick="closeResubmit()">×</button>
    </div>

    <form id="resubmitForm" method="post" enctype="multipart/form-data">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

      <div class="row">
        <div class="field col">
          <label for="rsName">자녀 이름</label>
          <input class="input" id="rsName" name="childName" type="text" required>
        </div>
        <div class="field col">
          <label for="rsBirth">생년월일</label>
          <input class="input" id="rsBirth" name="childBirth" type="date" required>
        </div>
      </div>

      <div class="row">
        <div class="field col">
          <label for="rsSchool">학교명</label>
          <input class="input" id="rsSchool" name="childSchool" type="text">
        </div>
        <div class="field col">
          <label for="rsGrade">학년</label>
          <input class="input" id="rsGrade" name="childGrade" type="text">
        </div>
      </div>

      <div class="field">
        <label>증빙 이미지 (선택)</label>
        <div class="drop" onclick="document.getElementById('rsFile').click()">
          <span>파일을 선택하거나 클릭</span>
          <button class="btn sm outline" type="button">파일 선택</button>
        </div>
        <input id="rsFile" name="file" type="file" accept="image/*" style="display:none" onchange="previewThumb(event)">
        <img id="rsThumb" class="thumb" alt="미리보기">
      </div>

      <div id="rsMsg" class="alert err"></div>

      <div class="actions">
        <button type="button" class="btn outline" onclick="closeResubmit()">취소</button>
        <button id="rsSubmit" type="submit" class="btn">재제출</button>
      </div>
    </form>
  </div>
</div>

<script>
  let currentId = null;
  let currentRow = null;

  function handleOpenResubmit(btn){
    currentRow = btn.closest('tr');
    openResubmit({
      id: btn.dataset.id,
      name: btn.dataset.name || '',
      birth: btn.dataset.birth || '',
      school: btn.dataset.school || '',
      grade: btn.dataset.grade || ''
    });
  }

  function openResubmit(data){
    currentId = data.id;
    const form = document.getElementById('resubmitForm');

    form.action = '<c:url value="/cert/"/>' + currentId + '/resubmit';

    document.getElementById('rsName').value   = data.name;
    document.getElementById('rsBirth').value  = data.birth;
    document.getElementById('rsSchool').value = data.school;
    document.getElementById('rsGrade').value  = data.grade;

    document.getElementById('rsFile').value = '';
    const th = document.getElementById('rsThumb');
    th.src = ''; th.style.display='none';

    const msg = document.getElementById('rsMsg');
    msg.style.display='none'; msg.textContent='';

    document.getElementById('resubmitBackdrop').classList.add('is-open');
    document.body.style.overflow = 'hidden';
  }

  function closeResubmit(){
    document.getElementById('resubmitBackdrop').classList.remove('is-open');
    document.body.style.overflow = '';
  }

  function previewThumb(e){
    const img = document.getElementById('rsThumb');
    const f = e.target.files && e.target.files[0];
    if(!f){ img.style.display='none'; img.src=''; return; }
    img.src = URL.createObjectURL(f);
    img.style.display = 'block';
  }

  document.addEventListener('keydown', (e)=>{ if(e.key==='Escape') closeResubmit(); });
  document.getElementById('resubmitBackdrop').addEventListener('click', (e)=>{
    if(e.target.id === 'resubmitBackdrop') closeResubmit();
  });

  function setRowToPending(row, updated){
    if(!row) return;
    const statusTd = row.children[3];
    const etcTd    = row.children[5];

    statusTd.innerHTML = '<span class="chip wait">승인 대기</span>';
    etcTd.innerHTML    = '<span class="text-muted small">재제출 완료</span>';

    if (updated){
      if (updated.childSchool || updated.childGrade){
        row.children[2].textContent =
          (updated.childSchool || '') + (updated.childGrade ? (' / ' + updated.childGrade) : '');
      }
    }
  }

  document.getElementById('resubmitForm').addEventListener('submit', async (e)=>{
    e.preventDefault();
    const submitBtn = document.getElementById('rsSubmit');
    const msg = document.getElementById('rsMsg');
    submitBtn.disabled = true; msg.style.display='none'; msg.textContent='';

    try{
      const fd = new FormData(e.target);
      const res = await fetch(e.target.action, { method:'POST', body: fd, redirect:'follow' });

      if (res.redirected) {
        closeResubmit();
        setRowToPending(currentRow, null);
        alert('재제출되었습니다.');
        return;
      }

      const ct = res.headers.get('content-type') || '';

      if (ct.includes('application/json')) {
        const data = await res.json().catch(()=> ({}));
        if (res.ok && (data.ok || data.message)) {
          closeResubmit();
          setRowToPending(currentRow, data.item || null);
          alert(data.message || '재제출되었습니다.');
          return;
        } else {
          msg.textContent = data.error || data.message || `재제출 실패 (HTTP ${res.status})`;
          msg.style.display='block';
          return;
        }
      }

      closeResubmit();
      setRowToPending(currentRow, null);
      alert('재제출되었습니다.');

    }catch(err){
      msg.textContent = '네트워크 오류가 발생했습니다.';
      msg.style.display='block';
    }finally{
      submitBtn.disabled = false;
    }
  });
</script>
</body>
</html>
