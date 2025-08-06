package com.spring.ion.jjh.service.miss;

import com.spring.ion.jjh.dto.miss.MissCommentDTO;
import com.spring.ion.jjh.repository.miss.MissCommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MissCommentService {
    private final MissCommentRepository missCommentRepository;

    public void save(MissCommentDTO commentDTO) {
        missCommentRepository.save(commentDTO);
    }

    public List<MissCommentDTO> findAll(long postId) {
        return missCommentRepository.findAll(postId);
    }

    public MissCommentDTO findById(long id) {
        return missCommentRepository.findById(id);
    }

    public void delete(long id) {
        missCommentRepository.delete(id);
    }

    public List<MissCommentDTO>  findMyComments(String userId) {
        return missCommentRepository.findAllByUserId(userId);
    }
}
