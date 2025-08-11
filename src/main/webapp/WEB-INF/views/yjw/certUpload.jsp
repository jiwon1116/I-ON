<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>재학증명서 업로드</title>
  <style>
    :root{
      --brand:#F2AC28; --bg:#F7F7F7; --text:#222; --muted:#8a8a8a;
      --card:#fff; --line:#e9e9e9; --shadow:0 10px 24px rgba(0,0,0,.06);
      --radius:16px;
    }
    *{box-sizing:border-box}
    body{margin:0; background:var(--bg); color:var(--text);
      font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Helvetica,Arial,sans-serif;}
    .wrap{min-height:100vh; display:flex; flex-direction:column; align-items:center; padding:44px 16px}
    .title{text-align:center; margin-bottom:18px}
    .title h1{margin:0 0 8px; font-weight:800; font-size:24px}
    .title p{margin:0; color:var(--muted); font-size:14px}

    /* stepper */
    .stepper{display:flex; align-items:center; gap:18px; justify-content:center; margin:12px 0 28px}
    .s-dot{width:32px; height:32px; border-radius:16px; display:flex; align-items:center; justify-content:center;
      border:2px solid var(--line); color:#777; background:#fff; font-weight:700}
    .s-dot.active{border-color:var(--brand); background:var(--brand); color:#111}
    .s-line{width:56px; height:2px; background:var(--line)}
    .s-labels{display:flex; gap:64px; justify-content:center; color:#9a9a9a; font-size:12px; margin-top:8px}

    .card{width:100%; max-width:720px; background:var(--card); border-radius:var(--radius);
      box-shadow:var(--shadow); padding:28px}

    .field{margin-bottom:16px}
    .field label{display:block; font-size:15px; font-weight:600; margin-bottom:8px}
    .row{display:flex; gap:14px}
    .col{flex:1}
    .input{
      width:100%; height:50px; border:1px solid var(--line); border-radius:12px; background:#fff;
      padding:0 14px; font-size:15px; outline:none; transition:border .15s, box-shadow .15s}
    .input::placeholder{color:#bdbdbd}
    .input:focus{border-color:var(--brand); box-shadow:0 0 0 4px rgba(242,172,40,.15)}

    /* 파일 업로드 */
    .drop{border:1.5px dashed #d9d9d9; border-radius:12px; padding:14px;
      display:flex; align-items:center; justify-content:space-between; gap:12px; background:#fff}
    .drop:hover{border-color:var(--brand)}
    .drop .hint{color:#9a9a9a; font-size:13px}
    .thumb{display:none; max-width:360px; border:1px solid var(--line); border-radius:12px; margin:10px 0}

    .btn{
      width:100%; height:50px; border:none; border-radius:12px; font-weight:700; font-size:15px;
      background:var(--brand); color:#111; cursor:pointer; box-shadow:0 8px 16px rgba(242,172,40,.25)}
    .btn:active{transform:translateY(1px)}

    .alert{width:100%; max-width:720px; border-radius:12px; padding:12px 14px; margin:10px auto}
    .alert-success{background:#ecfdf3; color:#166534; border:1px solid #bbf7d0}
    .alert-danger{background:#fff1f2; color:#991b1b; border:1px solid #fecdd3}
    .d-none{display:none}
  </style>
</head>
<body>
<div class="wrap">

  <div class="title">
    <h1>재학증명서 제출</h1>
    <p>재학증명서 제출을 위한 정보를 입력해주세요</p>

    <div class="stepper" aria-hidden="true">
      <div class="s-dot">1</div><div class="s-line"></div>
      <div class="s-dot active">2</div><div class="s-line"></div>
      <div class="s-dot">3</div>
    </div>
    <div class="s-labels" aria-hidden="true">
      <span>회원가입</span><span>자녀 정보 설정</span><span>사용 준비 완료</span>
    </div>
  </div>

  <!-- 서버 메시지 -->
  <c:if test="${not empty msg}">
    <div class="alert alert-success">${msg}</div>
  </c:if>
  <!-- AJAX 메시지 -->
  <div id="ajaxMsg" class="alert d-none" role="alert"></div>

  <form id="certForm" class="card" method="post" action="<c:url value='/cert/upload'/>" enctype="multipart/form-data">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

    <div class="field">
      <label for="childName">이름 <span style="color:#dc2626">*</span></label>
      <input class="input" id="childName" name="childName" type="text" placeholder="자녀 이름" required>
    </div>

    <div class="row">
      <div class="field col">
        <label for="childBirth">생년월일 <span style="color:#dc2626">*</span></label>
        <input class="input" id="childBirth" name="childBirth" type="date" required
               onchange="calcAge(this.value)">
      </div>
      <div class="field col">
        <label for="childAge">나이(자동)</label>
        <input class="input" id="childAge" name="childAge" type="number" readonly placeholder="자동 계산">
      </div>
    </div>

    <div class="row">
      <div class="field col">
        <label for="childSchool">학교명</label>
        <input class="input" id="childSchool" name="childSchool" type="text" placeholder="예: ION초등학교">
      </div>
      <div class="field col">
        <label for="childGrade">학년</label>
        <input class="input" id="childGrade" name="childGrade" type="text" placeholder="예: 3학년">
      </div>
    </div>

    <div class="field">
      <label>재학증명서 이미지(JPG/PNG) <span style="color:#dc2626">*</span></label>
      <div class="drop" onclick="document.getElementById('file').click()">
        <span class="hint">파일을 선택하거나 이 영역을 클릭하세요</span>
        <button type="button" class="input" style="width:auto; padding:0 14px; height:40px;">파일 선택</button>
      </div>
      <input id="file" name="file" type="file" accept="image/*" style="display:none" required onchange="preview(event)">
      <img id="thumb" class="thumb" alt="미리보기">
    </div>

    <button type="submit" class="btn">제출하기</button>
  </form>
</div>

<script>
  function preview(e){
    const img = document.getElementById('thumb');
    const f = e.target.files && e.target.files[0];
    if(!f){ img.style.display='none'; img.src=''; return; }
    img.src = URL.createObjectURL(f);
    img.style.display = 'block';
  }

  function calcAge(iso){
    const out = document.getElementById('childAge');
    if(!iso){ out.value=''; return; }
    const b = new Date(iso), t = new Date();
    let age = t.getFullYear() - b.getFullYear();
    const m = t.getMonth() - b.getMonth();
    if(m < 0 || (m === 0 && t.getDate() < b.getDate())) age--;
    out.value = age >= 0 ? age : '';
  }

  const form = document.getElementById('certForm');
    const msgBox = document.getElementById('ajaxMsg');

    form.addEventListener('submit', async (e)=>{
      e.preventDefault();

      // 중복 제출 방지(선택)
      const submitBtn = form.querySelector('button[type="submit"]');
      submitBtn.disabled = true;

      msgBox.className = 'alert d-none';
      msgBox.textContent = '';

      const fd = new FormData(form);
      try{
        const res  = await fetch(form.action, { method:'POST', body: fd });
        const data = await res.json().catch(()=>({}));

        if(res.ok && (data.ok || data.message)){
          // 알림 후 이동
          alert(data.message || '제출되었습니다.');
          window.location.href = '<c:url value="/cert/my"/>';
          return; // 여기서 종료
        }else{
          msgBox.className = 'alert alert-danger';
          msgBox.textContent = data.error || data.message || `업로드 실패 (HTTP ${res.status})`;
        }
      }catch(err){
        msgBox.className = 'alert alert-danger';
        msgBox.textContent = '네트워크 오류가 발생했습니다.';
      }finally{
        submitBtn.disabled = false;
      }
    });
  </script>
</body>
</html>
