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

    <form action="/free/update" method="post">
      <input type="hidden" name="id" value="${free.id}" />
      제목 : <input type="text" name="title" value="${free.title}" /><br>
      작성자 : <input type="text" name="nickname" value="${free.nickname}" readonly /><br>
      내용 : <textarea name="content" cols="30" rows="10">${free.content}</textarea><br>
            <input type="submit" value="수정 완료" />
    </form>
</body>

</html>