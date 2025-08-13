package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.repository.FlagCommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FlagCommentService {
    private final FlagCommentRepository flagCommentRepository;


    public List<FlagCommentDTO> findAll(long postId) {
        return flagCommentRepository.findAll(postId);
    }

    public void write(FlagCommentDTO flagCommentDTO) {
        flagCommentRepository.write(flagCommentDTO);
    }

    public int delete(long id) {
        return flagCommentRepository.delete(id);
    }


    public FlagCommentDTO findById(long id) {
        return flagCommentRepository.findById(id);
    }

    public List<FlagCommentDTO> findMyComments(String userId) {
        return flagCommentRepository.findAllByUserId(userId);
    }
}
