package com.spring.ion.lcw.repository;

import com.spring.ion.lcw.dto.MessageDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MessageRepository {
    private final SqlSessionTemplate sql;

    public void saveMessage(MessageDTO messageDTO){
        sql.insert("Message.insertMessage", messageDTO);
    }

    public MessageDTO findMessageById(Long id){
        return sql.selectOne("Message.findMessageById", id);
    }
    public List<MessageDTO> findMessagesByRoomId(Long roomId) {
        return sql.selectList("Message.findMessagesByRoomId", roomId);
    }
}
