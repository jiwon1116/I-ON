package com.spring.ion.lcw.controller;

import com.spring.ion.lcw.dto.ChatRoomDTO;
import com.spring.ion.lcw.dto.MessageDTO;
import com.spring.ion.lcw.service.ChatRoomService;
import com.spring.ion.lcw.service.MessageService;
import com.spring.ion.lcw.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.security.Principal;
import java.time.format.DateTimeFormatter; // ❗ 추가
import java.time.LocalDateTime; // ❗ 추가

@RequiredArgsConstructor
@Controller
public class MessageController {
    private final SimpMessagingTemplate messagingTemplate;
    private final MessageService messageService;
    private final ChatRoomService chatRoomService;
    private final MemberService memberService;

    public static Map<Long, Long> activeUsers = new ConcurrentHashMap<>();

    @MessageMapping("/chat/send")
    public void sendMessage(MessageDTO message) {
        message.setIsRead(false);
        chatRoomService.updateLastMessage(message.getRoomId(), message.getContent());
        MessageDTO sentMessage = messageService.saveMessage(message);

        LocalDateTime createdAt = sentMessage.getCreatedAt();
        if (createdAt != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm");
            String formattedDate = createdAt.format(formatter);
            sentMessage.setFormattedCreatedAt(formattedDate);
        }

        ChatRoomDTO chatRoom = chatRoomService.findChatRoomById(message.getRoomId());
        if (chatRoom == null) {
            return;
        }

        Long partnerId = chatRoom.getUser1Id().equals(message.getSenderId()) ? chatRoom.getUser2Id() : chatRoom.getUser1Id();

        boolean isPartnerInRoom = activeUsers.containsKey(partnerId)
                && activeUsers.get(partnerId).equals(message.getRoomId());

        if (!isPartnerInRoom) {
            chatRoomService.incrementUnreadCount(message.getRoomId(), message.getSenderId());
        }

        messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoomId(), sentMessage);

        messagingTemplate.convertAndSend("/sub/chat/user/" + partnerId, sentMessage);
        messagingTemplate.convertAndSend("/sub/chat/user/" + message.getSenderId(), sentMessage);


        String partnerPrincipalName = memberService.findById(partnerId).getNickname();
        String senderPrincipalName = memberService.findById(message.getSenderId()).getNickname();
        messagingTemplate.convertAndSendToUser(partnerPrincipalName, "/sub/chat/user/" + partnerId, sentMessage);
        messagingTemplate.convertAndSendToUser(senderPrincipalName, "/sub/chat/user/" + message.getSenderId(), sentMessage);
    }
}