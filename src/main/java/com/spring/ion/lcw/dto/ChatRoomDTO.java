package com.spring.ion.lcw.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatRoomDTO {
    private Long id;
    private Long user1Id;
    private Long user2Id;
    private String lastMessage;
    private int user1UnreadCount;
    private int user2UnreadCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String partnerNickname;
}
