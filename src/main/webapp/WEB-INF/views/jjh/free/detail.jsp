<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>🎈자유 게시판</title>
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
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
    <form>
      제목 : <input type="text" name="title" value="${free.title}" readonly/><br>
      작성자 : <input type="text" name="nickname" value="${free.nickname}" readonly /><br>
      내용 : <textarea name="content" cols="30" rows="10" readonly>${free.content}</textarea><br>
      <button onclick="updateLikeCount()" type="button">좋아요 ${free.like_count}</button>
      <button onclick="updateFn()" type="button">수정하기</button>
      <button onclick="deleteFn()" type="button">삭제하기</button>
      <button onclick="backFn()" type="button">목록</button>
    </form>

    <br><br>

        <div>
            <input type = "text" id = "nickname" placeholder = "작성자">
            <input type = "text" id = "content" placeholder = "내용">
            <button id = "commentBtn" onclick="commentWrite()">댓글 작성</button>
        </div>

        <br>

        <div id = "comment-list">
            <table border="1" width="50%" style="border-collapse: collapse; text-align: center">
                <tr>
                    <th>내용</th>
                    <th>작성자</th>
                    <th>작성 시간</th>
                </tr>
                <c:forEach items = "${commentList}" var = "comment">
                    <tr>
                        <td>${comment.content}</td>
                        <td>${comment.nickname}</td>
                        <td><fmt:formatDate value="${comment.created_at}" pattern="yyyy-MM-dd"/></td>
                        <td><button onclick="commentDelete(${comment.id})" type="button">삭제</button></td>
                    </tr>
                </c:forEach>
            </table>
        </div>
</body>
<script>
    const updateFn = () => {
        location.href = "/free/update?id=${free.id}";
    }
    const deleteFn = () => {
        const confirmed = confirm("정말 삭제하시겠습니까?");
        if(confirmed) {
            location.href = "/free/delete?id=${free.id}";
        }
    }
    const updateLikeCount = () => {
        location.href = "/free/updateLikeCount?id=${free.id}"
    }
    const backFn = () => {
        location.href = "/free"
    }

    const commentDelete = (commentId) => {
      const confirmed = confirm("댓글을 삭제하시겠습니까?");
      if (confirmed) {
        location.href = "/comment/delete?id=" + commentId;
      }
    }


    const commentWrite = () => {
            const nickname = document.getElementById("nickname").value;
            const content = document.getElementById("content").value;
            const postId = "${free.id}";
            $.ajax({
                type: "post",
                url: "/comment/save",
                data: {
                    nickname : nickname,
                    content : content,
                    post_id : postId
                },
                dataType : "json",
                success : function(commentList) {
                    console.log("성공 : " + commentList);
                    let out = "<table border='1' width='50%' style='border-collapse: collapse; text-align: center'><tr>";
                    out += "<th>내용</th>";
                    out += "<th>작성자</th>";
                    out += "<th>작성 시간</th>";
                    out += "<th>삭제</th>";
                    out += "</tr>"
                    for (let i in commentList) {
                        out += "<tr>"
                        out += "<td>"+ commentList[i].content +"</td>";
                        out += "<td>"+ commentList[i].nickname +"</td>";
                        out += "<td>"+ commentList[i].created_at  +"</td>";
                        out += "<td><button onclick='commentDelete(" + commentList[i].id + ")'>삭제</button></td>";
                        out += "</tr>"
                    }
                    out += "</table>";
                    document.getElementById("comment-list").innerHTML = out;
                    document.getElementById("nickname").value = "";
                    document.getElementById("content").value = "";

                },
                error : function() {
                    console.log("실패");
                }
            });
        }
</script>
</html>