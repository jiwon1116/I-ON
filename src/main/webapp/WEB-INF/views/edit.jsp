<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
</head>
<body>
    <form action="/edit" method="post">
                    <div>
                        <label for="edit-password">비밀번호:</label>
                        <input type="password" id="edit-password" name="password" placeholder="변경 시에만 입력" />
                    </div>
                    <div>
                        <label for="edit-nickname">닉네임:</label>
                        <input type="text" id="edit-nickname" name="nickname" value="${member.nickname}"/>
                    </div>
                    <div>
                        <label for="edit-region">지역:</label>
                        <input type="text" id="edit-region" name="region" value="${member.region}" />
                    </div>

                    <input type="hidden" name="_method" value="patch" />
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit">회원 정보 수정(작동안함)</button>
                </form>
</body>
</html>