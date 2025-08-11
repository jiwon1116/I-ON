package com.spring.ion.lcw.service;

import com.spring.ion.lcw.dto.ChatRoomDTO;
import com.spring.ion.lcw.repository.ChatRoomRepository;
import com.spring.ion.lcw.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ChatRoomService {
    private final ChatRoomRepository chatRoomRepository;

    public void insertChatRoom(ChatRoomDTO chatRoomDTO) {
        chatRoomRepository.insertChatRoom(chatRoomDTO);
    }

    public List<ChatRoomDTO> findChatRoomsById(Long id){
       return chatRoomRepository.findChatRoomsById(id);
    }

    public ChatRoomDTO findChatRoomByIds(Long user1Id, Long user2Id) {
       return chatRoomRepository.findChatRoomByIds(user1Id, user2Id);
    }

    public ChatRoomDTO findChatRoomById(Long id) {
        return chatRoomRepository.findChatRoomById(id);
    }

    public void setZeroUnreadCount(Long roomId, Long currentUserId) {
        chatRoomRepository.setZeroUnreadCount(roomId, currentUserId);
    }

    public void incrementUnreadCount(Long roomId, Long senderId) {
        chatRoomRepository.incrementUnreadCount(roomId, senderId);
    }

    public void updateLastMessage(Long roomId, String lastMessage) {
        chatRoomRepository.updateLastMessage(roomId, lastMessage);
    }

    public int calculateTotalUnreadCount(Long currentUserId) {
       return chatRoomRepository.calculateTotalUnreadCount(currentUserId);
    }
}
