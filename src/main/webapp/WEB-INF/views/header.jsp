<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 현재 요청 경로 가져오기 --%>
<c:set var="path" value="${pageContext.request.requestURI}" />

<header>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

  <nav class="top-nav">
    <div class="logo-section">
      <a href="/"><img src="${pageContext.request.contextPath}/logo.png" alt="logo"></a>
    </div>
    <ul class="nav-tabs">
      <li class="main-menu">
      <a href="/mypage/">마이페이지</a></li>
      <li class="main-menu">
      <a href="/map/">범죄 예방 지도</a>
      </li>
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
     <div class="icon-link">
       <button id="alertBtn" type="button" class="icon-btn"
               data-bs-html="true" data-bs-container="body" title="알림" aria-label="알림">
         <i class="bi bi-bell"></i>
       </button>
       <span id="notify-unread-count" class="badge unread-count-badge" style="display:none"></span>
     </div>
       <a href="/chat" class="icon-btn" title="쪽지" style="text-decoration:none">
               <i class="bi bi-envelope"></i>
               <c:if test="${totalUnreadCount > 0}">
                 <span id="total-unread-count-sm" class="badge unread-count-badge">${totalUnreadCount}</span>
               </c:if>
             </a>
    <%-- 팝오버에 넣을 HTML을 임시로 보관 --%>
    <div id="popover-content" class="d-none"></div>
      <%-- 알림 아이콘에 총 읽지 않은 메시지 수 추가 --%>
          <span id="total-unread-count" class="badge unread-count-badge"
                style="display: ${totalUnreadCount > 0 ? 'inline' : 'none'};">
              ${totalUnreadCount}
          </span>
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

// 읽지 않은 알림 수 계산해서 배지 업데이트
var unreadCount = items.filter(n => !n.isRead).length;
var badge = document.getElementById("notify-unread-count");
if (badge) {
  if (unreadCount > 0) {
    badge.textContent = unreadCount;
    badge.style.display = "inline-block";
  } else {
    badge.style.display = "none";
  }
}

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
   sanitize: false,
   customClass: 'notify-panel',
   offset: [0, 15]
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

 <script>
     let stompClientHeader = null;
     let isHeaderConnected = false;
     const currentUserId = '${currentUserId}';

     function connectHeader() {
         if (isHeaderConnected) return;
         isHeaderConnected = true;

         const socket = new SockJS('${pageContext.request.contextPath}/chat');
         stompClientHeader = Stomp.over(socket);
         stompClientHeader.debug = null;

         stompClientHeader.connect({}, function (frame) {

             stompClientHeader.subscribe('/user/sub/chat/user/' + currentUserId, function (message) {
                 updateHeaderBadge();
             });

         }, function(error) {
             isHeaderConnected = false;
         });
     }

    async function updateHeaderBadge() {
        try {
            const timestamp = new Date().getTime();
            const url = '${pageContext.request.contextPath}/chat/totalUnreadCount?_=' + timestamp;

            const response = await fetch(url);
            if (!response.ok) {
                throw new Error('total unread count fetch 실패');
            }
            const count = await response.json();
            const badgeElement = document.getElementById('total-unread-count');
            if (badgeElement) {
                if (count > 0) {
                    badgeElement.textContent = count;
                    badgeElement.style.display = 'inline';
                } else {
                    badgeElement.style.display = 'none';
                }
            }
        } catch (error) {
            console.error('알림 갱신 오류:', error);
        }
    }

     window.addEventListener('load', function() {
         connectHeader();
         updateHeaderBadge();
     });

     window.addEventListener('beforeunload', function() {
         if (stompClientHeader !== null && stompClientHeader.connected) {
             stompClientHeader.disconnect();
         }
         isHeaderConnected = false;
     });

</script>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // 현재 페이지의 경로를 가져옵니다.
    var currentPath = window.location.pathname;

    // 모든 메인 메뉴 항목들을 가져옵니다.
    var mainMenus = document.querySelectorAll('.main-menu');

    // 기존 'active' 클래스 제거
    var activeMenu = document.querySelector('.main-menu.active');
    if (activeMenu) {
        activeMenu.classList.remove('active');
    }

    mainMenus.forEach(function(menu) {
        var link = menu.querySelector('a');

        // Case 1: <a> 태그가 있는 경우
        if (link) {
            var href = link.getAttribute('href');
            // href가 현재 경로를 포함하면 active 클래스 추가
            if (currentPath.startsWith(href)) {
                menu.classList.add('active');
            }
        }
        // Case 2: <a> 태그가 없고, data-type 속성이 있는 경우 (map.jsp 등)
        else {
            var dataType = menu.getAttribute('data-type');
            var urlParam = new URLSearchParams(window.location.search).get('type');

            // data-type이 URL 파라미터 'type'과 일치하면 active 클래스 추가
            if (dataType && dataType === urlParam) {
                menu.classList.add('active');
            }
            // data-type이 'offender'이면서 URL에 'type' 파라미터가 없는 경우
            // (이 부분은 URL 구조에 따라 다를 수 있으니 필요 시 수정)
            else if (dataType === 'offender' && urlParam === null) {
                menu.classList.add('active');
            }
        }
    });
});
</script>

</header>
