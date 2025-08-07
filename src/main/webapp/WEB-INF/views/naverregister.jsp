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
    <c:if test="${not empty registerError}">
        <script>
            alert('${registerError}');
        </script>
    </c:if>
<h1>회원가입</h1>
<!-- 나중에 ajax 처리하기(아이디,닉네임 중복, 비밀번호 유효성 등)-->
    <form action="/register" method="post" onsubmit="return confirm('회원가입을 진행하시겠습니까?');">
        <div>
            <label for="reg-nickname">닉네임:</label>
            <input type="text" id="reg-nickname" name="nickname" required/>
        </div>
        <div>
            <label for="reg-region">지역:</label>
            <select name="region" id="reg-region" required>
                <option value="서울특별시">서울특별시</option>
                <option value="부산광역시">부산광역시</option>
                <option value="대구광역시">대구광역시</option>
                <option value="인천광역시">인천광역시</option>
                <option value="광주광역시">광주광역시</option>
                <option value="대전광역시">대전광역시</option>
                <option value="울산광역시">울산광역시</option>
                <option value="새종특별자치시">세종특별자치시</option>
                <option value="경기도">경기도</option>
                <option value="강원특별자치도">강원특별자치도</option>
                <option value="충청북도">충청북도</option>
                <option value="충청남도">충청남도</option>
                <option value="전북특별자치도">전북특별자치도</option>
                <option value="전라남도">전라남도</option>
                <option value="경상북도">경상북도</option>
                <option value="경상남도">경상남도</option>
                <option value="제주특별자치도">제주특별자치도</option>
              </select>
        </div>
        <div>
            <input type="submit" value="회원가입"/>
        </div>

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>


</body>
</html>
