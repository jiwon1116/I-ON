<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="CTX" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>신고 접수 목록</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>

  <style>
    :root{
      --brand:#F2AC28; --bg:#F7F7F7; --text:#222; --muted:#808080;
      --card:#fff; --line:#e9e9e9; --shadow:0 10px 24px rgba(0,0,0,.06);
      --radius:16px;
    }
    *{box-sizing:border-box}
    body{
      margin:0; background:var(--bg); color:var(--text);
      font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Helvetica,Arial,sans-serif;
    }
    .wrap{min-height:100vh; padding:44px 16px; display:flex; justify-content:flex-start}
    .container-n{width:100%; max-width:1100px; margin:0 auto}
    .page-head{display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:14px}
    .page-title{margin:0; font-weight:800; font-size:22px}
    .sub{color:var(--muted); font-size:14px; margin:4px 0 0}
    .card-n{background:var(--card); border-radius:var(--radius); box-shadow:var(--shadow); padding:18px}
    .table-wrap{overflow-x:auto}
    table{width:100%; border-collapse:separate; border-spacing:0; min-width:760px}
    thead th{ text-align:left; font-size:13px; color:#666; font-weight:700;
      padding:12px 14px; border-bottom:1px solid var(--line); background:#fafafa; }
    tbody td{padding:14px; border-bottom:1px solid var(--line); vertical-align:middle; font-size:14px}
    tbody tr:hover{background:#fcfcfc}
    .btn-brand{
      display:inline-flex; align-items:center; justify-content:center;
      height:36px; padding:0 12px; border:none; border-radius:10px; cursor:pointer; text-decoration:none;
      font-weight:700; font-size:13px; background:var(--brand); color:#111;
      box-shadow:0 8px 16px rgba(242,172,40,.25);
    }
    .btn-brand:active{transform:translateY(1px)}
    .btn-outline{background:#fff; color:#111; border:1px solid var(--line); box-shadow:none}
    .notice{ background:#fff; border:1px solid var(--line); border-radius:12px; padding:12px 14px; box-shadow:var(--shadow); }
  </style>
</head>
<body>
<div class="wrap">
  <div class="container-n">

    <div class="page-head">
      <div>
        <h3 class="page-title">신고 접수된 목록</h3>
        <p class="sub">사용자 신고 내역을 확인하고 승인/반려할 수 있습니다.</p>
      </div>
      <a href="javascript:void(0)"
         class="btn-brand btn-outline"
         onclick="if(document.referrer){history.back();}else{location.href='${CTX}/';}">
        ← 뒤로가기
      </a>
    </div>

    <c:if test="${not empty editSuccess}">
      <div class="notice mb-3">${editSuccess}</div>
    </c:if>

    <div class="card-n table-wrap">
      <table>
        <thead>
        <tr>
          <th style="width:140px">신고자 ID</th>
          <th style="width:220px">게시판/글번호</th>
          <th>신고 내용</th>
          <th style="width:100px; text-align:center;">승인</th>
          <th style="width:100px; text-align:center;">반려</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="report" items="${reportList}">
          <tr>
            <td>${report.reporterId}</td>
            <td>
              ${report.targetBoard} /
              <c:url value='/${fn:toLowerCase(report.targetBoard)}/${report.targetContentId}' var="detailUrl"/>
              <a href="${CTX}${detailUrl}">${report.targetContentId}</a>
            </td>
            <td><c:out value="${report.description}"/></td>
            <td style="text-align:center;">
              <form method="post" action="${CTX}/report/${report.id}/approve" style="display:inline;">
                <button type="submit" class="btn-brand">승인</button>
              </form>
            </td>
            <td style="text-align:center;">
              <form method="post" action="${CTX}/report/${report.id}/reject" style="display:inline;">
                <button type="submit" class="btn-brand btn-outline">반려</button>
              </form>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <c:if test="${empty reportList}">
        <div class="py-4 text-muted">접수된 신고가 없습니다.</div>
      </c:if>
    </div>

  </div>
</div>
</body>
</html>
