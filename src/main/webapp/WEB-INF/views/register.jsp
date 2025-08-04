
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>
<body>

<h1>회원가입</h1>
<!-- 나중에 ajax 처리하기(아이디,닉네임 중복, 비밀번호 유효성 등)-->
    <form action="/register" method="post">
        <div>
            <label for="reg-userId">아이디:</label>
            <input type="text" id="reg-userId" name="userId" required/>
        </div>
        <div>
            <label for="reg-password">비밀번호:</label>
            <input type="password" id="reg-password" name="password" required/>
        </div>
        <div>
            <label for="reg-nickname">닉네임:</label>
            <input type="text" id="reg-nickname" name="nickname" required/>
        </div>
        <div>
            <label for="reg-gender">성별:</label>
            <select id="reg-gender" name="gender">
                <option value="M">남자</option>
                <option value="F">여자</option>
            </select>
        </div>
        <div>
            <label for="reg-region">지역:</label>
            <input type="text" id="reg-region" name="region" required/>
        </div>
        <div>
            <!-- <div class="g-recaptcha" data-sitekey="6LfdKZgrAAAAAHP9TN8ZYOJDbKMmdx7Chl1CyUWP"></div> -->
            <input type="submit" value="회원가입"/>
        </div>
        <!-- <c:if test="${not empty reCaptchaError}">
                <p style="color: red;">${reCaptchaError}</p>
        </c:if> -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>


</body>
</html>
