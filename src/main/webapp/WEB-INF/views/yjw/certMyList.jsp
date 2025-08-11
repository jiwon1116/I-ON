<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>내 자녀 등록 내역</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <style>
    :root{
      --brand:#F2AC28; --bg:#F7F7F7; --text:#222; --muted:#808080;
      --card:#fff; --line:#e9e9e9; --shadow:0 10px 24px rgba(0,0,0,.06);
      --radius:16px;
      --ok:#16a34a; --bad:#dc2626; --wait:#6b7280;
    }
    *{box-sizing:border-box}
    body{
      margin:0; background:var(--bg); color:var(--text);
      font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Helvetica,Arial,sans-serif;
    }
    .wrap{min-height:100vh; padding:44px 16px; display:flex; justify-content:flex-start}
    .container{width:100%; max-width:1000px; margin:0 auto}

    /* 헤더 */
    .page-head{
      display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:16px;
    }
    .page-title{margin:0; font-weight:800; font-size:22px}
    .sub{color:var(--muted); font-size:14px; margin:4px 0 0}

    /* 버튼 */
    .btn{
      display:inline-flex; align-items:center; justify-content:center; gap:8px;
      height:44px; padding:0 16px; border:none; border-radius:12px; cursor:pointer;
      font-weight:700; font-size:14px; text-decoration:none;
      transition:transform .05s ease;
      box-shadow:0 8px 16px rgba(242,172,40,.25);
      background:var(--brand); color:#111;
    }
    .btn:active{transform:translateY(1px)}
    .btn.outline{
      background:#fff; color:#111; border:1px solid var(--line); box-shadow:none;
    }

    /* 카드 & 테이블 */
    .card{
      background:var(--card); border-radius:var(--radius); box-shadow:var(--shadow);
      padding:20px; overflow:hidden;
    }
    .table-wrap{overflow-x:auto}
    table{
      width:100%; border-collapse:separate; border-spacing:0; min-width:720px;
    }
    thead th{
      text-align:left; font-size:13px; color:#666; font-weight:700;
      padding:12px 14px; border-bottom:1px solid var(--line);
      background:#fafafa;
    }
    tbody td{
      padding:14px; border-bottom:1px solid var(--line); vertical-align:middle;
      font-size:14px;
    }
    tbody tr:hover{background:#fcfcfc}

    /* 상태칩 */
    .chip{
      display:inline-flex; align-items:center; gap:6px;
      padding:6px 10px; border-radius:999px; font-weight:700; font-size:12px;
      border:1px solid;
    }
    .chip.ok{ color:var(--ok);  border-color:#bbf7d0; background:#ecfdf5;}
    .chip.bad{color:var(--bad); border-color:#fecdd3; background:#fff1f2;}
    .chip.wait{color:var(--wait); border-color:#e5e7eb; background:#f9fafb;}

    /* 비고(반려사유) */
    .note{color:#991b1b; font-size:13px}

    /* Empty */
    .empty{
      display:flex; align-items:center; justify-content:center; text-align:center;
      color:var(--muted); padding:40px 10px;
    }
  </style>
</head>
<body>
<div class="wrap">
  <div class="container">

    <div class="page-head">
      <div>
        <h1 class="page-title">내 자녀 등록 내역</h1>
        <p class="sub">제출/승인 현황을 확인할 수 있어요.</p>
      </div>
      <a class="btn" href="<c:url value='/cert/upload'/>">자녀 등록하기</a>
    </div>

    <c:choose>
      <c:when test="${empty items}">
        <div class="card empty">
          아직 등록된 내역이 없습니다. <a class="btn outline" style="margin-left:12px" href="<c:url value='/cert/upload'/>">지금 등록</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="card table-wrap">
          <table>
            <thead>
            <tr>
              <th style="width:18%">자녀</th>
              <th style="width:16%">생년월일</th>
              <th style="width:26%">학교/학년</th>
              <th style="width:14%">상태</th>
              <th style="width:16%">등록일</th>
              <th style="width:20%">비고</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="it" items="${items}">
              <tr>
                <td>
                  <strong>${it.childName}</strong>
                  <c:if test="${it.childAge != null}"><span style="color:#888;">(${it.childAge})</span></c:if>
                </td>
                <td>${it.childBirth}</td>
                <td>${it.childSchool} <c:if test="${not empty it.childGrade}">/ ${it.childGrade}</c:if></td>
                <td>
                  <c:choose>
                    <c:when test="${it.status == 'APPROVED'}"><span class="chip ok">승인됨</span></c:when>
                    <c:when test="${it.status == 'REJECTED'}"><span class="chip bad">반려됨</span></c:when>
                    <c:otherwise><span class="chip wait">승인 대기</span></c:otherwise>
                  </c:choose>
                </td>
                <td>${it.createdAt}</td>
                <td>
                  <c:if test="${it.status == 'REJECTED' && not empty it.rejectReason}">
                    <span class="note">반려 사유: ${it.rejectReason}</span>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>

  </div>
</div>
</body>
</html>
