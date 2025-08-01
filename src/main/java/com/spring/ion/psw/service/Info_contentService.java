package com.spring.ion.psw.service;

import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.repository.Info_contentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
// 게시물 찾아오는 리스트
public class Info_contentService {
    private final Info_contentRepository infoContentRepository;

    public List<Info_contentDTO> AllfindList() {

        return infoContentRepository.AllfindList();
    }

    // 작성된 글 추가
    public int save(Info_contentDTO infoContentDTO) {
        return infoContentRepository.save(infoContentDTO);

    }

    // 선택한 글 정보 가져오기
    public Info_contentDTO findContext(long id) {
     return infoContentRepository.findContext(id);
    }

    //게시물 수정
    public boolean update(Info_contentDTO infoContentDTO) {
        int num = infoContentRepository.update(infoContentDTO);
        if (num>0){
            return true;
        }else {
            return false;
        }
    }
    // 게시물 삭제
    public void delete(long id) {
        infoContentRepository.delete(id);
    }

    // 조회수 증가
    public void updateHits(long id) {
        infoContentRepository.updateHits(id);
    }

    // 좋아요 수 증가
    public void updateLike(long id) {
        infoContentRepository.updateLike(id);
    }
}
