package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.FlagFileDTO;
import com.spring.ion.yjw.dto.FlagPageDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.repository.FlagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FlagService {
    private final FlagRepository flagRepository;

    public int write(FlagPostDTO flagPostDTO, List<MultipartFile> fileList) throws IOException {
        flagRepository.write(flagPostDTO); // 이 시점에 flagPostDTO.getId()에 게시글 id가 들어옴!

        long postId = flagPostDTO.getId(); // 바로 사용 가능

        if (!fileList.isEmpty()) {
            for (MultipartFile file : fileList) {
                if (!file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String uuid = UUID.randomUUID().toString();
                    String storedFileName = uuid + "_" + originalFileName;
                    String savePath = "C:/upload/" + storedFileName;

                    file.transferTo(new File(savePath));

                    FlagFileDTO flagFileDTO = new FlagFileDTO();
                    flagFileDTO.setBoard_id(postId); // 정확한 게시글 ID로 설정
                    flagFileDTO.setOriginalFileName(originalFileName);
                    flagFileDTO.setStoredFileName(storedFileName);

                    flagRepository.saveFile(flagFileDTO);
                }
            }
        }

        return (int) postId;
    }



    public List<FlagPostDTO> findAll() {
        return flagRepository.findAll();
    }

    public FlagPostDTO findById(int id) {
        return flagRepository.findById(id);
    }

    public boolean update(FlagPostDTO flagPostDTO, List<Long> deleteFileIds, MultipartFile newFile) throws IOException {
        int updated = flagRepository.update(flagPostDTO);

        // 파일 삭제 처리
        if (deleteFileIds != null) {
            for (Long fileId : deleteFileIds) {
                flagRepository.deleteFileById(fileId);
            }
        }

        // 새 파일 추가
        if (newFile != null && !newFile.isEmpty()) {
            String originalFileName = newFile.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String storedFileName = uuid + "_" + originalFileName;
            String savePath = "C:/upload/" + storedFileName;

            newFile.transferTo(new File(savePath));

            FlagFileDTO flagFileDTO = new FlagFileDTO();
            flagFileDTO.setBoard_id(flagPostDTO.getId());
            flagFileDTO.setOriginalFileName(originalFileName);
            flagFileDTO.setStoredFileName(storedFileName);

            flagRepository.saveFile(flagFileDTO);
        }

        return updated > 0;
    }


    public void delete(int id) {
        flagRepository.delete(id);
    }

    public List<FlagPostDTO> pagingList(int page) {
        int pageLimit = 5; // 1페이지 당 5개
        int blockLimit = 5; // 하단에 보여줄 페이지 번호 갯수

        int pagingStart = (page - 1) * pageLimit;

        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        List<FlagPostDTO> pagingList = flagRepository.pagingList(pagingParams);
        return pagingList;
    }

    public FlagPageDTO pagingParam(int page) {
        int flagCount = flagRepository.flagCount(); // 전체 글 개수
        int pageLimit = 5; // 한 페이지에 보여줄 글 수
        int blockLimit = 5; // 하단에 보여줄 페이지 수

        int maxPage = (int) Math.ceil((double) flagCount / pageLimit);
        int currentBlock = (int) Math.ceil((double) page / blockLimit);
        int startPage = (currentBlock - 1) * blockLimit + 1;
        int endPage = startPage + blockLimit - 1;

        if (endPage > maxPage) {
            endPage = maxPage;
        }

        FlagPageDTO flagPageDTO = new FlagPageDTO();
        flagPageDTO.setPage(page);
        flagPageDTO.setStartPage(startPage);
        flagPageDTO.setEndPage(endPage);
        flagPageDTO.setMaxPage(maxPage);

        return flagPageDTO;
    }


    public List<FlagPostDTO> search(String keyword) {
        return flagRepository.search(keyword);
    }

    public void increaseViewCount(int id) {
        flagRepository.increaseViewCount(id);
    }


    public boolean like(Long postId, Long memberId) {
        if (flagRepository.hasLiked(postId, memberId)) {
            return false; // 이미 좋아요 눌렀음
        }

        flagRepository.insertLike(postId, memberId);
        flagRepository.increaseLikeCount(postId.intValue());
        return true;
    }

    public List<FlagFileDTO> findFilesByBoardId(int id) {
        return flagRepository.findFilesByBoardId(id);
    }
}

