package com.spring.ion.psw.service;

import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.repository.Info_commentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class Info_commentService {
    private final Info_commentRepository infoCommentRepository;

    // 댓글 저장
    public void save(Info_commentDTO infoCommentDTO) {
        infoCommentRepository.save(infoCommentDTO);
    }

    // 댓글 찾기
    public List<Info_commentDTO> findAll(long postId) {
        return infoCommentRepository.findAll(postId);
    }

    // 댓글 삭제하기
    public void delete(Info_commentDTO infoCommentDTO) {
        infoCommentRepository.commentDelete(infoCommentDTO);
    }
    // 모든 댓글 가져오기
    public List<Info_commentDTO> findAllComment(){
        return infoCommentRepository.findAllComment();
    }

}
