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

    int pageLimit = 5;
    int blockLimit = 3;

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
                        fileDTO.setBoard_id(freeDTO.getId());
                        fileDTO.setOriginalFileName(originalName);
                        fileDTO.setStoredFileName(storedName);

                        freeRepository.saveFile(fileDTO);

                    } catch (IOException e) {
                        e.printStackTrace();
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
            if (file != null && !file.isEmpty()) {
                freeRepository.deleteFileById(freeDTO.getId());

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

        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        List<FreeDTO> pagingList = freeRepository.pagingList(pagingParams);

        return pagingList;
    }

    public PageDTO pagingParam(int page) {
        int boardCount = freeRepository.boardCount();
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

    public List<FreeDTO> findMyPosts(String userId) {
        return freeRepository.findAllByWriter(userId);
    }
}
