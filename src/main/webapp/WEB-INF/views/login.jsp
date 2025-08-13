<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>아이온 | 로그인</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
  :root{
    --bg:#FEEBB6;
    --brand:#F2AC28;
    --green:#7DB249;
    --text:#222; --muted:#7B7B7B; --card:#fff; --line:#ececec;
    --radius:16px; --shadow:0 12px 28px rgba(0,0,0,.10);
  }
  *{box-sizing:border-box}
  body{
    margin:0; background:var(--bg); color:var(--text);
    font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Helvetica,Arial,"Apple SD Gothic Neo","Malgun Gothic",sans-serif;
  }


  .hero{
    width:100%; background:var(--bg);
    display:flex; align-items:center; justify-content:center;
    padding:56px 16px 36px; position:relative; overflow:hidden;
  }
  .hero-inner{ width:100%; max-width:980px; text-align:center; }

  .hero-logo{
    display:flex; flex-direction:column;
    align-items:center; justify-content:center; gap:18px;
  }

  .hero-tag{
    display:inline-block; background:var(--green); color:#fff;
    font-weight:700; font-size:14px; padding:10px 16px;
    border-radius:999px; position:relative;


    animation: updown 2.8s ease-in-out infinite;
    -webkit-animation: updown 2.8s ease-in-out infinite;
    will-change: transform;
  }
  .hero-tag::after{
    content:""; position:absolute; bottom:-8px; left:50%; transform:translateX(-50%);
    width:0; height:0; border-left:8px solid transparent; border-right:8px solid transparent; border-top:8px solid var(--green);
  }

  @keyframes updown{
    0%,100% { transform:translateY(0); }
    50%     { transform:translateY(-12px); }
  }
  @-webkit-keyframes updown{
    0%,100% { -webkit-transform:translateY(0); }
    50%     { -webkit-transform:translateY(-12px); }
  }

  .logoImg img{
    height:120px; width:auto; display:block;
  }
  @media (max-width:480px){
    .hero{ padding:44px 14px 28px; }
    .logoImg img{ height:96px; }
  }


  .cloud{ position:absolute; bottom:-40px; left:-40px; width:220px; height:220px; background:#fff; border-radius:50%; opacity:.55; filter:blur(1px); }
  .cloud.c2{ left:auto; right:-30px; width:170px; height:170px; opacity:.45; }
  .cloud.c3{ bottom:-55px; left:120px; width:120px; height:120px; opacity:.4; }


  .wrap{ width:100%; display:flex; justify-content:center; padding:0 16px 80px; }
  .col{ width:100%; max-width:560px; }
  .toast{ background:#fff9df; color:#5b4b09; border:1px solid #ffefb7; border-radius:12px; padding:12px 14px; margin-bottom:12px; }
  .card{ background:var(--card); border-radius:var(--radius); box-shadow:var(--shadow); padding:28px; }
  .title{ text-align:center; margin-bottom:18px; }
  .title h1{ margin:0 0 6px; font-size:22px; font-weight:900; }
  .title p{ margin:0; color:var(--muted); font-size:14px; }
  .field{ margin-bottom:14px; }
  .field label{ display:block; font-size:14px; font-weight:700; margin-bottom:6px; }
  .input{ width:100%; height:48px; border:1px solid var(--line); border-radius:12px; background:#fff; padding:0 14px; font-size:15px; outline:none; transition:border .15s, box-shadow .15s; }
  .input:focus{ border-color:var(--brand); box-shadow:0 0 0 4px rgba(242,172,40,.18); }
  .row-between{ display:flex; align-items:center; justify-content:space-between; gap:8px; margin-top:4px; }
  .btn{ width:100%; height:50px; border:none; border-radius:12px; font-weight:800; font-size:15px; cursor:pointer; transition:transform .05s ease, filter .2s ease; }
  .btn:active{ transform:translateY(1px); }
  .btn-primary{ background:var(--brand); color:#111;  margin-top:10px; }
  .divider{ display:flex; align-items:center; gap:12px; color:#9a9a9a; font-size:13px; margin:14px 0; }
  .divider::before,.divider::after{ content:""; flex:1; height:1px; background:var(--line); }
  .btn-naver{ background:#03C75A; color:#fff; display:flex; align-items:center; justify-content:center; gap:10px; }
  .footer-link{ margin-top:8px; text-align:right; }
  .footer-link a{ color:#666; text-decoration:none; }
  .footer-link a:hover{ text-decoration:underline; }
</style>
</head>
<body>


  <section class="hero">
    <div class="hero-inner">
      <div class="hero-logo">
        <span class="hero-tag">아동 범죄 예방을 위한 커뮤니티 및 실시간 위험 정보 제공 플랫폼</span>
        <div class="logoImg">
          <img src="/resources/img/logo22.jpg" alt="아이온 로고">
        </div>
      </div>
    </div>
    <div class="cloud"></div>
    <div class="cloud c2"></div>
    <div class="cloud c3"></div>
  </section>


  <div class="wrap">
    <div class="col">
      <c:if test="${not empty registerSuccess}"><div class="toast">${registerSuccess}</div></c:if>
      <c:if test="${not empty sessionScope.loginError}"><div class="toast">${sessionScope.loginError}</div><c:remove var="loginError" scope="session" /></c:if>
      <c:if test="${not empty withdrawSuccess}"><div class="toast">${withdrawSuccess}</div></c:if>

      <div class="card">
        <div class="title">
          <h1>아이온 통합 로그인</h1>
          <p>안전한 사용을 위해 로그인해 주세요</p>
        </div>

        <form action="${pageContext.request.contextPath}/login" method="post">
          <div class="field">
            <label for="username">아이디</label>
            <input class="input" id="username" name="username" type="text" placeholder="아이디" required />
          </div>
          <div class="field">
            <label for="password">비밀번호</label>
            <input class="input" id="password" name="password" type="password" placeholder="비밀번호" required />
          </div>

          <div class="row-between">
            <label style="display:flex;align-items:center;gap:8px;font-size:14px;color:#444;">
              <input type="checkbox" name="remember-me" /> 로그인 유지
            </label>
          </div>

          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
          <button class="btn btn-primary" type="submit">로그인</button>
        </form>

        <div class="divider">또는</div>

        <a class="btn btn-naver" href="${pageContext.request.contextPath}/naverLogin" aria-label="네이버 로그인">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="#fff" aria-hidden="true">
            <path d="M16.2 12.9L7.8 0H0v24h7.8V11.1L16.2 24H24V0h-7.8v12.9z"/>
          </svg>
          네이버로 로그인하기
        </a>

        <div class="footer-link">
          <a href="${pageContext.request.contextPath}/register">회원가입하기</a>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
