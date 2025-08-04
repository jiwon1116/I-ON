package com.spring.ion.jjh.service.free;

import com.spring.ion.jjh.dto.free.FreeCommentDTO;
import com.spring.ion.jjh.repository.free.FreeCommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FreeCommentService {
    private final FreeCommentRepository freeCommentRepository;

    public void save(FreeCommentDTO commentDTO) {
        freeCommentRepository.save(commentDTO);
    }

    public List<FreeCommentDTO> findAll(long postId) {
        return freeCommentRepository.findAll(postId);
    }

    public FreeCommentDTO findById(long id) {
        return freeCommentRepository.findById(id);
    }

    public void delete(long id) {
        freeCommentRepository.delete(id);
    }
}
