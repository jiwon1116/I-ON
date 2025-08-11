package com.spring.ion.lcw.service;

import com.spring.ion.lcw.dto.MessageDTO;
import com.spring.ion.lcw.repository.MessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MessageService {
    private final MessageRepository messageRepository;


    public MessageDTO saveMessage(MessageDTO messageDTO) {
        messageRepository.saveMessage(messageDTO);
        return messageRepository.findMessageById(messageDTO.getId());
    }

    public List<MessageDTO> findMessagesByRoomid(Long roomId){
        return messageRepository.findMessagesByRoomId(roomId);
    }
}
