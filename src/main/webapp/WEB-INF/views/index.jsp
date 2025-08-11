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
    <c:if test="${not empty withdrawError}">
        <script>
            alert('${withdrawError}');
        </script>
    </c:if>
    <security:authorize access="isAuthenticated()">
            <p>안녕하세요, ${member.nickname}님!</p>
    </security:authorize>

    <h2>홈 화면</h2>
    <a href="/free">자유</a>
    <a href="/entrust">위탁</a>
    <a href="/miss">실종</a>

    <a href="/mypage/">마이페이지</a>

    <a href="/map/">지도</a>
    <a href="/info">정보공유게시판</a>

    <security:authorize access="isAnonymous()">
        <a href="/login">로그인</a>
    </security:authorize>

    <security:authorize access="isAuthenticated()">
        <form action="/logout" method="post" style="display:inline;">
            <input type="submit" value="로그아웃"/>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>
    </security:authorize>

    <security:authorize access="isAuthenticated() and principal.memberDTO.provider == 'LOCAL'">
            <a href="/edit">회원 정보 수정</a>
     </security:authorize>

    <security:authorize access="isAuthenticated() and principal.memberDTO.provider == 'NAVER'">
        <a href="/naver-edit">회원 정보 수정</a>
    </security:authorize>



    <security:authorize access="isAuthenticated()">
        <form action="/withdraw" method="post" onsubmit="return confirm('정말 회원을 탈퇴하시겠습니까?');">
            <input type="hidden" name="_method" value="delete" />
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit">회원 탈퇴</button>
        </form>
    </security:authorize>

    <a href="/flag">flag</a>

    <security:authorize access="hasRole('ROLE_ADMIN')">
        <a href="/admin">관리자 페이지</a>
    </security:authorize>

    <security:authorize access="isAuthenticated()">
            <a href="/chat">채팅방 페이지</a>
    </security:authorize>


</body>
</html>