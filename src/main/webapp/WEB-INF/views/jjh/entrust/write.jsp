<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>위탁 게시판</title>
      <style>
        body {
          margin: 0;
          font-family: "Noto Sans KR", sans-serif;
          background-color: #fff8e7;
        }

        .write-container {
          display: flex;
          justify-content: center;
          padding: 32px;
        }

        .write-form {
          background: white;
          border: 1px solid #ddd;
          border-radius: 12px;
          padding: 32px;
          width: 100%;
          max-width: 500px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .write-form label {
          display: block;
          margin-top: 16px;
          font-weight: bold;
          font-size: 14px;
        }

        .write-form input[type="text"],
        .write-form textarea,
        .write-form input[type="file"] {
          width: 100%;
          margin-top: 8px;
          padding: 10px 12px;
          border: 1px solid #ccc;
          border-radius: 6px;
          font-size: 14px;
          box-sizing: border-box;
        }

        .write-form textarea {
          resize: vertical;
        }

        .submit-btn-wrapper {
          text-align: right;
          margin-top: 24px;
        }

        .write-form button {
          background-color: #ffc727;
          color: #000;
          border: none;
          padding: 10px 20px;
          font-weight: bold;
          border-radius: 6px;
          cursor: pointer;
          font-size: 14px;
        }

        .write-form button:hover {
          background-color: #ffb400;
        }
      </style>
</head>
<body>
    <h2 style="text-align:center;">글쓰기</h2>

    <div class="write-container">
      <form action="/entrust/write" method="post" enctype="multipart/form-data" class="write-form">
        <label for="title">제목</label>
        <input type="text" name="title" id="title" placeholder="제목을 입력해주세요" required />
        <label for="title">작성자</label>
        <input type="text" name="nickname" id="nickname" placeholder="작성자를 입력해주세요" required />

        <label for="uploadFiles">파일 업로드</label>
        <input type="file" name="uploadFiles" id="uploadFiles" multiple />

        <label for="content">내용</label>
        <textarea name="content" id="content" rows="8" placeholder="내용을 입력해주세요" required></textarea>

        <div class="submit-btn-wrapper">
          <button type="submit">등록하기</button>
        </div>
      </form>
    </div>

    </form>
</body>
</html>