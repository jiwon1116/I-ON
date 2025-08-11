package com.spring.ion.lcw.controller;

import com.spring.ion.lcw.dto.MessageDTO;
import com.spring.ion.lcw.service.ChatRoomService;
import com.spring.ion.lcw.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@RequiredArgsConstructor
@Controller
public class MessageController {
    private final SimpMessagingTemplate messagingTemplate;
    private final MessageService messageService;
    private final ChatRoomService chatRoomService;


    @MessageMapping("/chat/send")
    public void sendMessage(MessageDTO message) {
        message.setIsRead(false);
        chatRoomService.updateLastMessage(message.getRoomId(), message.getContent());
        messageService.saveMessage(message);
        chatRoomService.incrementUnreadCount(message.getRoomId(), message.getSenderId());
        messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoomId(), message);
        messagingTemplate.convertAndSend("/sub/chat/roomList", message);
    }
}