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
      <a href="/"><img class="header-logo" src="${pageContext.request.contextPath}/resources/img/logo.png" alt="logo"></a>
    </div>

    <!-- 중앙 탭: id만 추가(스크립트용), 구조 변경 없음 -->
    <ul id="primaryNav" class="nav-tabs">
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

    <!-- 오른쪽 아이콘 + 햄버거(추가) -->
    <div class="icons">
      <%-- 알림 팝오버 버튼 --%>
      <div class="icon-link" style="margin-right:4px; ">
        <button id="alertBtn" type="button" class="icon-btn"
                data-bs-html="true" data-bs-container="body" title="알림" aria-label="알림">
          <i class="bi bi-bell" style="position:relative; top:-2px;"></i>
        </button>
        <span id="notify-unread-count" class="badge unread-count-badge" style="display:none; top:-7px;"></span>
      </div>

      <a href="/chat" class="icon-btn" title="쪽지" style="text-decoration:none; position:relative;">
        <i class="bi bi-envelope"></i>
        <c:if test="${totalUnreadCount > 0}">
          <span id="total-unread-count-sm" class="badge unread-count-badge"
                style="position:absolute; top:0; right:0; transform:translate(50%,-50%);">
            ${totalUnreadCount}
          </span>
        </c:if>
      </a>


      <%-- 팝오버에 넣을 HTML을 임시로 보관 --%>
      <div id="popover-content" class="d-none"></div>

      <button type="button" id="navToggle" class="nav-toggle" aria-label="메뉴 열기" aria-controls="primaryNav" aria-expanded="false">
        <i class="bi bi-list"></i>
      </button>
    </div>
  </nav>

  <%-- 알림 팝오버 스크립트 (기존 코드: 변경 없음) --%>
<script>
document.addEventListener("DOMContentLoaded", async function () {
  var btn = document.getElementById("alertBtn");
  if (!btn) return;
  var base = "${pageContext.request.contextPath}" || "";

  try {
    var res = await fetch(base + "/notify/list", { credentials: "same-origin" });
    if (!res.ok) throw new Error("HTTP " + res.status);
    var items = await res.json();

    var unreadCount = items.filter(n => !n.isRead).length;
    var badge = document.getElementById("notify-unread-count");
    if (badge) {
      if (unreadCount > 0) { badge.textContent = unreadCount; badge.style.display = "inline-block"; }
      else { badge.style.display = "none"; }
    }

    items.sort(function (a, b) { return (b.created_at || 0) - (a.created_at || 0); });

    var html = '<div style="max-height:220px; overflow-y:auto;"><ul class="list-unstyled mb-0">';
    if (items.length) {
      for (var i = 0; i < items.length; i++) {
        var n = items[i];
        var text = (n && n.content) ? n.content : '';
        var board = (n && n.related_board) ? n.related_board : "";
        var pid   = (n && n.related_post_id) ? n.related_post_id : "";
        var link  = base + "/" + board + "/" + pid;

        html += '<li style="padding:6px 0; border-bottom:1px solid #f0f0f0;">'
             +   '<a href="' + link + '" style="text-decoration:none; color:inherit;">' + text + '</a>'
             +   '<button type="button" class="notify-delete" data-id="' + n.id + '"'
             +           ' style="margin-left:8px;background:none;border:none;cursor:pointer;">❌</button>'
             + '</li>';
      }
    } else {
      html += '<li style="padding:10px;">알림이 없습니다🙂</li>';
    }
    html += '</ul></div>';

    const pop = new bootstrap.Popover(btn, {
      html: true, container: 'body', placement: 'bottom', trigger: 'click',
      title: '알림', content: html, sanitize: false, customClass: 'notify-panel', offset: [0, 15]
    });

  } catch (e) {
    console.error("notify popover error:", e);
    var fallback = '<div style="max-height:220px; overflow-y:auto;">'
                 +   '<ul class="list-unstyled mb-0"><li>알림을 불러오지 못했습니다</li></ul>'
                 + '</div>';
    new bootstrap.Popover(btn, {
      html: true, container: 'body', placement: 'bottom', trigger: 'click',
      title: '알림', content: fallback
    });
  }
});

document.addEventListener('click', function(e){
  if (e.target && e.target.classList.contains('notify-delete')) {
    const id = e.target.getAttribute('data-id');
    deleteNotify(id);
    e.target.closest('li')?.remove();
  }
});

function deleteNotify(id, buttonElement) {
  if (!confirm("이 알림을 삭제할까요?")) return;
  const base = "${pageContext.request.contextPath}" || "";
  fetch(base + "/notify/delete/" + id, {
    method: "DELETE", credentials: "same-origin"
  })
  .then(res => {
    if (!res.ok) throw new Error("삭제 실패: " + res.status);
    return res.text();
  })
  .then(() => { window.location.reload(); })
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
    var currentPath = window.location.pathname;
    var mainMenus = document.querySelectorAll('.main-menu');

    var activeMenu = document.querySelector('.main-menu.active');
    if (activeMenu) { activeMenu.classList.remove('active'); }

    mainMenus.forEach(function(menu) {
        var link = menu.querySelector('a');
        if (link) {
            var href = link.getAttribute('href');
            if (currentPath.startsWith(href)) {
                menu.classList.add('active');
            }
        } else {
            var dataType = menu.getAttribute('data-type');
            var urlParam = new URLSearchParams(window.location.search).get('type');
            if (dataType && dataType === urlParam) {
                menu.classList.add('active');
            } else if (dataType === 'offender' && urlParam === null) {
                menu.classList.add('active');
            }
        }
    });
});
</script>

<!-- ====================== 추가 CSS (반응형 & 햄버거) ====================== -->
<style>
  /* 로고 항상 일정 */
  .header-logo{ height:56px; width:auto; object-fit:contain; display:block; }

  /* 햄버거: 기본은 숨김 (모바일에서만 보임) */
  .nav-toggle{
    display:none; background:transparent; border:none; color:#fff;
    font-size:32px; line-height:1; padding:4px 6px; margin-left:6px;
  }

  /* 모바일 메뉴 기본 숨김 */
  @media (max-width: 992px){
    .top-nav{ height:70px; }
    /* 가운데 탭을 고정 레이어로 전환 */
    .top-nav .nav-tabs{
      position:fixed; left:0; right:0; top:70px;
      display:none; flex-direction:column; gap:8px;
      padding:12px; margin:0; background:#fff8e7;
      border-top:1px solid rgba(0,0,0,.06);
      box-shadow:0 10px 24px rgba(0,0,0,.08);
      z-index:1050;
    }
    /* 열렸을 때 보이기 */
    .top-nav.is-open .nav-tabs{ display:flex; }

    /* 메뉴 아이템 카드 느낌 */
    .top-nav .main-menu{
      width:auto; height:auto; border-radius:12px; background:#fff; color:#333;
      padding:10px 12px; box-shadow:0 6px 14px rgba(0,0,0,.06);
    }
    .top-nav .nav-tabs .main-menu > a{
      position:relative; inset:auto; display:block; padding:6px 6px;
    }

    /* 데스크톱 호버 드롭다운 비활성, 클릭으로 열게 */
    .top-nav .main-menu:hover .sub-menu{ display:none; }
    .top-nav .main-menu .sub-menu{
      position:relative; top:auto; left:auto; width:100%;
      background:#fff; border-radius:10px; box-shadow:none;
      padding:6px 0; margin-top:6px; display:none;
    }
    .top-nav .main-menu.open .sub-menu{ display:block; }

    /* 햄버거 표시 */
    .nav-toggle{ display:inline-flex; align-items:center; justify-content:center; }
  }

  /* 아이콘 크기 미세 조정 */
  @media (max-width: 576px){
    .icon-btn{ font-size:26px }
  }

  .unread-count-badge {
    background: red;
    color: white;
    font-size: 11px;
    border-radius: 50%;
    padding: 2px 5px;
    line-height: 1;
  }

</style>

<!-- ====================== 추가 JS (기존 JS 변경 X) ====================== -->
<script>
  (function(){
    const nav    = document.querySelector('.top-nav');
    const toggle = document.getElementById('navToggle');
    const panel  = document.getElementById('primaryNav');

    // 햄버거 토글
    toggle?.addEventListener('click', function(){
      const isOpen = nav.classList.toggle('is-open');
      this.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
      document.body.style.overflow = isOpen ? 'hidden' : ''; // 메뉴 열릴 때 배경 스크롤 잠금
    });

    // 모바일에서 서브메뉴 클릭 토글(커뮤니티 등)
    panel?.addEventListener('click', function(e){
      if (!window.matchMedia('(max-width: 992px)').matches) return;

      const a = e.target.closest('.main-menu > a');
      if (!a) return;

      const li = a.parentElement;
      const sub = li.querySelector('.sub-menu');
      if (sub){
        // 링크 이동 막고 펼치기
        e.preventDefault();
        li.classList.toggle('open');
      } else {
        // 일반 링크는 메뉴 닫고 진행
        nav.classList.remove('is-open');
        document.body.style.overflow = '';
      }
    });

    // 화면 다시 커지면 상태 초기화
    window.addEventListener('resize', function(){
      if (window.matchMedia('(min-width: 993px)').matches){
        nav.classList.remove('is-open');
        document.body.style.overflow = '';
        document.querySelectorAll('.main-menu.open').forEach(el=>el.classList.remove('open'));
      }
    });
  })();
</script>

</header>
