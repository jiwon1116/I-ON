package com.spring.ion.jjh.service.miss;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.miss.MissDTO;
import com.spring.ion.jjh.dto.miss.MissFileDTO;
import com.spring.ion.jjh.repository.miss.MissRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
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
public class MissService {
    private final MissRepository missRepository;

    int pageLimit = 5; // 1 페이지당 3개
    int blockLimit = 3; // 하단에 보여줄 페이지 번호 갯수 (보통 5 ~ 10개)

    public List<MissDTO> allMissList() {
        return missRepository.allMissList();
    }

    public int write(MissDTO missDTO, List<MultipartFile> uploadFiles) {
        int result = missRepository.write(missDTO);
        if (result > 0 && uploadFiles != null && !uploadFiles.isEmpty()) {
            String uploadDir = "C:/upload/miss";
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

                        MissFileDTO fileDTO = new MissFileDTO();
                        fileDTO.setBoard_id(missDTO.getId());  // selectKey로 insert 전 id 생성 필요
                        fileDTO.setOriginalFileName(originalName);
                        fileDTO.setStoredFileName(storedName);

                        missRepository.saveFile(fileDTO);

                    } catch (IOException e) {
                        e.printStackTrace(); // 필요시 로깅 또는 예외 던지기
                    }
                }
            }
        }
        return result;
    }



    public MissDTO findById(long clickId) {
        return missRepository.findById(clickId);
    }


    public void delete(long clickId) {
        missRepository.delete(clickId);
    }

    public boolean update(MissDTO missDTO, MultipartFile file) {
        int result = missRepository.update(missDTO);
        if (result > 0) {
            // 파일이 넘어왔고 비어 있지 않으면
            if (file != null && !file.isEmpty()) {
                // 1. 기존 파일 삭제
                missRepository.deleteFileById(missDTO.getId());

                // 2. 새 파일 저장
                String uploadDir = "C:/upload/miss";
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                try {
                    String originalName = file.getOriginalFilename();
                    String storedName = UUID.randomUUID().toString() + "_" + originalName;
                    Path savePath = Paths.get(uploadDir, storedName);
                    file.transferTo(savePath.toFile());

                    MissFileDTO fileDTO = new MissFileDTO();
                    fileDTO.setBoard_id(missDTO.getId());
                    fileDTO.setOriginalFileName(originalName);
                    fileDTO.setStoredFileName(storedName);

                    missRepository.saveFile(fileDTO);
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

    public List<MissDTO> pagingList(int page) {
        int pagingStart = (page - 1) * pageLimit;

        // 페이징 시작 위치(start)와 가져올 개수(limit)를 저장
        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        // 페이징 처리된 게시글 목록 반환
        List<MissDTO> pagingList = missRepository.pagingList(pagingParams);

        return pagingList;
    }

    public PageDTO pagingParam(int page) {
        // 전체 글의 수 확인
        int boardCount = missRepository.boardCount();
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
        missRepository.updateViewCount(clickId);
    }


    public List<MissFileDTO> findFileById(long clickId) {
        return missRepository.findFileById(clickId);
    }


    public List<MissDTO> searchPagingList(String searchContent, int page) {
        int pagingStart = (page - 1) * pageLimit;
        return missRepository.searchPagingList(searchContent, pagingStart, pageLimit);
    }

    public PageDTO searchPagingParam(String searchContent, int page) {
        int boardCount = missRepository.searchCount(searchContent);
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
}
