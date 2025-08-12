<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="CTX" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>재학증명서 목록</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- 탭 전환만 부트스트랩 JS를 사용합니다 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    :root{
      --brand:#F2AC28; --bg:#F7F7F7; --text:#222; --muted:#808080;
      --card:#fff; --line:#e9e9e9; --shadow:0 10px 24px rgba(0,0,0,.06);
      --radius:16px; --ok:#16a34a; --bad:#dc2626; --wait:#6b7280;
    }
    *{box-sizing:border-box}
    body{margin:0; background:var(--bg); color:var(--text);
      font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans KR",Helvetica,Arial,sans-serif;}

    .wrap{min-height:100vh; padding:44px 16px; display:flex; justify-content:flex-start}
    .container-n{width:100%; max-width:1100px; margin:0 auto}

    /* 헤더 */
    .page-head{display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:14px}
    .page-title{margin:0; font-weight:800; font-size:22px}
    .sub{color:var(--muted); font-size:14px; margin:4px 0 0}

    /* 탭 */
    .tabs{background:transparent; border:none; margin-bottom:14px}
    .tabs .nav-link{
      border:none; border-radius:999px; margin-right:8px; padding:10px 16px; color:#555; font-weight:700;
      background:#fff; border:1px solid var(--line);
    }
    .tabs .nav-link:hover{background:#fcfcfc}
    .tabs .nav-link.active{
      color:#111; background:var(--brand);
      border-color:var(--brand); box-shadow:0 8px 16px rgba(242,172,40,.25);
    }

    /* 카드 & 테이블 */
    .card-n{background:var(--card); border-radius:var(--radius); box-shadow:var(--shadow); padding:18px}
    .table-wrap{overflow-x:auto}
    table{width:100%; border-collapse:separate; border-spacing:0; min-width:760px}
    thead th{
      text-align:left; font-size:13px; color:#666; font-weight:700;
      padding:12px 14px; border-bottom:1px solid var(--line); background:#fafafa;
    }
    tbody td{padding:14px; border-bottom:1px solid var(--line); vertical-align:middle; font-size:14px}
    tbody tr:hover{background:#fcfcfc}

    /* 상태칩 */
    .chip{
      display:inline-flex; align-items:center; gap:6px;
      padding:6px 10px; border-radius:999px; font-weight:700; font-size:12px; border:1px solid;
    }
    .chip.ok{ color:var(--ok);  border-color:#bbf7d0; background:#ecfdf5;}
    .chip.bad{color:var(--bad); border-color:#fecdd3; background:#fff1f2;}
    .chip.wait{color:var(--wait); border-color:#e5e7eb; background:#f9fafb;}

/* 탭 한 줄 정렬 */
.tabs {
  display: flex; /* 가로 배치 */
  gap: 8px;      /* 버튼 사이 간격 */
  flex-wrap: nowrap; /* 줄바꿈 방지 */
}

.tabs .nav-item {
  flex: 1; /* 버튼이 같은 폭으로 나눠짐 */
}

.tabs .nav-link {
  width: 100%; /* nav-item 안에서 꽉 채움 */
  text-align: center;
}

    /* 버튼 */

    .btn-brand{
      display:inline-flex; align-items:center; justify-content:center;
      height:36px; padding:0 12px; border:none; border-radius:10px; cursor:pointer; text-decoration:none;
      font-weight:700; font-size:13px; background:var(--brand); color:#111;
      box-shadow:0 8px 16px rgba(242,172,40,.25);
    }
    .btn-brand:active{transform:translateY(1px)}
    .btn-outline{background:#fff; color:#111; border:1px solid var(--line); box-shadow:none}

    /* empty */
    .empty{color:var(--muted); padding:32px 8px}
  </style>
</head>
<body>

<div class="wrap">
  <div class="container-n">

    <div class="page-head">
      <div>
        <h3 class="page-title">재학증명서 접수 내역</h3>
        <p class="sub">관리자용 전체/상태별 접수 현황</p>
      </div>
      <!-- 뒤로가기 버튼 -->
      <a href="javascript:void(0)"
         class="btn-brand btn-outline"
         onclick="if(document.referrer){history.back();}else{location.href='${CTX}/';}">
        ← 뒤로가기
      </a>
    </div>

    <ul class="nav tabs" role="tablist">
      <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-all" type="button" role="tab">전체</button></li>
      <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-pending" type="button" role="tab">승인 대기</button></li>
      <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-approved" type="button" role="tab">승인됨</button></li>
      <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-rejected" type="button" role="tab">반려됨</button></li>
    </ul>

    <div class="tab-content">

      <!-- 전체 -->
      <div class="tab-pane fade show active" id="tab-all" role="tabpanel">
        <div class="card-n table-wrap">
          <table>
            <thead>
            <tr><th style="width:80px">ID</th><th style="width:160px">유저ID</th><th>닉네임</th><th style="width:140px">상태</th><th style="width:170px">등록일</th><th style="width:120px">보기</th></tr>
            </thead>
            <tbody>
            <c:forEach var="it" items="${all}">
              <tr>
                <td>${it.id}</td>
                <td>${it.userId}</td>
                <td>${it.nickname}</td>
                <td>
                  <c:choose>
                    <c:when test="${it.status == 'APPROVED'}"><span class="chip ok">승인됨</span></c:when>
                    <c:when test="${it.status == 'REJECTED'}"><span class="chip bad">반려됨</span></c:when>
                    <c:otherwise><span class="chip wait">승인 대기</span></c:otherwise>
                  </c:choose>
                </td>
                <td>${it.createdAt}</td>
                <td>
                  <c:url value="/cert/admin/${it.id}/page" var="detailUrl"/>
                  <a class="btn-brand btn-outline" href="${detailUrl}">상세</a>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty all}"><div class="empty">데이터가 없습니다.</div></c:if>
        </div>
      </div>

      <!-- 승인 대기 -->
      <div class="tab-pane fade" id="tab-pending" role="tabpanel">
        <div class="card-n table-wrap">
          <table>
            <thead><tr><th>ID</th><th>유저ID</th><th>닉네임</th><th>등록일</th><th>보기</th></tr></thead>
            <tbody>
            <c:forEach var="it" items="${pending}">
              <tr>
                <td>${it.id}</td>
                <td>${it.userId}</td>
                <td>${it.nickname}</td>
                <td>${it.createdAt}</td>
                <td>
                  <c:url value="/cert/admin/${it.id}/page" var="detailUrl"/>
                  <a class="btn-brand btn-outline" href="${detailUrl}">상세</a>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty pending}"><div class="empty">승인 대기 항목이 없습니다.</div></c:if>
        </div>
      </div>

      <!-- 승인됨 -->
      <div class="tab-pane fade" id="tab-approved" role="tabpanel">
        <div class="card-n table-wrap">
          <table>
            <thead><tr><th>ID</th><th>유저ID</th><th>닉네임</th><th>등록일</th><th>보기</th></tr></thead>
            <tbody>
            <c:forEach var="it" items="${approved}">
              <tr>
                <td>${it.id}</td>
                <td>${it.userId}</td>
                <td>${it.nickname}</td>
                <td>${it.createdAt}</td>
                <td>
                  <c:url value="/cert/admin/${it.id}/page" var="detailUrl"/>
                  <a class="btn-brand btn-outline" href="${detailUrl}">상세</a>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty approved}"><div class="empty">승인 완료 항목이 없습니다.</div></c:if>
        </div>
      </div>

      <!-- 반려됨 -->
      <div class="tab-pane fade" id="tab-rejected" role="tabpanel">
        <div class="card-n table-wrap">
          <table>
            <thead><tr><th>ID</th><th>유저ID</th><th>닉네임</th><th>등록일</th><th>보기</th></tr></thead>
            <tbody>
            <c:forEach var="it" items="${rejected}">
              <tr>
                <td>${it.id}</td>
                <td>${it.userId}</td>
                <td>${it.nickname}</td>
                <td>${it.createdAt}</td>
                <td>
                  <c:url value="/cert/admin/${it.id}/page" var="detailUrl"/>
                  <a class="btn-brand btn-outline" href="${detailUrl}">상세</a>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <c:if test="${empty rejected}"><div class="empty">반려된 항목이 없습니다.</div></c:if>
        </div>
      </div>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
