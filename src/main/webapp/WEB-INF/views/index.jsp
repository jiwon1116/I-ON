<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
</head>
<body>
    <h2>Hello Spring Framework</h2>
    <a href="/free">자유</a>
    <a href="/entrust">위탁</a>


    <security:authorize access="isAnonymous()">
        <a href="/login">로그인</a>
    </security:authorize>

    <security:authorize access="isAuthenticated()">
        <form action="/logout" method="post" style="display:inline;">
            <input type="submit" value="로그아웃"/>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>
    </security:authorize>

    <security:authorize access="isAuthenticated()">
        <form action="/withdraw" method="post">
            <input type="hidden" name="_method" value="delete" />
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit">회원 탈퇴(작동 안함)</button>
        </form>
    </security:authorize>

    <a href="/flag">flag</a>

</body>
</html>