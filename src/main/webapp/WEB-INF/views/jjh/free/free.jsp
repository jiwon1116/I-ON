<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>🎈자유 게시판</title>
</head>
<body>
    <h2>자유 게시판</h2>
        <table border="1" align="center" width="100%" style="border-collapse: collapse; text-align: center">
        	<tr align="center" bgcolor="lightyellow">
                <th width="10%">제목</th>
                <th width="10%">작성자</th>
                <th width="40%">내용</th>
                <th width="24%">작성 날짜</th>
                <th width="8%">조회수</th>
            </tr>
            <!--
            <c:forEach items = "${boardList}" var = "board">
                <tr>
                    <td><a href="detailContent?id=${board.id}">${board.boardTitle}</a></td>
                    <td>${board.boardWriter}</td>
                    <td>${board.boardContent}</td>
                    <td>${board.boardCreatedTime}</td>
                    <td>${board.boardHits}</td>
                </tr>
            </c:forEach>
            -->
        </table>
        <a href = "free/write">글 작성</a>
</body>
</html>