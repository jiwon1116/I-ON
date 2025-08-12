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

/* 반응형 */
@media (max-width: 1024px) {
    .form-container {
        padding: 30px;
    }
}

@media (max-width: 768px) {
    .container {
        padding: 20px;
    }
    .form-container {
        padding: 20px;
        margin: 0 10px;
    }
    .form-group input[type="text"],
    .form-group textarea,
    .form-group input[type="file"] {
        font-size: 13px;
        padding: 10px;
    }
    .form-actions {
        flex-direction: column;
        gap: 10px;
    }
    .form-actions button {
        width: 100%;
    }
}

@media (max-width: 480px) {
    .form-container {
        padding: 16px;
    }
    .form-title {
        font-size: 20px;
    }
    .form-group label {
        font-size: 14px;
    }
    .form-group textarea {
        min-height: 120px;
    }
}
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="container">

    <!-- 메인 콘텐츠 -->
    <main class="content">
        <div class="form-container">
            <h2>글쓰기</h2>
             <!-- 파일 업로드를 위한 설정 multipart/form-data -->
            <form id="writeForm" action="${pageContext.request.contextPath}/info/save" method="post"  enctype="multipart/form-data">
                <div class="form-group">
                    <label for="title">제목</label>
                    <input type="text" id="title" name="title" placeholder="제목을 입력해주세요" required />
                </div>

                <div class="form-group">
              <label for="file" class="form-label">썸네일 이미지(필수)</label>
              <input type="file" class="form-control" id="file" name="file" required >
                </div>

              <div class="form-group">

                 <label for="file" class="form-label">게시물 이미지(필수)</label>
                 <input type="file" class="form-control" id="file" name="file" required>

              </div>

                <div class="form-group">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" placeholder="내용을 입력해주세요"></textarea>
                </div>

                <div class="form-actions">
                <button type="button" onClick="goBack()">뒤로가기</button>
                <button type="button" onClick="writeFinish()">등록하기</button>
                </div>
            </form>
        </div>
    </main>
</div>
<script>
function writeFinish() {
    // form 안의 필수 입력 요소들 찾기 (required 속성 기준)
    const form = document.getElementById("writeForm");
    const requiredFields = form.querySelectorAll("input[required], textarea[required]");

    for (let field of requiredFields) {
        if (!field.value.trim()) { // 공백만 입력된 경우도 막기
            alert("모든 항목을 작성해주세요!");
            field.focus();
            return; // 함수 종료
        }
    }

    // 모든 값이 채워져 있으면 알림 후 전송
    alert("글 작성이 완료되었습니다🙂");
    form.submit();
}


function goBack(){
    window.history.back();
}
</script>

</body>
</html>
