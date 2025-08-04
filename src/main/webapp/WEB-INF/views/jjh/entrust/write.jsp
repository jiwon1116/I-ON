<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>🎈위탁 게시판</title>
      <style>
        body {
          margin: 0;
          font-family: "Noto Sans KR", sans-serif;
          background-color: #fff8e7;
        }

        /* 상단바 스타일 */
        /* 네비게이션 바 */
        /* 네비게이션 바 */
        .top-nav {
          background-color: #ffc727;
          padding: 0 24px;
          display: flex;
          align-items: flex-end;
          justify-content: space-between;
          height: 60px;
          font-weight: bold;
          font-size: 14px;
          position: relative;
          z-index: 10;
        }

        .logo-section img {
          height: 36px;
        }

        .nav-tabs {
          display: flex;
          list-style: none;
          margin: 0;
          padding: 0;
        }

        /* 메인 메뉴 공통 */
        .main-menu {
          position: relative;
          padding: 12px 24px;
          border-top-left-radius: 20px;
          border-top-right-radius: 20px;
          cursor: pointer;
          background-color: transparent;
          color: #fff;
          display: flex;
          align-items: center;
          justify-content: center;
          transition: color 0.2s ease;
        }

        /* ✅ hover 시 텍스트 색상만 밝아짐 */
        .main-menu:hover {
          color: #ffffffcc; /* 연한 흰색 */
        }

        /* ✅ 활성 탭 (흰색 배경 & 검정 텍스트) */
        .main-menu.active {
          background-color: white;
          color: #222;
          z-index: 2;
          margin-bottom: 0; /* ❗ 빠져나오지 않도록 */
        }

        /* ✅ 서브 메뉴 */
        .sub-menu {
          display: none;
          position: absolute;
          top: 100%;
          left: 0;
          width: 100%; /* ✅ 메인 메뉴와 너비 일치 */
          box-sizing: border-box;
          background: #ffc727;
          list-style: none;
          padding: 8px 0;
          margin: 0;
          box-shadow: 0 6px 20px rgba(0,0,0,0.12);
          border-radius: 0 0 12px 12px;
          z-index: 5;
        }

        /* hover 시 서브 메뉴 보임 */
        .main-menu:hover .sub-menu {
          display: block;
        }

        /* 서브 메뉴 항목 */
        .sub-menu li {
          padding: 10px 16px;
          white-space: nowrap;
          font-size: 14px;
          color: #333;
          transition: color 0.2s;
          font-weight: 500;
          text-align: center;
        }

        /* ✅ hover 시 텍스트 색상만 진해짐 */
        .sub-menu li:hover {
          color: #000;
        }

        /* 오른쪽 아이콘 */
        .icons {
          display: flex;
          gap: 16px;
          font-size: 20px;
          padding-bottom: 10px;
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
    <!-- ✅ 상단바 시작 -->
    <header>
      <nav class="top-nav">
        <div class="logo-section">
          <img src="/logo.png" alt="logo">
        </div>
        <ul class="nav-tabs">
          <li class="main-menu">
            마이페이지
          </li>
          <li class="main-menu">
            범죄 예방 지도
          </li>
          <li class="main-menu active">
            커뮤니티
            <ul class="sub-menu">
              <li>자유</li>
              <li>위탁</li>
              <li>실종 및 유괴</li>
            </ul>
          </li>
          <li class="main-menu">
            제보 및 신고
          </li>
          <li class="main-menu">
            정보 공유
          </li>
        </ul>
        <div class="icons">
          <span class="icon">🔔</span>
          <span class="icon">✉️</span>
        </div>
      </nav>
    </header>

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