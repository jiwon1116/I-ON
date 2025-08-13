<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>글 상세보기</title>
  <meta name="ctx" content="${pageContext.request.contextPath}"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

  <script src="https://code.jquery.com/jquery-latest.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/badge.js"></script>

  <style>
  .info-page-wrap{
    display:flex; justify-content:center;
    padding:40px 16px 80px;
  }

  .info-card{
    width:100%; max-width:880px;
    background:#fff; border-radius:16px;
    box-shadow:0 6px 20px rgba(0,0,0,.06);
    padding:28px 28px 18px;
  }

  .info-head{
    display:flex; align-items:flex-start; justify-content:space-between;
    gap:16px; margin-bottom:12px;
  }
  .info-title{
    font-size:28px; font-weight:700; letter-spacing:-.3px;
    margin:0; color:#222;
  }
  .info-actions{ display:flex; gap:12px; font-size:14px; color:#666; }
  .info-actions button{
    background:transparent; border:none; color:#666; cursor:pointer;
    padding:6px 8px; border-radius:8px;
  }
  .info-actions button:hover{ background:#f2f2f2; }

  .info-meta{
    display:flex; align-items:center; gap:18px;
    color:#8a8a8a; font-size:14px; margin-bottom:16px;
  }
  .info-meta .info-author{ font-weight:600; color:#444; }

  .info-image{ width:100%; border-radius:12px; overflow:hidden; margin:10px 0 16px; }
  .info-image img{
    display:block; width:50%; height:auto; object-fit:cover; margin:auto; border-radius:10px;
  }

  .info-content{
    background:#f8f8f9; border:1px solid #eceff3; border-radius:12px;
    padding:18px 16px; color:#444; line-height:1.7;
  }
  .info-content textarea{
    width:100%; min-height:180px; border:none; background:transparent;
    resize:vertical; font-size:17px; color:#444; line-height:1.7;
    outline:none; white-space:pre-wrap;
  }

  ::-webkit-scrollbar{ width:6px; height:6px; }
  ::-webkit-scrollbar-track{ background:transparent; }
  ::-webkit-scrollbar-thumb{ background-color:rgba(0,0,0,.3); border-radius:3px; }
  ::-webkit-scrollbar-thumb:hover{ background-color:rgba(0,0,0,.5); }
  *{ scrollbar-width:thin; scrollbar-color:rgba(0,0,0,.3) transparent; }

  .info-stats{ display:flex; align-items:center; gap:16px; color:#666; margin:16px 4px 6px; font-size:14px; }
  .info-like-btn{
    display:inline-flex; align-items:center; gap:8px;
    padding:8px 12px; border-radius:10px; background:#fff; cursor:pointer; border-style: none;
  }
  .info-like-btn .heart{ font-size:18px; line-height:1; }
  .info-like-btn.liked .heart{ color:#f44336; }

  .info-comment-wrap{ margin-top:18px; }
  .info-comment-list{ display:flex; flex-direction:column; gap:10px; margin:8px 0 18px; }
  .info-comment-item{
    display:flex; gap:12px; padding:14px;
    background:#fafafa; border:1px solid #eef1f5; border-radius:12px;
  }
  .info-comment-avatar{ width:40px; height:40px; border-radius:50%; background:#ffe29a; flex:0 0 auto; }
  .info-comment-body{ flex:1; }
  .info-comment-row{ display:flex; align-items:center; justify-content:space-between; gap:10px; }
  .info-comment-meta{ display:flex; align-items:center; gap:12px; }
  .info-comment-date{ color:#9aa1a9; font-size:12px; }
  .info-comment-content{ margin-top:6px; color:#444; line-height:1.6; }
  .info-comment-writer span{ font-weight:700; color:#333; }
  .info-comment-writer span:hover{ color:rgb(255,199,39); }

  .info-btn-del{
    border:none; background:transparent; color:#666; padding:6px 8px;
    border-radius:8px; cursor:pointer;
  }
  .info-btn-del:hover{ background:#f2f2f2; color:red; }

  .info-comment-editor{
    display:flex; gap:10px; align-items:flex-end;
    padding:12px; border:1px solid #eceff3; border-radius:12px; background:#fffdf7;
  }
  .info-comment-editor input[type="text"]{
    flex:1; border:1px solid #e2e5ea; border-radius:10px;
    padding:12px 14px; font-size:14px; outline:none;
  }
  .info-comment-editor button{
    background:#f5a623; color:#fff; border:none;
    border-radius:10px; padding:12px 18px; font-weight:700; cursor:pointer;
  }
  .info-comment-editor button:hover{ background:#e9971b; }

  .info-bottom-actions{ display:flex; justify-content:flex-end; gap:10px; margin-top:10px; }
  .info-btn-secondary{ background:#fff; border:1px solid #e2e5ea; border-radius:10px; padding:10px 16px; cursor:pointer; }
  .info-btn-primary{ background:#f5a623; color:#fff; border:none; border-radius:10px; padding:10px 16px; cursor:pointer; }
  .info-bottom-actions button:hover{ background:#f2f2f2; color:#666; }

  @media (max-width:768px){
    .info-title{ font-size:22px; }
    .info-head{ flex-direction:column; align-items:flex-start; gap:8px; }
    .info-meta{ flex-wrap:wrap; gap:10px; }
    .info-comment-item{ padding:12px; }
    .info-comment-editor{ flex-direction:column; align-items:stretch; }
    .info-comment-editor button{ width:100%; }
  }
  @media (max-width:480px){ .info-card{ padding:22px 18px; } }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container">
  <div class="info-page-wrap">
    <div class="info-card">
      <form action="/info/detail" method="post" name="infoupdateForm">
        <div class="info-head">
          <h2 class="info-title">${findDto.title}</h2>
          <div class="info-actions">
            <security:authorize access="hasRole('ROLE_ADMIN')">
              <button type="button" onclick="updatefn()">수정</button>
              <button type="button" onclick="deletefn()">삭제</button>
            </security:authorize>
          </div>
        </div>

        <div class="info-meta">
          <c:if test="${not empty findDto.nickname}">
            <div class="info-author">
              <span class="js-user" data-nickname="${findDto.nickname}">${findDto.nickname}</span>
            </div>
          </c:if>

          <div>
            <i class="bi bi-clock"></i>
            <fmt:formatDate value="${findDto.created_at}" pattern="yyyy-MM-dd HH:mm" />
          </div>

          <div>
            <i class="bi bi-eye"></i>
            <span id="viewCount">${findDto.view_count}</span>
          </div>
        </div>


        <c:if test="${not empty findFileDto}">
          <div class="info-image">
            <img src="/info/preview?storedFileName=${findFileDto.storedFileName}" alt="post image" />
          </div>
        </c:if>

        <div class="info-content">
          <textarea name="content" readonly>${findDto.content}</textarea>
        </div>

        <div class="info-stats">
          <button type="button" class="info-like-btn ${findDto != null && findDto.liked ? 'liked' : ''}" id="likeBtn">
            <span class="heart">${findDto.liked ? '❤️' : '🤍'}</span>
            <span id="likeCount">${findDto.like_count}</span>
          </button>
          <span>좋아요: <span id="likeCountDisplay">${findDto != null ? findDto.like_count : 0}</span></span>
        </div>

        <input type="hidden" name="id" value="${findDto.id}" />
      </form>

      <div class="info-comment-editor">
        <input type="text" id="commentContents" placeholder="댓글을 작성해주세요" />
        <button type="button" onclick="commentWrite()">작성</button>
      </div>

      <section class="info-comment-wrap">
        <div class="info-comment-list" id="comment-list">
          <c:forEach items="${commentList}" var="comment">
            <div class="info-comment-item">
              <div class="info-comment-avatar"></div>
              <div class="info-comment-body">
                <div class="info-comment-row">
                  <div class="info-comment-writer">
                    <span class="js-user" data-nickname="${comment.nickname}">
                      <a href="${pageContext.request.contextPath}/othermemberprofile/checkprofile?nickname=${comment.nickname}">
                        ${comment.nickname}
                      </a>
                    </span>
                  </div>

                  <div class="info-comment-meta">
                    <span class="info-comment-date">
                      <fmt:formatDate value="${comment.created_at}" pattern="yyyy-MM-dd HH:mm" />
                    </span>
                    <c:if test="${comment.nickname == member.nickname}">
                      <button type="button" class="info-btn-del"
                              onclick="commentDelete('${comment.nickname}', ${comment.id})">삭제</button>
                    </c:if>
                  </div>
                </div>

                <div class="info-comment-content">${comment.content}</div>
              </div>
            </div>
          </c:forEach>
        </div>
      </section>

      <div class="info-bottom-actions">
        <button type="button" class="info-btn-secondary" onclick="infoForm()">목록</button>
      </div>
    </div>
  </div>
</div>

<script>
  const updatefn = () => { document.infoupdateForm.submit(); }
  const infoForm  = () => { location.href = "/info"; }

  $('#likeBtn').click(function(e){
    e.preventDefault();
    const findId = '${findDto.id}';
    $.ajax({
      type:'POST',
      url:'${pageContext.request.contextPath}/infoLike/like/' + findId,
      success:function(data){
        if(data.error){ alert(data.error); return; }
        $('#likeCount').text(data.likeCount);
        $('#likeCountDisplay').text(data.likeCount);
        if(data.liked){
          $('#likeBtn').addClass('liked');
          $('#likeBtn .heart').text('❤️');
        }else{
          $('#likeBtn').removeClass('liked');
          $('#likeBtn .heart').text('🤍');
        }
      },
      error:function(){ alert('좋아요 처리 실패!'); }
    });
  });

  const deletefn = () => {
    const id = "${findDto.id}";
    const confirmed = confirm("정말 삭제하시겠습니까?");
    if (confirmed) { location.href = "/info/delete?id=" + id; }
  }

  const commentWrite = () => {
    const rawNickname = "${member.nickname}";
    const nickname = (rawNickname && rawNickname !== "null" && rawNickname !== "") ? rawNickname : "admin";
    const content = document.getElementById("commentContents").value.trim();
    const post_id = "${findDto.id}";

    if (!nickname || !content) { alert("내용을 입력해주세요."); return; }

    $.ajax({
      type:"post",
      url:"/infocomment/save",
      data:{ nickname, content, post_id },
      dataType:"json",
      success:function(){ alert("댓글 작성이 완료되었습니다🙂"); location.reload(); },
      error:function(){ console.log("실패"); }
    });
  }

  const commentDelete = (nickname, commentId) => {
    const confirmed = confirm("정말 삭제하시겠습니까?");
    if (!confirmed) return;

    alert("댓글이 삭제되었습니다🙂");
    $.ajax({
      type:"post",
      url:"/infocomment/delete",
      data:{ nickname, id: commentId },
      dataType:"json",
      success:function(){ console.log("댓글 삭제 성공"); location.reload(); },
      error:function(){ console.log("댓글 삭제 실패"); }
    });
  };
</script>
</body>
</html>
