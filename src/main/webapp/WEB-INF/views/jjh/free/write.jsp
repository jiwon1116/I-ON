<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>🎈자유 게시판</title>
</head>
<body>
    <div class="sidebar">
        <h2>logo</h2>
        <ul>
            <li>마이페이지</li>
            <li>범죄 예방 지도</li>
            <li>커뮤니티</li>
            <li>제보 및 신고</li>
            <li>정보 공유</li>
        </ul>
    </div>

    <h2>글 작성하기</h2>
    <form action="/free/write" method="post" enctype="multipart/form-data">
      <input type="text" name="title" placeholder="제목" required/><br>
      <input type="text" name="nickname" placeholder="작성자" required/><br>
      <textarea name="content" cols="30" rows="10" placeholder="내용 입력" required></textarea><br>
      <input type="file" name="uploadFiles" multiple />
      <input type="submit" value="작성 완료" />
    </form>
</body>
</html>