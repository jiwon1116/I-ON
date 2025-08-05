<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>정보 공유 글쓰기</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f9f9f9;
        }

        .container {
            display: flex;
            height: 100vh;
        }

        .sidebar {
            width: 220px;
            background-color: #f4a300;
            padding: 30px 20px;
            color: #fff;
        }

        .sidebar .logo {
            margin-bottom: 40px;
            font-weight: bold;
            font-size: 20px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar li {
            margin: 25px 0;
            font-size: 16px;
            cursor: pointer;
            display: flex;
            align-items: center;
        }

        .sidebar li:hover {
            text-decoration: underline;
        }

        .content {
            flex: 1;
            padding: 50px;
            overflow-y: auto;
        }

        .form-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            max-width: 700px;
            margin: 0 auto;
        }

        .form-container h2 {
            margin-bottom: 30px;
            font-size: 24px;
            color: #333;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            font-size: 15px;
            color: #444;
        }

        .form-group input[type="text"],
        .form-group textarea,
        .form-group input[type="file"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-group textarea {
            min-height: 150px;
            resize: vertical;
        }

        .form-actions {
            text-align: right;
        }

        .form-actions button {
            background-color: #f4a300;
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
        }

        .form-actions button:hover {
            background-color: #db9000;
        }

    </style>
</head>
<body>
<div class="container">
    <!-- 사이드바 -->
    <aside class="sidebar">
        <div class="logo">logo</div>
        <ul>
           <li>📌 마이페이지</li>
           <li>🗺️ 범죄 예방 지도</li>
           <li>💬 커뮤니티</li>
           <li>🚨 제보 및 신고</li>
           <li>📚 정보 공유</li>
        </ul>
    </aside>

    <!-- 메인 콘텐츠 -->
    <main class="content">
        <div class="form-container">
            <h2>글쓰기</h2>
             <!-- 파일 업로드를 위한 설정 multipart/form-data -->
            <form action="${pageContext.request.contextPath}/info/save" method="post"  enctype="multipart/form-data">
                <div class="form-group">
                    <label for="title">제목</label>
                    <input type="text" id="title" name="title" placeholder="제목을 입력해주세요" required />
                </div>

                <div class="form-group">
              <label for="file" class="form-label">썸네일 이미지(필수)</label>
              <input type="file" class="form-control" id="file" name="file" multiple required >
                </div>

              <div class="form-group">
                 <label for="file" class="form-label">게시물 이미지</label>
                 <input type="file" class="form-control" id="file" name="file" multiple required >
              </div>

                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" placeholder="내용을 입력해주세요" required></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit">등록하기</button>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>
