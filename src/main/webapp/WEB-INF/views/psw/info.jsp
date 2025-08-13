<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아동 범죄 예방 콘텐츠</title>
    <style>
        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #fdfdfd;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 24px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .top-bar button{
             border: none;
             background-color: #fdfdfd;
             font-size: 20px;
        }

        .top-bar form{
           margin-left: 70px;
        }


        .search-input {
            width: 300px;
            padding: 10px 16px;
            border: 1px solid #ccc;
            border-radius: 24px;
            font-size: 14px;
            outline: none;
        }

        .search-input:focus {
            border-color: #ffb800;
            box-shadow: 0 0 6px #ffb800aa;
        }

        .filter-buttons button {
            background-color: #ffb800;
            color: white;
            font-weight: bold;
            border: none;
            padding: 10px 20px;
            border-radius: 30px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .filter-buttons button:hover {
            background-color: #ffaa00;
        }

        .cards-wrap {
          max-width: 1200px;
          margin: 24px auto;
          padding: 0 16px;
        }

       .card-grid {
         display: grid;
         grid-template-columns: repeat(3, minmax(0, 1fr));
         gap: 24px;
         align-items: start;
       }

       .card {
         display: flex;
         flex-direction: column;
         height: 360px;
         background: #fff;
         border-radius: 12px;
         box-shadow: 0 6px 18px rgba(0,0,0,0.06);
         overflow: hidden;
         cursor: pointer;
         transition: transform .15s ease, box-shadow .15s ease;
       }
       .card:hover { transform: translateY(-2px); box-shadow: 0 10px 24px rgba(0,0,0,0.10); }

       .card-thumb {
         width: 100%;
         aspect-ratio: 1 / 1;
         overflow: hidden;
         background: #f6f6f6;
       }
       .card-thumb img {
         width: 100%;
         height: 100%;
         object-fit: cover;
         display: block;
       }

       .card-body {
         padding: 12px 14px 16px;
         display: flex;
         align-items: flex-start;
       }

       .card-body .title {
         font-size: 16px;
         font-weight: 600;
         color: #222;
         line-height: 1.4;
         display: -webkit-box;
         -webkit-line-clamp: 2;
         -webkit-box-orient: vertical;
         overflow: hidden;
         min-height: calc(1.4em * 2);
         margin: auto;
       }

      @media (max-width: 1400px) {
        .card-grid { grid-template-columns: repeat(3, 1fr); }
      }

      @media (max-width: 1200px) {
        .card-grid { grid-template-columns: repeat(2, 1fr); }
      }

      @media (max-width: 900px) {
        .card-grid { grid-template-columns: 2fr 2fr; }
        .card { height: auto; }
      }

      @media (max-width: 768px) {
        .card-grid { grid-template-columns: 1fr 1fr; }
        .card { height: auto; }
      }
      @media (max-width: 500px) {
        .card-grid { grid-template-columns: 1fr; }
        .card { height: auto; }
      }

      @media (max-width: 900px) and (min-height: 900px) {
        .container {
          margin-bottom: 50px;
        }
        .cards-wrap {
          margin-bottom: 10px;
        }
      }

      @media (max-width: 768px) {
        .element {
          margin-bottom: 10px;
        }
      }



        nav[aria-label="Page navigation"] {
            margin-top: 50px;
            text-align: center;
        }

        ul.pagination {
            list-style: none;
            padding: 0;
            display: inline-flex;
            gap: 8px;
        }

        .page-item a.page-link {
            display: block;
            padding: 10px 14px;
            text-decoration: none;
            border: 1px solid #ddd;
            border-radius: 8px;
            color: #333;
            font-weight: bold;
            transition: all 0.2s;
        }

        .page-item.active a.page-link,
        .page-item a.page-link:hover {
            background-color: #ffb800;
            color: white;
            border-color: #ffb800;
        }

        .page-item.disabled a.page-link {
            color: #bbb;
            cursor: not-allowed;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container">
    <div class="top-bar">
      <form method="get" action="${pageContext.request.contextPath}/info/search">
          <input type="search" class="search-input" name="keyword"
                 value="${param.keyword}" placeholder="검색어를 입력하세요..." />
          <button type="submit">🔍</button>
      </form>

        <security:authorize access="hasRole('ROLE_ADMIN')">
         <div class="filter-buttons">
            <button type="button" onclick="writeFn()">글 작성하기</button>
        </div>
         </security:authorize>
    </div>

  <div class="cards-wrap">
    <div class="card-grid">
      <c:forEach var="entry" items="${postMap}">
        <c:set var="content" value="${entry.key}" />
        <c:set var="file" value="${entry.value}" />

        <div class="card" onclick="location.href='${pageContext.request.contextPath}/info/${content.id}'">
          <div class="card-thumb">
            <img src="${pageContext.request.contextPath}/info/preview?storedFileName=${file.storedFileName}" alt="${content.title}" />
          </div>
          <div class="card-body">
            <div class="title">${content.title}</div>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>


  <nav aria-label="Page navigation">
    <ul class="pagination">
      <c:choose>
        <c:when test="${paging.page <= 1}">
          <li class="page-item disabled"><a class="page-link">← Previous</a></li>
        </c:when>
        <c:otherwise>
          <li class="page-item">
            <a class="page-link"
               href="${pageContext.request.contextPath}/info/paging?page=${paging.page - 1}">← Previous</a>
          </li>
        </c:otherwise>
      </c:choose>

      <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
        <c:choose>
          <c:when test="${i eq paging.page}">
            <li class="page-item active"><a class="page-link">${i}</a></li>
          </c:when>
          <c:otherwise>
            <li class="page-item">
              <a class="page-link"
                 href="${pageContext.request.contextPath}/info/paging?page=${i}">${i}</a>
            </li>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <c:choose>
        <c:when test="${paging.page >= paging.maxPage}">
          <li class="page-item disabled"><a class="page-link">Next →</a></li>
        </c:when>
        <c:otherwise>
          <li class="page-item">
            <a class="page-link"
               href="${pageContext.request.contextPath}/info/paging?page=${paging.page + 1}">Next →</a>
          </li>
        </c:otherwise>
      </c:choose>
    </ul>
  </nav>

</div>

   <script>
     function writeFn(){ location.href="/info/save"; }
   </script>

</body>
</html>
