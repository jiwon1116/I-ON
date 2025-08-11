<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글 상세보기</title>
    <!-- 뱃지 사용 -->
    <meta name="ctx" content="${pageContext.request.contextPath}"/>

     <script src="https://code.jquery.com/jquery-latest.min.js"></script>

     <!-- 전역 배지 스크립트 -->
         <script src="${pageContext.request.contextPath}/resources/js/badge.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f6f8;
        }

        .container {
            display: flex;
            height: 100vh;
        }

        .sidebar {
            width: 240px;
            background-color: #ffb830;
            padding: 40px 20px;
            color: #333;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        }

        .sidebar img {
            width: 100px;
            margin-bottom: 50px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar li {
            margin: 20px 0;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s ease;
        }

        .sidebar li:hover {
            background-color: #ffe9a9;
            border-radius: 8px;
            padding: 6px 10px;
        }

        .content {
            flex: 1;
            padding: 60px 80px;
            overflow-y: auto;
        }

        .form-container {
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
        }

        .form-container h2 {
            font-size: 26px;
            margin-bottom: 25px;
            color: #333;
        }

        .form-group {
            margin: 20px 0;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #444;
        }

        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 14px;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 15px;
            background-color: #fdfdfd;
        }

        .form-group textarea {
            min-height: 200px;
            resize: vertical;
        }

        .meta-info {
            display: flex;
            gap: 40px;
            margin-top: 10px;
            margin-bottom: 30px;
            color: #888;
            font-size: 14px;
        }

        .form-actions {
            text-align: right;
            margin-top: 40px;
        }

        .form-actions button {
            padding: 10px 20px;
            margin-left: 10px;
            background-color: #f5a623;
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .form-actions button:hover {
            background-color: #e9971b;
        }

        .comment-section {
            margin-top: 60px;
        }

        .comment-section h3 {
            margin-bottom: 15px;
            font-size: 18px;
            font-weight: bold;
        }

         .comment-section textarea {
                    min-height: 90px;
                    resize: vertical;
                }

        .comment-box {
            margin-bottom: 20px;
            padding: 15px;
            background: #f9f9f9;
            border-radius: 10px;
        }

        .comment-writer {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .comment-date {
            color: #999;
            font-size: 13px;
            margin-top: 5px;
        }

        .like-btn .heart {
                    font-size: 1.4em;
                    vertical-align: middle;
                    transition: color 0.15s;
                }
                .like-btn.liked .heart {
                    color: #f44336;
                }
                .like-btn .heart {
                    color: #fff;
                    text-shadow: 0 0 2px #d1d1d1;
                }
                .like-btn {
                    border: 1.5px solid #f44336 !important;
                }

    </style>
</head>
<body>
<div class="container">
    <!-- 사이드바 -->
    <aside class="sidebar">
        <img src="#" alt="logo">
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
            <h2>글 상세보기</h2>
            <form action="/info/detail" method="post" name="infoupdateForm">
                <div class="form-group">
                    <label>제목</label>
                    <input type="text" name="title" value="${findDto.title}" readonly />
                </div>

                <div class="meta-info">
                    <div>🕒 작성일: <fmt:formatDate value="${findDto.created_at}" pattern="yyyy-MM-dd" /></div>
                    <div>👁️‍ 조회수: ${findDto.view_count}</div>
                    <c:if test="${not empty findDto.nickname}">
                        <div>✍ 작성자:
                            <!-- ✅ 배지 대상 -->
                            <span class="js-user" data-nickname="${findDto.nickname}">${findDto.nickname}</span>
                        </div>
                    </c:if>
                </div>

                <div class="form-group">
                    <!-- 게시물에 첨부된 사진 넣기(두 번째 이미지 출력) -->
                    <c:if test="${not empty findFileDto}">
                        <img src="/info/preview?storedFileName=${findFileDto.storedFileName}" style="width:300px; height:300px;" />
                    </c:if>
               </div>

                <div class="form-group">
                    <textarea name="content" readonly>${findDto.content}</textarea>
                </div>

                <input type="hidden" name="id" value="${findDto.id}" />

                <!-- 좋아요 버튼 (하트 토글) -->
                <div class="mb-2">
                    <button type="button" class="btn like-btn ${findDto != null && findDto.liked ? 'liked' : ''}" id="likeBtn">
                        <span class="heart">${findDto.liked ? '❤️' : '🤍'}</span>
                        <span id="likeCount">${findDto.like_count}</span>
                    </button>
                </div>
                좋아요: <span id="likeCountDisplay">${findDto != null ? findDto.like_count : 0}</span>

                <security:authorize access="hasRole('ROLE_ADMIN')">
                    <div class="form-actions">
                        <button type="button" onclick="updatefn()">수정</button>
                        <button type="button" onclick="deletefn()">삭제</button>
                    </div>
                </security:authorize>
                <div class="form-actions">
                    <button type="button" onclick="infoForm()">목록</button>
                </div>
            </form>

            <!-- 댓글 영역 -->
            <div class="comment-section">
                <h3>댓글</h3>

            <!-- 댓글 작성 폼 -->
              <input type = "text" id = "commentContents" placeholder = "내용"  />
               <div class="form-actions">
                 <button type="button" onclick="commentWrite()">댓글 작성</button>
               </div>

                <!-- 댓글 목록 -->
                <div id="comment-list">
                    <c:forEach items="${commentList}" var="comment">
                        <div class="comment-box">
                            <div class="comment-writer">
                                <!-- ✅ 배지 대상 -->
                                <span class="js-user" data-nickname="${comment.nickname}"><a href="${pageContext.request.contextPath}/othermemberprofile/checkprofile?nickname=${comment.nickname}">${comment.nickname}</a></span>
                            </div>
                            <div>${comment.content}</div>
                            <div class="comment-date">
                                <fmt:formatDate value="${comment.created_at}" pattern="yyyy-MM-dd HH:mm" />
                            </div>
                            <div>
                                <c:if test="${comment.nickname == member.nickname}">
                                    <button type="button" onclick="commentDelete('${comment.nickname}', ${comment.id})">삭제</button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
    </main>
</div>

<script>
    const updatefn = () => { document.infoupdateForm.submit(); }
    const infoForm  = () => { location.href = "/info"; }

    // 좋아요 버튼
    $('#likeBtn').click(function(e){
        e.preventDefault();
        const findId = '${findDto.id}';
        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/infoLike/like/' + findId,
            success: function(data){
                if(data.error){ alert(data.error); return; }
                $('#likeCount').text(data.likeCount);
                $('#likeCountDisplay').text(data.likeCount);
                if(data.liked){
                    $('#likeBtn').addClass('liked');
                    $('#likeBtn .heart').text('❤️');
                } else {
                    $('#likeBtn').removeClass('liked');
                    $('#likeBtn .heart').text('🤍');
                }
            },
            error: function(){ alert('좋아요 처리 실패!'); }
        });
    });

    // 삭제 버튼
    const deletefn = () => {
        const id = "${findDto.id}";

        const confirmed = confirm("정말 삭제하시겠습니까?");
           if (confirmed) {
                  location.href = "/info/delete?id=" + id;
                  }
      }

      const commentWrite = () => {
              // 게시물 작성자 닉네임이 없으면 관리자임
             const rawNickname = "${member.nickname}";
             const nickname = (rawNickname && rawNickname !== "null" && rawNickname !== "") ? rawNickname : "admin";

              const content = document.getElementById("commentContents").value.trim();
              const post_id = "${findDto.id}";

              if (!nickname || !content) {
                      alert("내용을 입력해주세요.");
                      return;
               }
              $.ajax({
                  type: "post",
                  url: "/infocomment/save",
                  data: {
                      nickname : nickname,
                      content : content,
                      post_id : post_id
                  },
                  dataType : "json",
                  success : function(commentList) {
                  alert("댓글 작성이 완료되었습니다🙂");
                  location.reload(); // 페이지 전체 새로고침 (위 리스트에 새로운 댓글 반영)
                  },
                  error : function() {
                      console.log("실패");
                  }
              });
          }

         // JS 함수는 인자로 받아야 정확하게 타겟팅 가능
         const commentDelete = (nickname, commentId) => {
             const confirmed = confirm("정말 삭제하시겠습니까?");
             if (!confirmed) return;

             alert("댓글이 삭제되었습니다🙂");
             $.ajax({
                 type: "post",
                 url: "/infocomment/delete",
                 data: {
                     nickname: nickname,
                     id: commentId
                 },
                 dataType: "json",
                 success: function (commentList) {
                    console.log("댓글 삭제 성공");
                    location.reload();
                 },
                 error: function () {
                     console.log("댓글 삭제 실패");
                 }
             });
         };


    // 댓글 삭제
    const commentDelete = (nickname, commentId) => {
        if (!confirm("정말 삭제하시겠습니까?")) return;
        $.ajax({
            type: "post",
            url: "/infocomment/delete",
            data: { nickname: nickname, id: commentId },
            dataType: "json",
            success: function () { location.reload(); },
            error: function () { console.log("댓글 삭제 실패"); }
        });
    };
</script>
</body>
</html>