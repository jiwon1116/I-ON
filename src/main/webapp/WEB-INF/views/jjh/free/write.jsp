<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>🎈자유 게시판 글 작성하기</title>
</head>
<body>
    <h2>글 작성하기</h2>
    <form action="/free/write" method="post">
      <input type="text" name="title" placeholder="제목" /><br>
      <input type="text" name="nickname" placeholder="작성자" /><br>
      <textarea name="content" cols="30" rows="10" placeholder="내용 입력"></textarea><br>
      <input type="submit" value="작성 완료" />
    </form>
</body>
</html>