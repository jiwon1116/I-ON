<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 320px;
            text-align: center;
        }
        h2 {
            color: #333;
            margin-bottom: 25px;
        }
        input[type="text"],
        input[type="password"] {
            width: calc(100% - 22px); /* Padding 고려 */
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box; /* 패딩과 보더가 너비에 포함되도록 */
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #0056b3;
        }
        .message {
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 4px;
            font-size: 0.9em;
        }
        .error-message {
            background-color: #ffe0e0;
            color: #cc0000;
            border: 1px solid #ffb3b3;
        }
        .logout-message {
            background-color: #e0ffe0;
            color: #008000;
            border: 1px solid #b3ffb3;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>로그인</h2>

        <%-- 로그인 실패 시 메시지 표시 --%>
        <% if (request.getParameter("error") != null) { %>
            <div class="message error-message">
                아이디 또는 비밀번호가 올바르지 않습니다.
            </div>
        <% } %>

        <%-- 로그아웃 성공 시 메시지 표시 --%>
        <% if (request.getParameter("logout") != null) { %>
            <div class="message logout-message">
                성공적으로 로그아웃되었습니다.
            </div>
        <% } %>

        <form action="/login" method="post">
            <input type="text" id="username" name="username" placeholder="사용자 이름" required><br>
            <input type="password" id="password" name="password" placeholder="비밀번호" required><br>
            <button type="submit">로그인</button>
        </form>
    </div>
</body>
</html>