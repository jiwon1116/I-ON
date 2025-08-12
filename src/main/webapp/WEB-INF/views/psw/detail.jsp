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
     /* ===== Post Detail (layout only, no functional changes) ===== */
     .page-wrap {
       display:flex;
       justify-content:center;
       padding: 40px 16px 80px;
     }

     .post-card{
       width:100%;
       max-width: 880px;
       background:#fff;
       border-radius: 16px;
       box-shadow: 0 6px 20px rgba(0,0,0,.06);
       padding: 28px 28px 18px;
     }

     /* 제목 + 우측 액션 */
     .post-head{
       display:flex;
       align-items:flex-start;
       justify-content:space-between;
       gap:16px;
       margin-bottom: 12px;
     }

     .post-title{
       font-size: 28px;
       font-weight: 599;
       letter-spacing: -.3px;
       margin: 0;
       color:#222;
     }

     .post-actions{
       display:flex;
       gap:12px;
       font-size: 14px;
       color:#666;
     }
     .post-actions button{
       background:transparent;
       border:none;
       color:#666;
       cursor:pointer;
       padding: 6px 8px;
       border-radius:8px;
     }
     .post-actions button:hover{ background:#f2f2f2; }

     /* 메타 */
     .post-meta{
       display:flex;
       align-items:center;
       gap:18px;
       color:#8a8a8a;
       font-size: 14px;
       margin-bottom: 16px;
     }
     .post-meta .author{ font-weight:600; color:#444; }

     /* 본문 이미지 */
     .post-image{
       width:100%;
       border-radius:12px;
       overflow:hidden;
       margin: 10px 0 16px;
     }
     .post-image img{
          display: block;
          width: 50%;
          height: auto;
          object-fit: cover;
          margin: auto;
          border-radius: 10px;

     }

     /* 내용 박스 */
     .post-content{
       background:#f8f8f9;
       border:1px solid #eceff3;
       border-radius:12px;
       padding:18px 16px;
       color:#444;
       line-height:1.7;
     }
     .post-content textarea{
       width:100%;
       min-height:180px;
       border:none;
       background:transparent;
       resize:vertical;
       font-size:17px;
       color:#444;
       line-height:1.7;
       outline:none;
       white-space:pre-wrap;
     }

/* 크롬, 엣지, 사파리 */
::-webkit-scrollbar {
  width: 6px;              /* 세로 스크롤바 두께 */
  height: 6px;             /* 가로 스크롤바 두께 */
}

::-webkit-scrollbar-track {
  background: transparent; /* 트랙 배경 */
}

::-webkit-scrollbar-thumb {
  background-color: rgba(0, 0, 0, 0.3); /* 스크롤 핸들 색상 */
  border-radius: 3px;                   /* 둥글게 */
}

::-webkit-scrollbar-thumb:hover {
  background-color: rgba(0, 0, 0, 0.5); /* 호버 시 색 진하게 */
}

/* 파이어폭스 */
* {
  scrollbar-width: thin;                /* 얇게 */
  scrollbar-color: rgba(0, 0, 0, 0.3) transparent; /* 색상(핸들, 배경) */
}

     /* 좋아요/카운트 */
     .post-stats{
       display:flex;
       align-items:center;
       gap:16px;
       color:#666;
       margin: 16px 4px 6px;
       font-size:14px;
     }
     .btn.like-btn{
       display:inline-flex;
       align-items:center;
       gap:8px;
       padding:8px 12px;
       border-radius:10px;
       background:#fff;
       cursor:pointer;
     }
     .btn.like-btn .heart{ font-size:18px; line-height:1; }
     .btn.like-btn.liked .heart{ color:#f44336; }


     /* 댓글 */
     .comment-wrap{ margin-top: 18px; }
     .comment-list{ display:flex; flex-direction:column; gap:10px; margin: 8px 0 18px; }
     .comment-item{
       display:flex; gap:12px; padding:14px;
       background:#fafafa; border:1px solid #eef1f5; border-radius:12px;
       height: 90px;
     }

     .comment-item {
       display: flex;
       gap: 12px;
       padding: 14px;
       background: #fafafa;
       border: 1px solid #eef1f5;
       border-radius: 12px;
       height: 70%;
     }

     .comment-body { flex: 1; }

     /* 상단 한 줄을 좌우로 배치 */
     .comment-row {
       display: flex;
       align-items: center;
       justify-content: space-between;
       gap: 10px;
     }

     /* 우측 묶음: 날짜 + 삭제버튼 */
     .comment-meta {
       display: flex;
       align-items: center;
       gap: 12px;
     }

     .comment-date { color: #9aa1a9; font-size: 12px; }

     /* 삭제 버튼 */
     .btn-del {
       border: none;
       background: transparent;
       color: #666;
       padding: 6px 8px;
       border-radius: 8px;
       cursor: pointer;
     }
     .btn-del:hover {
       background: #f2f2f2;
       color: red;
     }

     .comment-avatar{ width:40px;height:40px;border-radius:50%; background:#ffe29a; flex:0 0 auto; }
     .comment-body{ flex:1; }
     .comment-row{ display:flex; align-items:center; justify-content:space-between; gap:10px; }
     .comment-date{ color:#9aa1a9; font-size:12px; }
     .comment-content{ margin-top:6px; color:#444; line-height:1.6; }

    .comment-writer span {
      font-weight:700; color:#333;
     }

     .comment-writer span:hover {
       color:  rgb(255, 199, 39);
     }

     /* 댓글 입력 */
     .comment-editor{
       display:flex; gap:10px; align-items:flex-end;
       padding:12px; border:1px solid #eceff3; border-radius:12px; background:#fffdf7;
     }
     .comment-editor input[type="text"]{
       flex:1; border:1px solid #e2e5ea; border-radius:10px;
       padding:12px 14px; font-size:14px; outline:none;
     }
     .comment-editor button{
       background:#f5a623; color:#fff; border:none;
       border-radius:10px; padding:12px 18px; font-weight:700; cursor:pointer;
     }
     .comment-editor button:hover{ background:#e9971b; }

     /* 하단 버튼 */
     .bottom-actions{ display:flex; justify-content:flex-end; gap:10px; margin-top: 10px; }
     .bottom-actions button{ border:none; border-radius:10px; padding:10px 16px; cursor:pointer; }
     .btn-secondary{ background:#fff; border:1px solid #e2e5ea; }
     .btn-primary{ background:#f5a623; color:#fff; }

     .bottom-actions button:hover
     { background: #f2f2f2;
             color: #666; }


     /* 반응형 */
     @media (max-width: 768px){
       .post-title{ font-size:22px; }
       .post-head{ flex-direction:column; align-items:flex-start; gap:8px; }
       .post-meta{ flex-wrap:wrap; gap:10px; }
       .comment-item{ padding:12px; }
       .comment-editor{ flex-direction:column; align-items:stretch; }
       .comment-editor button{ width:100%; }
     }
     @media (max-width: 480px){
       .post-card{ padding:22px 18px; }
     }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container">
   <div class="page-wrap">
     <div class="post-card">
       <!-- 기존 폼/네임/액션 그대로 -->
       <form action="/info/detail" method="post" name="infoupdateForm">
         <!-- 제목 + 관리자 액션 -->
         <div class="post-head">
           <h2 class="post-title">${findDto.title}</h2>
           <div class="post-actions">
             <security:authorize access="hasRole('ROLE_ADMIN')">
               <button type="button" onclick="updatefn()">수정</button>
               <button type="button" onclick="deletefn()">삭제</button>
             </security:authorize>
           </div>
         </div>

         <!-- 메타 -->
         <div class="post-meta">
           <c:if test="${not empty findDto.nickname}">
             <div class="author">
               ✍ <span class="js-user" data-nickname="${findDto.nickname}">${findDto.nickname}</span>
             </div>
           </c:if>
           <div>🕒 <fmt:formatDate value="${findDto.created_at}" pattern="yyyy-MM-dd HH:mm" /></div>
           <div>👁️ ${findDto.view_count}</div>
         </div>

         <!-- 본문 이미지 -->
         <c:if test="${not empty findFileDto}">
           <div class="post-image">
             <img src="/info/preview?storedFileName=${findFileDto.storedFileName}" alt="post image" />
           </div>
         </c:if>

         <!-- 본문 (textarea 그대로 사용, 읽기전용) -->
         <div class="post-content">
           <textarea name="content" readonly>${findDto.content}</textarea>
         </div>

         <!-- 좋아요/카운트 (id/class 유지) -->
         <div class="post-stats">
           <button type="button" class="btn like-btn ${findDto != null && findDto.liked ? 'liked' : ''}" id="likeBtn">
             <span class="heart">${findDto.liked ? '❤️' : '🤍'}</span>
             <span id="likeCount">${findDto.like_count}</span>
           </button>
           <span>좋아요: <span id="likeCountDisplay">${findDto != null ? findDto.like_count : 0}</span></span>
         </div>

         <input type="hidden" name="id" value="${findDto.id}" />
       </form>

            <!-- 댓글 입력 -->
                <div class="comment-editor">
                  <input type="text" id="commentContents" placeholder="댓글을 작성해주세요" />
                  <button type="button" onclick="commentWrite()">작성</button>
                </div>
              </section>


       <!-- 댓글 목록 -->
       <section class="comment-wrap">
         <div class="comment-list" id="comment-list">
           <c:forEach items="${commentList}" var="comment">
            <div class="comment-item">
              <div class="comment-avatar"></div>
              <div class="comment-body">
                <!-- 상단 행: 작성자 / (날짜 + 삭제버튼) -->
                <div class="comment-row">
                  <div class="comment-writer">
                    <span class="js-user" data-nickname="${comment.nickname}">
                      <a href="${pageContext.request.contextPath}/othermemberprofile/checkprofile?nickname=${comment.nickname}">
                        ${comment.nickname}
                      </a>
                    </span>
                  </div>

                  <div class="comment-meta">
                    <span class="comment-date">
                      <fmt:formatDate value="${comment.created_at}" pattern="yyyy-MM-dd HH:mm" />
                    </span>
                    <c:if test="${comment.nickname == member.nickname}">
                      <button type="button"
                              class="btn-del"
                              onclick="commentDelete('${comment.nickname}', ${comment.id})">삭제</button>
                    </c:if>
                  </div>
                </div>

                <div class="comment-content">${comment.content}</div>
                  </div>
                </div>

           </c:forEach>
         </div>



       <!-- 목록 버튼 (기존 함수 유지) -->
       <div class="bottom-actions">
         <button type="button" class="btn-secondary" onclick="infoForm()">목록</button>
       </div>
     </div>
   </div>

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
</script>
</body>
</html>