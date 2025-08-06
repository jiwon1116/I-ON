
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
    <c:if test="${not empty registerSuccess}">
        <script>
            alert('${registerSuccess}');
        </script>
    </c:if>
    <c:if test="${not empty sessionScope.loginError}">
        <script>
            alert('${sessionScope.loginError}');
        </script>
        <c:remove var="loginError" scope="session"/>
    </c:if>
    <c:if test="${not empty withdrawSuccess}">
        <script>
            alert('${withdrawSuccess}');
        </script>
    </c:if>
	<h1>로그인</h1>
	<form action="${pageContext.request.contextPath}/login" method="post">
		<div> <input type="text" name="username" /> </div>
		<div> <input type="password" name="password" /> </div>
		<div> <input type="submit"/> </div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	</form>
	<hr/>
	<a href="/register">회원가입</a>



</body>
</html>
