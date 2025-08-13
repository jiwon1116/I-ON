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
    private static final int PAGE_LIMIT = 5;
    private static final int BLOCK_LIMIT = 5;
    private final FlagRepository flagRepository;

    public int write(FlagPostDTO flagPostDTO, List<MultipartFile> fileList) throws IOException {
        flagRepository.write(flagPostDTO);
        long postId = flagPostDTO.getId();

        if (fileList != null && !fileList.isEmpty()) {
            for (MultipartFile file : fileList) {
                if (file != null && !file.isEmpty()) {
                    String originalFileName = file.getOriginalFilename();
                    String uuid = UUID.randomUUID().toString();
                    String storedFileName = uuid + "_" + originalFileName;
                    String savePath = "C:/upload/" + storedFileName;

                    file.transferTo(new File(savePath));

                    FlagFileDTO flagFileDTO = new FlagFileDTO();
                    flagFileDTO.setBoard_id(postId);
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

    public FlagPostDTO findById(long id) {
        return flagRepository.findById(id);
    }

    public boolean update(FlagPostDTO flagPostDTO, List<Long> deleteFileIds, MultipartFile newFile) throws IOException {
        FlagPostDTO origin = flagRepository.findById(flagPostDTO.getId());
        if (origin != null && "REJECTED".equals(origin.getStatus())) {
            flagPostDTO.setStatus("PENDING");
        }
        int updated = flagRepository.update(flagPostDTO);

        if (deleteFileIds != null) {
            for (Long fileId : deleteFileIds) flagRepository.deleteFileById(fileId);
        }
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

    public void delete(long id) {
        flagRepository.delete(id);
    }


    public List<FlagPostDTO> pagingList(int page) {
        int pagingStart = (page - 1) * PAGE_LIMIT;
        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", PAGE_LIMIT);
        return flagRepository.pagingList(pagingParams);
    }

    public FlagPageDTO pagingParam(int page) {
        int flagCount = flagRepository.flagCount();
        int maxPage = (int) Math.ceil((double) flagCount / PAGE_LIMIT);
        int currentBlock = (int) Math.ceil((double) page / BLOCK_LIMIT);
        int startPage = (currentBlock - 1) * BLOCK_LIMIT + 1;
        int endPage = Math.min(startPage + BLOCK_LIMIT - 1, maxPage);

        FlagPageDTO dto = new FlagPageDTO();
        dto.setPage(page);
        dto.setStartPage(startPage);
        dto.setEndPage(endPage);
        dto.setMaxPage(maxPage);
        return dto;
    }

    public List<FlagPostDTO> search(String keyword) {
        return flagRepository.search(keyword);
    }

    public void increaseViewCount(int id) {
        flagRepository.increaseViewCount(id);
    }

    public boolean like(Long postId, Long memberId) {
        if (flagRepository.hasLiked(postId, memberId)) return false;
        flagRepository.insertLike(postId, memberId);
        flagRepository.increaseLikeCount(postId.intValue());
        return true;
    }

    public List<FlagFileDTO> findFilesByBoardId(int id) {
        return flagRepository.findFilesByBoardId(id);
    }

    public List<FlagPostDTO> findMyPosts(String userId) {
        return flagRepository.findAllByWriter(userId);
    }

    public List<FlagPostDTO> findAllApproved() {
        return flagRepository.findAllApproved();
    }

    public List<FlagPostDTO> findAllForUser(String userId, boolean isAdmin) {
        return isAdmin ? flagRepository.findAll() : flagRepository.findAllForUser(userId);
    }

    public List<FlagPostDTO> findAllPending() {
        return flagRepository.findAllPending();
    }

    public void approvePost(long id) {
        flagRepository.updateStatus(id, "APPROVED");
    }

    public void rejectPost(long id) {
        flagRepository.updateStatus(id, "REJECTED");
    }

    public List<FlagPostDTO> searchPublicOrMine(String keyword, String loginUserId) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword == null ? "" : keyword.trim());
        params.put("userId", loginUserId);
        return flagRepository.searchPublicOrMine(params);
    }

    public List<FlagPostDTO> pagingListPublicOrMine(int page, String loginUserId) {
        int start = (page - 1) * PAGE_LIMIT;
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("limit", PAGE_LIMIT);
        params.put("userId", loginUserId);
        return flagRepository.pagingListPublicOrMine(params);
    }

    public FlagPageDTO pagingParamPublicOrMine(int page, String loginUserId) {
        int total = flagRepository.flagCountPublicOrMine(loginUserId);
        int maxPage = (int) Math.ceil((double) total / PAGE_LIMIT);
        int currentBlock = (int) Math.ceil((double) page / BLOCK_LIMIT);
        int startPage = (currentBlock - 1) * BLOCK_LIMIT + 1;
        int endPage = Math.min(startPage + BLOCK_LIMIT - 1, maxPage);

        FlagPageDTO dto = new FlagPageDTO();
        dto.setPage(page);
        dto.setStartPage(startPage);
        dto.setEndPage(endPage);
        dto.setMaxPage(maxPage);
        return dto;
    }
}
