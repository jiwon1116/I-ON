package com.spring.ion.psw.service;

import com.spring.ion.psw.dto.Info_FileDTO;
import com.spring.ion.psw.dto.Info_PageDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.repository.Info_contentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    int pageLimit = 6; // 1페이지 당 5개
    int blockLimit = 5; // 하단에 보여줄 페이지 번호 갯수

    // 페이지 코드
    public List<Info_contentDTO> pagingList(int page) {

        int pagingStart = (page - 1) * pageLimit;

        // 페이징 시작 위치(start)와 가져올 개수 (limit)를 저장하는 map 생성
        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        // 페이징 처리된 게시글 목록 반환
        List<Info_contentDTO> pagingList = infoContentRepository.pagingList(pagingParams);
        return pagingList;
    }

    // 페이징에 필요한 정보 계산
    public Info_PageDTO pagingParam(int page) {
        int infoCount = infoContentRepository.infoCount(); // 전체 글 개수
    // 전체 글 수
        int maxPage = (int) Math.ceil((double) infoCount / pageLimit);
        int currentBlock = (int) Math.ceil((double) page / blockLimit);
        int startPage = (currentBlock - 1) * blockLimit + 1;
        int endPage = startPage + blockLimit - 1;

        if (endPage > maxPage) {
            endPage = maxPage;
        }

        Info_PageDTO infoPage = new Info_PageDTO();
        infoPage.setPage(page);
        infoPage.setStartPage(startPage);
        infoPage.setEndPage(endPage);
        infoPage.setMaxPage(maxPage);

        return infoPage;
    }

    // 이미지 파일 저장
    public void saveFile(Info_FileDTO infoFileDTO) {
        infoContentRepository.saveFile(infoFileDTO);
    }

    // 이미지 파일 가져오기
    public Info_FileDTO findFile(Long boardId) {
    return infoContentRepository.findFile(boardId);

    }

    // 이미지 수정하기
    public void updateFile(Info_FileDTO infoFileDTO) {
        infoContentRepository.update(infoFileDTO);


    }
}
