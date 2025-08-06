package com.spring.ion.jjh.service.free;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.free.FreeDTO;
import com.spring.ion.jjh.dto.free.FreeFileDTO;
import com.spring.ion.jjh.repository.free.FreeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FreeService {
    private final FreeRepository freeRepository;

    int pageLimit = 5; // 1 페이지당 3개
    int blockLimit = 3; // 하단에 보여줄 페이지 번호 갯수 (보통 5 ~ 10개)

    public List<FreeDTO> allFreeList() {
        return freeRepository.allFreeList();
    }

    public int write(FreeDTO freeDTO, List<MultipartFile> uploadFiles) {
        int result = freeRepository.write(freeDTO);
        if (result > 0 && uploadFiles != null && !uploadFiles.isEmpty()) {
            String uploadDir = "C:/upload/free";
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            for (MultipartFile file : uploadFiles) {
                if (!file.isEmpty()) {
                    try {
                        String originalName = file.getOriginalFilename();
                        String storedName = UUID.randomUUID().toString() + "_" + originalName;
                        Path savePath = Paths.get(uploadDir, storedName);
                        file.transferTo(savePath.toFile());

                        FreeFileDTO fileDTO = new FreeFileDTO();
                        fileDTO.setBoard_id(freeDTO.getId());  // selectKey로 insert 전 id 생성 필요
                        fileDTO.setOriginalFileName(originalName);
                        fileDTO.setStoredFileName(storedName);

                        freeRepository.saveFile(fileDTO);

                    } catch (IOException e) {
                        e.printStackTrace(); // 필요시 로깅 또는 예외 던지기
                    }
                }
            }
        }
        return result;
    }



    public FreeDTO findById(long clickId) {
        return freeRepository.findById(clickId);
    }


    public void delete(long clickId) {
        freeRepository.delete(clickId);
    }

    public boolean update(FreeDTO freeDTO, MultipartFile file) {
        int result = freeRepository.update(freeDTO);
        if (result > 0) {
            // 파일이 넘어왔고 비어 있지 않으면
            if (file != null && !file.isEmpty()) {
                // 1. 기존 파일 삭제
                freeRepository.deleteFileById(freeDTO.getId());

                // 2. 새 파일 저장
                String uploadDir = "C:/upload/free";
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                try {
                    String originalName = file.getOriginalFilename();
                    String storedName = UUID.randomUUID().toString() + "_" + originalName;
                    Path savePath = Paths.get(uploadDir, storedName);
                    file.transferTo(savePath.toFile());

                    FreeFileDTO fileDTO = new FreeFileDTO();
                    fileDTO.setBoard_id(freeDTO.getId());
                    fileDTO.setOriginalFileName(originalName);
                    fileDTO.setStoredFileName(storedName);

                    freeRepository.saveFile(fileDTO);
                } catch (IOException e) {
                    e.printStackTrace();
                    return false;
                }
            }

            return true;
        } else {
            return false;
        }
    }

    public List<FreeDTO> pagingList(int page) {
        int pagingStart = (page - 1) * pageLimit;

        // 페이징 시작 위치(start)와 가져올 개수(limit)를 저장
        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        // 페이징 처리된 게시글 목록 반환
        List<FreeDTO> pagingList = freeRepository.pagingList(pagingParams);

        return pagingList;
    }

    public PageDTO pagingParam(int page) {
        // 전체 글의 수 확인
        int boardCount = freeRepository.boardCount();
        // 전체 페이지 계산
        // 예 : 전체 글 10, 페이지당 3개씩 -> 10/3 -> 3.333333 ceil(올림처리) -> 4페이지
        int maxPage = (int) Math.ceil((double) boardCount / pageLimit);
        // 시작 페이지 값 계산
        // 예 : 현재 페이지가 1 ~ 3 이면 startPage -> 1
        //      현재 페이지가 4 ~ 5 이면 startPage -> 2
        int startPage = (((int) (Math.ceil((double) page / blockLimit))) - 1) * blockLimit + 1;

        // 끝 페이지 번호 계산
        int endPage = startPage + blockLimit - 1;
        // 실제 전체 페이지 수보다 끝 페이지 수가 더 크면 실제 전체 페이지 수로 변경
        if (endPage > maxPage) {
            endPage = maxPage;
        }

        PageDTO pageDTO = new PageDTO();
        pageDTO.setPage(page);
        pageDTO.setMaxPage(maxPage);
        pageDTO.setStartPage(startPage);
        pageDTO.setEndPage(endPage);
        return pageDTO;
    }

    public void updateViewCount(long clickId) {
        freeRepository.updateViewCount(clickId);
    }


    public List<FreeFileDTO> findFileById(long clickId) {
        return freeRepository.findFileById(clickId);
    }

    public List<FreeDTO> searchPagingList(String searchContent, int page) {
        int pagingStart = (page - 1) * pageLimit;
        return freeRepository.searchPagingList(searchContent, pagingStart, pageLimit);
    }

    public PageDTO searchPagingParam(String searchContent, int page) {
        int boardCount = freeRepository.searchCount(searchContent);
        int maxPage = (int) Math.ceil((double) boardCount / pageLimit);
        int startPage = (((int) (Math.ceil((double) page / blockLimit))) - 1) * blockLimit + 1;
        int endPage = startPage + blockLimit - 1;
        if (endPage > maxPage) {
            endPage = maxPage;
        }

        PageDTO pageDTO = new PageDTO();
        pageDTO.setPage(page);
        pageDTO.setMaxPage(maxPage);
        pageDTO.setStartPage(startPage);
        pageDTO.setEndPage(endPage);

        return pageDTO;
    }

    public List<FreeDTO> findMyPosts(String nickname) {
        return freeRepository.findAllByWriter(nickname);
    }
}
