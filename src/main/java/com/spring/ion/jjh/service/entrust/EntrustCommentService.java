package com.spring.ion.jjh.service.entrust;

import com.spring.ion.jjh.dto.entrust.EntrustCommentDTO;
import com.spring.ion.jjh.repository.entrust.EntrustCommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EntrustCommentService {
    private final EntrustCommentRepository entrustCommentRepository;

    public void save(EntrustCommentDTO commentDTO) {
        entrustCommentRepository.save(commentDTO);
    }

    public List<EntrustCommentDTO> findAll(long postId) {
        return entrustCommentRepository.findAll(postId);
    }

    public EntrustCommentDTO findById(long id) {
        return entrustCommentRepository.findById(id);
    }

    public void delete(long id) {
        entrustCommentRepository.delete(id);
    }

    public List<EntrustCommentDTO>  findMyComments(String nickname) {
        return entrustCommentRepository.findAllByUserId(nickname);
    }
}
