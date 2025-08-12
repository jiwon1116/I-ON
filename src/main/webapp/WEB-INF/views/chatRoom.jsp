<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <meta charset="UTF-8">
    <title>채팅방</title>

    <style>
            :root{
              --brand:#FFCC3C; /* 포인트 컬러 */
              --bg:#fffdf4;
              --text:#222;
              --muted:#888;
              --line:#eee;
              --card:#fff;
              --me:#fff4c2;        /* 내 말풍선 배경 (브랜드 톤) */
              --me-line:#ffe28a;   /* 내 말풍선 테두리 */
              --other:#eeeeee;     /* 상대 말풍선 배경 */
              --other-line:#e2e2e2;
            }

            *{ box-sizing:border-box; }

            body{
              margin:0;
              background:var(--bg);
              font-family: "Noto Sans KR", system-ui, -apple-system, Segoe UI, Roboto, Apple SD Gothic Neo, Malgun Gothic, Arial, sans-serif;
              color:var(--text);
            }

            /* 카드형 컨테이너 */
            .chat-container{
              width:100%;
              max-width:720px;
              margin:24px auto;
              background:var(--card);
              border:1px solid var(--line);
              border-radius:16px;
              box-shadow:0 12px 28px rgba(0,0,0,.08);
              display:flex;
              flex-direction:column;
              height:min(80vh, 900px);
              overflow:hidden;
            }

            /* 상단 헤더(HTML 변경 없이 CSS만으로 네비게이션 느낌) */
            .chat-header{
              position:sticky;
              top:0;
              z-index:10;
              background:var(--brand);
              color:#111;
              padding:14px 48px;             /* 좌우 여백을 넉넉히 */
              border-bottom:1px solid rgba(0,0,0,.06);
              text-align:center;
              font-weight:700;
              letter-spacing:.2px;
            }
            .chat-header h2{
              margin:0;
              font-size:1.05rem;
            }
            .chat-header{ position:relative; }
            .chat-header::before{            /* 뒤로가기 아이콘 (시각적 요소) */
              content:"←";
              position:absolute;
              left:14px; top:50%;
              transform:translateY(-50%);
              font-size:20px;
              opacity:.85;
            }
            .chat-header::after{             /* 더보기 아이콘 (시각적 요소) */
              content:"⋯";
              position:absolute;
              right:14px; top:50%;
              transform:translateY(-50%);
              font-size:22px;
              opacity:.9;
            }

            /* 메시지 영역 */
            .chat-messages{
              flex:1;
              padding:16px 16px 24px;
              overflow:auto;
              background:#fffef8;
            }

            /* 말풍선 */
            .message{
              display:flex;
              flex-direction:column;
              padding:8px 12px;
              border-radius:14px;
              max-width:70%;
              margin:0 0 6px;
              width:fit-content;
              border:1px solid transparent;
              line-height:1.4;
              word-break:break-word;
            }
            .my-message{
              background:var(--me);
              border-color:var(--me-line);
              margin-left:auto;
            }
            .other-message{
              background:var(--other);
              border-color:var(--other-line);
              margin-right:auto;
            }
            .message p{ margin:0; }
            .message-info{
              font-size:.78rem;
              color:var(--muted);
              margin:2px 2px 10px;
              text-align:right; /* 기본값, 아래 JS 로직에 맞춰 좌우 정렬됨 */
            }

            /* 입력창: 하단 고정 느낌 */
            .message-input{
              position:sticky;
              bottom:0;
              display:flex;
              gap:8px;
              padding:12px;
              background:var(--card);
              border-top:1px solid var(--line);
            }
            .message-input input{
              flex-grow:1;
              padding:12px 14px;
              border:1px solid var(--line);
              border-radius:10px;
              outline:none;
            }
            .message-input input:focus{
              border-color:var(--brand);
              box-shadow:0 0 0 3px rgba(255,204,60,.3);
            }
            .message-input button{
              padding:12px 16px;
              background:var(--brand);
              color:#111;
              border:1px solid rgba(0,0,0,.08);
              border-radius:10px;
              font-weight:600;
              cursor:pointer;
              transition:filter .15s ease, transform .02s ease;
            }
            .message-input button:hover{ filter:brightness(.96); }
            .message-input button:active{ transform:translateY(1px); }

            /* 스크롤바 */
            ::-webkit-scrollbar{ width:10px; }
            ::-webkit-scrollbar-track{ background:transparent; }
            ::-webkit-scrollbar-thumb{
              background:rgba(0,0,0,.12);
              border-radius:999px;
            }
            ::-webkit-scrollbar-thumb:hover{ background:rgba(0,0,0,.18); }

            /* 모바일 최적화 */
            @media (max-width:640px){
              .chat-container{ margin:0; height:100vh; border-radius:0; }
              .chat-header{ border-radius:0; }
              .chat-messages{ padding:12px; }
            }

        </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp" />
<div class="chat-container">
    <div class="chat-header">
        <h2>상대방: ${partnerNickname}</h2>
    </div>

    <div class="chat-messages" id="chat-messages">
        <security:authentication property="principal.memberDTO.id" var="currentUserId"/>
          <c:forEach var="message" items="${messages}">
                             <c:choose>
                                 <c:when test="${message.senderId eq currentUserId}">
                                     <div class="message my-message">
                                         <p>${message.content}</p>
                                     </div>
                                     <div class="message-info" style="text-align: right;">
                                         <span><fmt:formatDate value="${message.createdAt}" pattern="yyyy/MM/dd HH:mm"/></span>
                                     </div>
                                 </c:when>
                                 <c:otherwise>
                                     <div class="message other-message">
                                         <p>${message.content}</p>
                                     </div>
                                     <div class="message-info" style="text-align: left;">
                                         <span><fmt:formatDate value="${message.createdAt}" pattern="yyyy/MM/dd HH:mm"/></span>
                                     </div>
                                 </c:otherwise>
                             </c:choose>
                         </c:forEach>
    </div>

    <form class="message-input" id="message-form">
        <input type="text" id="message-input" placeholder="메시지를 입력하세요...">
        <button type="submit">전송</button>
    </form>
</div>

<script>
    let stompClient = null;
    let isConnected = false;
    const chatRoomId = '${chatRoom.id}';
    const currentUserId = '${currentUserId}';

    function connect() {
        if (stompClient && stompClient.connected) {
            return;
        }

        const socket = new SockJS('${pageContext.request.contextPath}/chat');
        stompClient = Stomp.over(socket);
        stompClient.debug = null;

        stompClient.connect({}, function (frame) {
            const subscribeTopic = '/sub/chat/room/' + chatRoomId;
            stompClient.subscribe(subscribeTopic, function (message) {
                try {
                    const receivedMessage = JSON.parse(message.body);
                    showMessage(receivedMessage);
                } catch (e) {
                    console.error("Error parsing message body: " + e);
                }
            });
            isConnected = true;
        }, function(error) {
            console.error("Websocket connection error: " + error);
            isConnected = false;
        });
    }

    function exitRoom() {
        if (currentUserId && chatRoomId) {
            fetch('${pageContext.request.contextPath}/chat/exitRoom/' + chatRoomId + '/' + currentUserId, {
                method: 'POST',
                keepalive: true
            }).catch(error => console.error('Error exiting room:', error));
        }
    }

    function sendMessage() {
        const messageInput = document.getElementById('message-input');
        const messageContent = messageInput.value.trim();

        if (messageContent && stompClient && stompClient.connected) {
            const message = {
                roomId: chatRoomId,
                senderId: currentUserId,
                content: messageContent
            };
            stompClient.send("/pub/chat/send", {}, JSON.stringify(message));
            messageInput.value = '';
        }
    }

    function showMessage(message) {
        const chatMessages = document.getElementById('chat-messages');
        if (!chatMessages) {
            return;
        }

        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message');

        const isMyMessage = message.senderId == currentUserId;
        if (isMyMessage) {
            messageDiv.classList.add('my-message');
        } else {
            messageDiv.classList.add('other-message');
        }

        const contentP = document.createElement('p');
        contentP.textContent = message.content || '';
        messageDiv.appendChild(contentP);

        chatMessages.appendChild(messageDiv);

        const infoDiv = document.createElement('div');
        infoDiv.classList.add('message-info');
        const infoSpan = document.createElement('span');

        infoSpan.textContent = message.formattedCreatedAt || '';

        infoDiv.appendChild(infoSpan);

        if (isMyMessage) {
            infoDiv.style.textAlign = 'right';
        } else {
            infoDiv.style.textAlign = 'left';
        }

        chatMessages.appendChild(infoDiv);

        scrollToBottom();
    }

    function scrollToBottom() {
        const chatMessages = document.getElementById('chat-messages');
        if (chatMessages) {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
    }

    document.getElementById('message-form').addEventListener('submit', function(e) {
        e.preventDefault();
        sendMessage();
    });

    scrollToBottom();

    window.addEventListener('load', function() {
        connect();
    });

    window.addEventListener('beforeunload', function() {
        if (stompClient !== null && stompClient.connected) {
            stompClient.disconnect();
        }
        isConnected = false;
        exitRoom();
    });
</script>
</body>
</html>