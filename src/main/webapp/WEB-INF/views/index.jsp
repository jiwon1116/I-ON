<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
</head>
<body>

    <security:authorize access="isAuthenticated()">
            <p>안녕하세요, <c:out value="${member.nickname}"/>님!</p>
    </security:authorize>

    <h2>Hello Spring Framework</h2>
    <a href="/free">자유</a>
    <a href="/entrust">위탁</a>
    <a href="/miss">실종</a>

    <a href="/mypage">마이페이지</a>

    <a href="/map">지도</a>


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
        <a href="/edit">회원 정보 수정(작동안함)</a>
    </security:authorize>

    <security:authorize access="isAuthenticated()">
        <form action="/withdraw" method="post">
            <input type="hidden" name="_method" value="delete" />
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit">회원 탈퇴</button>
        </form>
    </security:authorize>

    <a href="/flag">flag</a>

</body>
</html>