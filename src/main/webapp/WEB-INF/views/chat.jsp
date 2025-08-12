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
        .create-chat-form button { padding: 10px 15px; background-color: #FFCC3C; color: 333; border: none; border-radius: 5px; cursor: pointer; }
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
                            <p class="last-message">최근 메시지: ${room.lastMessage}</p>
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
        let stompClientList = null;
        let isConnectedList = false;
        const currentUserIdList = '${currentUserId}';

        function connectChatList() {
            if (isConnectedList) return;
            isConnectedList = true;

            const socket = new SockJS('${pageContext.request.contextPath}/chat');
            stompClientList = Stomp.over(socket);
            stompClientList.debug = null;

            stompClientList.connect({}, function (frame) {
                stompClientList.subscribe('/sub/chat/user/' + currentUserIdList, function (message) {
                    const receivedMessage = JSON.parse(message.body);
                    if (receivedMessage.type === 'READ_UPDATE') {
                        handleReadUpdate(receivedMessage.roomId);
                    } else {
                        handleNewMessage(receivedMessage);
                    }
                });
            }, function(error) {
                isConnectedList = false;
            });
        }

       async function handleNewMessage(message) {


               if (!message || !message.roomId) {
                   return;
               }


               const messageContent = message.content;

               const chatRoomListContainer = document.getElementById('chat-room-list');

               let chatRoomDiv = null;
               const allChatRooms = chatRoomListContainer.querySelectorAll('.chat-room-item');
               for (const room of allChatRooms) {
                   if (parseInt(room.dataset.roomId) === message.roomId) {
                       chatRoomDiv = room;
                       break;
                   }
               }

               if (!chatRoomDiv) {

                   try {
                       const fetchUrl = `${pageContext.request.contextPath}/chat/roomInfo/` + message.roomId;
                       const response = await fetch(fetchUrl);

                       if (!response.ok) {
                           throw new Error('fetch 안됨');
                       }
                       const roomInfo = await response.json();

                       chatRoomDiv = document.createElement('li');
                       chatRoomDiv.className = 'chat-room-item';
                       chatRoomDiv.dataset.roomId = roomInfo.id;

                       const link = document.createElement('a');
                       link.href = `${pageContext.request.contextPath}/chat/room/${roomInfo.id}`;
                       link.className = 'chat-room-link';

                       const infoDiv = document.createElement('div');
                       infoDiv.className = 'chat-room-info';

                       const nicknameP = document.createElement('p');
                       const nicknameStrong = document.createElement('strong');
                       nicknameStrong.textContent = `상대방: ${roomInfo.partnerNickname}`;
                       nicknameP.appendChild(nicknameStrong);

                       const lastMessageP = document.createElement('p');
                       lastMessageP.className = 'last-message';
                       lastMessageP.textContent = '최근 메시지: ' + messageContent; // 수정된 부분

                       infoDiv.appendChild(nicknameP);
                       infoDiv.appendChild(lastMessageP);
                       link.appendChild(infoDiv);

                       if (message.senderId != currentUserIdList) {
                           const unreadBadge = document.createElement('span');
                           unreadBadge.className = 'unread-count';
                           unreadBadge.textContent = '1';
                           link.appendChild(unreadBadge);
                       }

                       chatRoomDiv.appendChild(link);
                       chatRoomListContainer.prepend(chatRoomDiv);

                   } catch (error) {
                       console.error('새로운 채팅방 생성 안됨:', error);
                   }
               } else {

                   const lastMessageP = chatRoomDiv.querySelector('.last-message');
                   if (lastMessageP) {

                       lastMessageP.innerText = '최근 메시지: ' + messageContent;

                   } else {
                       console.error('최근 메시지 element 못 찾음');
                   }

                   chatRoomListContainer.prepend(chatRoomDiv);

                   if (message.senderId != currentUserIdList) {
                       let unreadBadge = chatRoomDiv.querySelector('.unread-count');
                       const currentCount = parseInt(unreadBadge ? unreadBadge.textContent : '0') || 0;
                       const newCount = currentCount + 1;

                       if (!unreadBadge) {
                           unreadBadge = document.createElement('span');
                           unreadBadge.className = 'unread-count';
                           chatRoomDiv.querySelector('.chat-room-link').appendChild(unreadBadge);
                       }
                       unreadBadge.textContent = newCount;
                   }
               }
           }

        function handleReadUpdate(roomId) {
            const chatRoomDiv = document.querySelector(`.chat-room-item[data-room-id="${roomId}"]`);
            if (chatRoomDiv) {
                const unreadBadge = chatRoomDiv.querySelector('.unread-count');
                if (unreadBadge) {
                    unreadBadge.remove();
                }
            }
        }

        window.addEventListener('load', function() {
            connectChatList();
        });

        window.addEventListener('beforeunload', function() {
            if (stompClientList !== null && stompClientList.connected) {
                stompClientList.disconnect();
            }
            isConnectedList = false;
        });
    </script>

</body>
</html>