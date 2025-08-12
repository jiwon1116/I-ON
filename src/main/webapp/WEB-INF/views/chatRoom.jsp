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
            .chat-container {
                width: 600px;
                margin: 20px auto;
                border: 1px solid #ccc;
                border-radius: 8px;
                display: flex;
                flex-direction: column;
                height: 80vh;
            }
            .chat-header {
                padding: 15px;
                border-bottom: 1px solid #eee;
                text-align: center;
                font-weight: bold;
            }
            .chat-messages {
                flex-grow: 1;
                padding: 15px;
                overflow-y: auto;
                background-color: #f9f9f9;
                display: flex;
                flex-direction: column;
            }
            .message-input {
                display: flex;
                padding: 10px;
                border-top: 1px solid #eee;
            }
            .message-input input {
                flex-grow: 1;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                margin-right: 10px;
            }
            .message-input button {
                padding: 10px 15px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }


            .message {
                display: flex;
                flex-direction: column;
                padding: 4px 8px;
                border-radius: 12px;
                max-width: 50%;
                margin-bottom: 8px;
                width: fit-content;
            }

            .my-message {
                background-color: #dcf8c6;
                margin-left: auto;
            }

            .other-message {
                background-color: #d3d3d3;
                margin-right: auto;
            }

            .message p {
                margin: 0;
                word-wrap: break-word;
            }

            .message-info {
                font-size: 0.8em;
                color: #999;
                margin-top: 2px;
                margin-bottom: 8px;
                text-align: right;
            }
        </style>
</head>
<body>

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