<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">


<style>
  /* 네비/아이콘 영역이 팝오버를 가리지 않게 */
  .top-nav, .icons {
    position: relative;
    overflow: visible !important;
    z-index: 1060; /* 부트스트랩 모달/팝오버 레벨대 맞춤 */
  }

  /* 혹시 전역에서 nav/header에 overflow:hidden; 준 경우 방지 */
  header, nav {
    overflow: visible !important;
  }

  /* 팝오버 자체 z-index 강화 (보이는지 테스트용) */
  .popover {
    z-index: 2000 !important;
    max-width: 320px; /* 내용 잘림 방지(선택) */
  }

  /* 편지 아이콘과 배지를 감싸는 링크 스타일 */
  .icon-link {
    position: relative; /* 배지 위치를 잡기 위해 필요 */
    display: inline-block; /* 팝오버 버튼과 나란히 표시 */
    margin-right: 15px; /* 버튼과 간격 주기 */
  }

  /* 총 읽지 않은 메시지 수를 표시하는 배지 스타일 */
  .unread-count-badge {
    position: absolute;
    top: -5px;
    right: -10px;
    font-size: 0.75rem; /* 글씨 크기 조절 */
    background-color: red;
    color: white;
    border-radius: 50%;
    padding: 2px 6px;
  }
</style>

  <nav class="top-nav">
    <div class="logo-section">
      <a href="/"><img src="${pageContext.request.contextPath}/logo.png" alt="logo"></a>
    </div>
    <ul class="nav-tabs">
      <li class="main-menu"><a href="/mypage/">마이페이지</a></li>
      <li class="main-menu"><a href="/map/">범죄 예방 지도</a></li>
      <li class="main-menu active">
        <a href="/free">커뮤니티</a>
        <ul class="sub-menu">
          <li><a href="/free">자유</a></li>
          <li><a href="/entrust">위탁</a></li>
          <li><a href="/miss">실종 및 유괴</a></li>
        </ul>
      </li>
      <li class="main-menu"><a href="/flag">제보 및 신고</a></li>
      <li class="main-menu"><a href="/info">정보 공유</a></li>
    </ul>
    <div class="icons">
      <%-- 알림 팝오버 버튼 --%>
    <button id="alertBtn" type="button" class="btn btn-secondary"
            data-bs-html="true" data-bs-container="body" title="알림">🔔</button>
    <div id="popover-content" class="d-none"></div>
      <%-- 팝오버에 넣을 HTML을 임시로 보관 --%>
    <div id="popover-content" class="d-none"></div>

      <%-- 편지 아이콘에 총 읽지 않은 메시지 수 추가 --%>
      <a href="/chat" class="icon-link">
          <span class="icon">✉️</span>
          <c:if test="${totalUnreadCount > 0}">
              <span id="total-unread-count" class="badge unread-count-badge">
                  ${totalUnreadCount}
              </span>
          </c:if>
      </a>

    </div>
  </nav>

  <%-- 알림 팝오버 스크립트 --%>
<script>
document.addEventListener("DOMContentLoaded", async function () {
  // 1) 버튼 찾기
  var btn = document.getElementById("alertBtn");
  if (!btn) return;

  // 2) 컨텍스트 경로 (루트가 아닐 때 대비)
  var base = "${pageContext.request.contextPath}" || "";

  try {
    // 3) 알림 목록 가져오기 (JSON)
    var res = await fetch(base + "/notify/list", { credentials: "same-origin" });
    if (!res.ok) throw new Error("HTTP " + res.status);
    var items = await res.json(); // ← 여기서부터 items 사용

    // 4) 최신이 위로 오게 정렬
    items.sort(function (a, b) {
      return (b.created_at || 0) - (a.created_at || 0);
    });

    // 5) HTML 시작 (5개 높이 정도로 보이게 → 스크롤)
    var html = '<div style="max-height:220px; overflow-y:auto;">'
             +   '<ul class="list-unstyled mb-0">';

    if (items.length) {
      // 6) 알림을 한 줄씩 <li>로 쌓기 (링크 포함)
      for (var i = 0; i < items.length; i++) {
        var n = items[i];
       // 한 줄 출력: 내용 전체를 클릭하면 게시물로 이동, 옆에 삭제 버튼
    // 내용
    var text = (n && n.content) ? n.content : '';

    // 링크: /{board}/{postId}  (컨텍스트 경로 포함)
    var board = (n && n.related_board) ? n.related_board : "";
    var pid   = (n && n.related_post_id) ? n.related_post_id : "";
    var link  = base + "/" + board + "/" + pid;

    // 한 줄 출력: 내용 전체를 클릭하면 게시물로 이동, 옆에 삭제 버튼
  // 루프 안: 버튼을 onclick 대신 data-id로
  html += '<li style="padding:6px 0; border-bottom:1px solid #f0f0f0;">'
       +   '<a href="' + link + '" style="text-decoration:none; color:inherit;">' + text + '</a>'
       +   '<button type="button" class="notify-delete" data-id="' + n.id + '"'
       +           ' style="margin-left:8px;background:none;border:none;cursor:pointer;">❌</button>'
       + '</li>';

      }
    } else {
      // 7) 알림이 없을 때
      html += '<li style="padding:10px;">알림이 없습니다🙂</li>';
    }

    // 8) HTML 마무리
    html +=   '</ul>'
           + '</div>';

    // 9) 팝오버 생성 (content 옵션으로 주입)  sanitize 끄기
   const pop = new bootstrap.Popover(btn, {
     html: true,
     container: 'body',
     placement: 'bottom',
     trigger: 'click',
     title: '알림',
     content: html,
     sanitize: false   // 이거 추가!
   });

  } catch (e) {
    console.error("notify popover error:", e);
    // 실패시 기본 문구
    var fallback = '<div style="max-height:220px; overflow-y:auto;">'
                 +   '<ul class="list-unstyled mb-0"><li>알림을 불러오지 못했습니다</li></ul>'
                 + '</div>';
    new bootstrap.Popover(btn, {
      html: true, container: 'body', placement: 'bottom', trigger: 'click',
      title: '알림', content: fallback
    });
  }
});

// 문서 위임으로 삭제 클릭 처리 (onclick 필요 없음)
document.addEventListener('click', function(e){
  // 'notify-delete' 클래스를 가진 버튼을 클릭했는지 확인
  if (e.target && e.target.classList.contains('notify-delete')) {
    const id = e.target.getAttribute('data-id');

    // 알림 삭제 함수 호출 (id만 전달)
    deleteNotify(id);

    // 삭제 성공 시, UI에서 즉시 해당 목록 항목 제거
    e.target.closest('li')?.remove();
  }
});

// 알림 삭제 함수
function deleteNotify(id, buttonElement) {
  if (!confirm("이 알림을 삭제할까요?")) return;

  const base = "${pageContext.request.contextPath}" || "";

  fetch(base + "/notify/delete/" + id, {
    method: "DELETE",
    credentials: "same-origin"
  })
  .then(res => {
    if (!res.ok) throw new Error("삭제 실패: " + res.status);
    return res.text(); // 서버 응답 텍스트를 받음
  })
  .then(responseText => {
    console.log(responseText); // "삭제 성공" 메시지가 출력
    // 서버 응답 성공 시, 페이지를 새로고침하여 캐시 문제를 해결
    window.location.reload();
  })
  .catch(err => {
    console.error(err);
    alert("삭제 중 오류가 발생했습니다.");
  });
}
</script>
</header>
