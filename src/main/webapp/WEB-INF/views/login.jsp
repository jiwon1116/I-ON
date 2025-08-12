<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root{
      --brand:#F2AC28;
      --bg:#F7F7F7;
      --text:#222;
      --muted:#8a8a8a;
      --card:#fff;
      --line:#ececec;
      --radius:16px;
      --shadow:0 10px 24px rgba(0,0,0,.06);
      --naver:#03C75A;
    }
    *{box-sizing:border-box}
    body{
      margin:0; background:var(--bg); color:var(--text);
      font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Helvetica,Arial,"Apple SD Gothic Neo","Malgun Gothic",sans-serif;
    }
    .wrap{min-height:100vh; display:flex; flex-direction:column; align-items:center; padding:44px 16px}
    .title{text-align:center; margin-bottom:20px}
    .title h1{margin:0 0 8px; font-size:22px; font-weight:800}
    .title p{margin:0; color:var(--muted); font-size:14px}
    .card{
      width:100%; max-width:560px; background:var(--card); border-radius:var(--radius);
      padding:28px; box-shadow:var(--shadow);
    }
    .field{margin-bottom:16px}
    .field label{display:block; font-size:15px; font-weight:600; margin-bottom:8px}
    .input{
      width:100%; height:50px; border:1px solid var(--line); border-radius:12px; background:#fff;
      padding:0 14px; font-size:15px; outline:none; transition:border .15s, box-shadow .15s;
    }
    .input::placeholder{color:#bdbdbd}
    .input:focus{border-color:var(--brand); box-shadow:0 0 0 4px rgba(242,172,40,.15)}
    .btn{
      width:100%; height:50px; border:none; border-radius:12px; font-weight:700; font-size:15px;
      cursor:pointer; transition:transform .05s ease, filter .2s ease;
    }
    .btn:active{transform:translateY(1px)}
    .btn-primary{background:var(--brand); color:#111; box-shadow:0 8px 16px rgba(242,172,40,.25); margin-top: 10px;}
    .btn-naver{
      background:var(--naver); color:#fff; display:flex; align-items:center; justify-content:center; gap:10px;
    }
    .divider{
      display:flex; align-items:center; gap:12px; color:#9a9a9a; font-size:13px; margin:14px 0;
    }
    .divider::before,.divider::after{content:""; flex:1; height:1px; background:var(--line)}
    .footer-link{margin-top:8px; text-align:right}
    .footer-link a{color:#777; text-decoration:none}
    .footer-link a:hover{text-decoration:underline}
    .toast{
      width:100%; max-width:560px; background:#fff3cd; color:#664d03; border:1px solid #ffecb5;
      border-radius:12px; padding:12px 14px; margin-bottom:14px;
    }
  </style>
</head>
<body>

<div class="wrap">

  <!-- 알림 -->
  <c:if test="${not empty registerSuccess}">
    <div class="toast">${registerSuccess}</div>
  </c:if>
  <c:if test="${not empty sessionScope.loginError}">
    <div class="toast">${sessionScope.loginError}</div>
    <c:remove var="loginError" scope="session"/>
  </c:if>
  <c:if test="${not empty withdrawSuccess}">
    <div class="toast">${withdrawSuccess}</div>
  </c:if>

  <!-- 헤더 -->
  <div class="title">
    <h1>아이온 통합 로그인</h1>
    <p>로그인 화면입니다</p>
  </div>

  <!-- 카드 -->
  <div class="card">
    <form action="${pageContext.request.contextPath}/login" method="post">
      <div class="field">
        <label for="username">아이디</label>
        <input class="input" id="username" name="username" type="text" placeholder="아이디" required />
      </div>
      <div class="field">
        <label for="password">비밀번호</label>
        <input class="input" id="password" name="password" type="password" placeholder="비밀번호" required />
      </div>

      <div>
        <input type="checkbox" name="remember-me">로그인 유지
      </div>

      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      <button class="btn btn-primary" type="submit">로그인</button>
    </form>

    <div class="divider">또는</div>

    <!-- 네이버 로그인 버튼 (GET 엔드포인트면 a 태그, POST면 JS로 처리) -->
    <a class="btn btn-naver" href="${pageContext.request.contextPath}/naverLogin">
      <!-- 네이버 아이콘 (SVG) -->
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
</body>
</html>
