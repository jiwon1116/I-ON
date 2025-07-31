<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글쓰기</title>
    <style>
    body {
        margin: 0;
        font-family: sans-serif;
    }

    .container {
        display: flex;
        height: 100vh;
    }

    .sidebar {
        width: 220px;
        background-color: #333;
        color: white;
        padding: 20px;
    }

    .sidebar ul {
        list-style: none;
        padding: 0;
    }

    .sidebar li {
        margin: 20px 0;
        cursor: pointer;
    }

        .form-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 0 auto;
        }

        .form-container h2 {
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 200px;
        }

        .form-group input[type="file"] {
            border: none;
        }

        .form-actions {
            text-align: right;
        }

        .form-actions button {
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .form-actions button:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 사이드바 -->
    <aside class="sidebar">
        <ul>
            <li><strong>마이페이지</strong></li>
            <li>범죄 예방 지도</li>
            <li>커뮤니티</li>
            <li>제보 및 신고</li>
            <li>정보 공유</li>
        </ul>
    </aside>

    <!-- 메인 콘텐츠 -->
    <main class="content">
        <div class="form-container">
            <h2>정보 공유 글쓰기</h2>
             <form action="/info/detail" method="post" name="updateForm">
                <div class="form-group">
                    <input type="text" id="title" name="title" readonly value="${findDto.title}" />
                </div>
                <div class="form-group">
                    <textarea id="content" name="content" readonly>${findDto.content}</textarea>
                </div>

                <div class="form-group">
                    <label for="file">첨부파일</label>
                    <input type="file" id="file" name="file"/>
                </div>
                <input type="hidden" name="id" value="${findDto.id}" readonly/>
                <div class="form-actions">
                    <button type="button" onclick="updatefn()">수정</button>
                     <button type="button" onclick="deletefn()">삭제</button>
                     <button type="button" onclick="infoForm()">목록</button>
                </div>
             </form>
        </div>
    </main>
</div>
</body>

<script>
const updatefn = () => {
    alert ("관리자만 수정이 가능합니다😣");
     document.updateForm.submit();
}
const infoForm = () => {
    location.href = "/info/infoboard";
}

const deletefn = () => {
  const id = ${findDto.id};
  const confirmed = confirm("정말 삭제하시겠습니까?")
              if(confirmed){
               location.href = "/info/delete?id=" + id;
               }else{
               return false;
                }
    }

</script>
</html>
