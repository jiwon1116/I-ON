package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.repository.FlagCommentRepository;
import com.spring.ion.yjw.repository.FlagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FlagCommentService {
    private final FlagCommentRepository flagCommentRepository;


    public List<FlagCommentDTO> findAll(int id) {
        return flagCommentRepository.findAll(id);
    }

    public void write(FlagCommentDTO flagCommentDTO) {
        flagCommentRepository.write(flagCommentDTO);
    }
}
