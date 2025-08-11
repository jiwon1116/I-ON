<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>

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
        }
        .message-input {
            display: flex;
            padding: 10px;
            border-top: 1px solid #eee;
        }
        .message-input input {
            flex-grow = 1;
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
        /* 메시지 스타일 */
        .message {
            margin-bottom: 10px;
            padding: 8px;
            border-radius: 8px;
            max-width: 70%;
        }
        .my-message {
            background-color: #dcf8c6;
            margin-left: auto;
        }
        .other-message {
            background-color: #ffffff;
        }
        .message-info {
            font-size: 0.8em;
            color: #999;
            margin-top: 4px;
            text-align: right;
        }
    </style>
</head>
<body>

<div class="chat-container">
    <div class="chat-header">
        <h2>상대방: ${partnerNickname}</h2> </div>

    <div class="chat-messages" id="chat-messages">
        <security:authentication property="principal.memberDTO.id" var="currentUserId"/>
        <c:forEach var="message" items="${messages}">
            <c:choose>
                <c:when test="${message.senderId eq currentUserId}">
                    <div class="message my-message">
                        <p>${message.content}</p>
                        <div class="message-info">나 - ${message.createdAt}</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="message other-message">
                        <p>${message.content}</p>
                        <div class="message-info">${partnerNickname} - ${message.createdAt}</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>

    <div class="message-input">
        <input type="text" id="message-input" placeholder="메시지를 입력하세요...">
        <button id="send-button">전송</button>
    </div>
</div>


<script>
    let stompClient = null;
    let isConnected = false;
    const chatRoomId = '${chatRoom.id}';
    const currentUserId = '${currentUserId}';

    function connect() {
        if (stompClient && stompClient.connected) {
            console.log("WebSocket is already connected.");
            return;
        }

        console.log("Attempting to connect WebSocket...");

        const socket = new SockJS('/chat');
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('Connected: ' + frame);

            stompClient.subscribe('/sub/chat/room/' + chatRoomId, function (message) {
                console.log('Received message:', message.body);
                const receivedMessage = JSON.parse(message.body);
                showMessage(receivedMessage);
            });
            isConnected = true;
        }, function(error) {
            console.log('Connection error: ' + error);
            isConnected = false;
        });
    }

    function disconnect() {
        if (stompClient !== null && stompClient.connected) {
            stompClient.disconnect();
            console.log("Disconnected from WebSocket.");
        }
        stompClient = null;
        isConnected = false;
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
        } else {
             console.log("Cannot send message: WebSocket not connected.");
        }
    }

    function showMessage(message) {
        const chatMessages = document.getElementById('chat-messages');
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message');

        const isMyMessage = message.senderId == currentUserId;
        if (isMyMessage) {
            messageDiv.classList.add('my-message');
        } else {
            messageDiv.classList.add('other-message');
        }

        const senderInfo = isMyMessage ? '나' : '${partnerNickname}';

        const date = new Date(message.createdAt);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');

        const formattedDate = `${year}/${month}/${day} ${hours}:${minutes}`;

        messageDiv.innerHTML = `<p>${message.content}</p><div class="message-info">${senderInfo} - ${formattedDate}</div>`;
        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    window.addEventListener('pageshow', function(event) {
        connect();
    });

    window.addEventListener('beforeunload', function() {
        disconnect();
    });

    document.getElementById('send-button').addEventListener('click', function() {
        sendMessage();
    });

    document.getElementById('message-input').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });

</script>
</body>
</html>