package com.spring.ion.lcw.repository;

import com.spring.ion.lcw.dto.ChatRoomDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@Repository
public class ChatRoomRepository {
    public final SqlSessionTemplate sql;

    public void insertChatRoom(ChatRoomDTO chatRoomDTO) {
        sql.insert("ChatRoom.insertChatRoom", chatRoomDTO);
    }

    public ChatRoomDTO findChatRoomById(Long id) {
        return sql.selectOne("ChatRoom.findChatRoomById", id);
    }

    public List<ChatRoomDTO> findChatRoomsById(Long id) {
        return sql.selectList("ChatRoom.findChatRoomsById", id);
    }

    public ChatRoomDTO findChatRoomByIds(Long user1Id, Long user2Id) {
        return sql.selectOne("ChatRoom.findChatRoomByIds", Map.of("user1Id", user1Id, "user2Id", user2Id));
    }

    public void setZeroUnreadCount(Long roomId, Long currentUserId) {
        sql.update("ChatRoom.setZeroUnreadCount", Map.of("roomId", roomId, "currentUserId", currentUserId));
    }

    public void incrementUnreadCount(Long roomId, Long senderId) {
        sql.update("ChatRoom.incrementUnreadCount", Map.of("roomId", roomId, "senderId", senderId));
    }

    public void updateLastMessage(Long roomId, String lastMessage) {
        sql.update("ChatRoom.updateLastMessage", Map.of("roomId", roomId, "lastMessage", lastMessage));
    }

    public int calculateTotalUnreadCount(Long currentUserId) {
        Integer totalCount = sql.selectOne("ChatRoom.calculateTotalUnreadCount", currentUserId);
        return totalCount != null ? totalCount : 0;
    }
}
