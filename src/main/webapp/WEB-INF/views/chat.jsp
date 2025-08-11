<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { max-width: 800px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .alert-error { background-color: #f8d7da; color: #721c24; }
        .create-chat-form { display: flex; margin-bottom: 20px; }
        .create-chat-form input { flex-grow: 1; padding: 10px; margin-right: 10px; border: 1px solid #ccc; border-radius: 5px; }
        .create-chat-form button { padding: 10px 15px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .chat-room-list { list-style: none; padding: 0; }
        .chat-room-item { border: 1px solid #eee; margin-bottom: 10px; padding: 15px; border-radius: 8px; background-color: #f9f9f9; transition: background-color 0.2s; }
        .chat-room-item:hover { background-color: #f1f1f1; }
        .chat-room-link { text-decoration: none; color: #333; display: block; }
        .chat-room-info strong { font-size: 1.1em; }
        .chat-room-info p { margin: 5px 0; color: #666; }
        .last-message { font-size: 0.9em; }
        .unread-count { background-color: red; color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; margin-left: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>채팅방 목록</h2>

        <c:if test="${not empty findFail}">
            <div class="alert alert-error">${findFail}</div>
        </c:if>

        <div class="create-chat-form">
            <form action="/chat/create" method="post">
                <input type="text" name="nickname" placeholder="상대방 닉네임 입력" required>
                <button type="submit">채팅방 생성</button>
            </form>
        </div>

        <security:authentication property="principal.memberDTO.id" var="currentUserId"/>

        <ul class="chat-room-list" id="chat-room-list">
            <c:forEach var="room" items="${chatRooms}">
                <li class="chat-room-item" data-room-id="${room.id}">
                    <a href="/chat/room/${room.id}" class="chat-room-link">
                        <div class="chat-room-info">
                            <p><strong>상대방: ${room.partnerNickname}</strong></p>
                            <p class="last-message">마지막 메시지: ${room.lastMessage}</p>
                        </div>

                        <c:choose>
                            <c:when test="${room.user1Id eq currentUserId and room.user1UnreadCount > 0}">
                                <span class="unread-count">${room.user1UnreadCount}</span>
                            </c:when>
                            <c:when test="${room.user2Id eq currentUserId and room.user2UnreadCount > 0}">
                                <span class="unread-count">${room.user2UnreadCount}</span>
                            </c:when>
                        </c:choose>
                    </a>
                </li>
            </c:forEach>
            <c:if test="${empty chatRooms}">
                <p>참여하고 있는 채팅방이 없습니다.</p>
            </c:if>
        </ul>
    </div>

    <script>
        let stompClient = null;
        let isConnected = false;

        function connect() {
            if (isConnected) return;
            isConnected = true;

            const socket = new SockJS('/chat');
            stompClient = Stomp.over(socket);

            stompClient.connect({}, function (frame) {
                console.log('Connected to chat room list: ' + frame);

                stompClient.subscribe('/sub/chat/roomList', function (message) {
                    const receivedMessage = JSON.parse(message.body);
                    updateChatRoomList(receivedMessage);
                });
            }, function(error) {
                console.log('Connection error: ' + error);
                isConnected = false;
            });
        }

        function updateChatRoomList(message) {
            const chatRoomDiv = document.querySelector(`.chat-room-item[data-room-id="${message.roomId}"]`);

            if (chatRoomDiv) {
                const lastMessageP = chatRoomDiv.querySelector('.last-message');
                lastMessageP.innerText = `최근 메시지: ${message.content}`;

                const chatListContainer = document.getElementById('chat-room-list');
                chatListContainer.prepend(chatRoomDiv);
            }
        }

        window.addEventListener('pageshow', function(event) {
            if (event.persisted) {
                connect();
            } else {
                connect();
            }
        });

        window.addEventListener('beforeunload', function() {
            if (stompClient !== null && stompClient.connected) {
                stompClient.disconnect();
            }
            isConnected = false;
        });

    </script>
</body>
</html>