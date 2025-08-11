package com.spring.ion.lcw.repository;

import com.spring.ion.lcw.dto.ChatRoomDTO;
import com.spring.ion.lcw.dto.MemberDTO;
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

//    비슷한 이름 주의!

//    채팅방 하나만 찾음(들어갈 때 사용)
    public ChatRoomDTO findChatRoomById(Long id) {
        return sql.selectOne("ChatRoom.findChatRoomById", id);
    }
//    채팅방 목록을 찾음
    public List<ChatRoomDTO> findChatRoomsById(Long id) {
        return sql.selectList("ChatRoom.findChatRoomsById", id);
    }
// 채팅방 user1Id, user2id로 찾음
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
}
