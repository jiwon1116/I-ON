package com.spring.ion.jjh.service.entrust;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.entrust.EntrustDTO;
import com.spring.ion.jjh.dto.entrust.EntrustFileDTO;
import com.spring.ion.jjh.repository.entrust.EntrustRepository;
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
public class EntrustService {
    private final EntrustRepository entrustRepository;

    int pageLimit = 5;
    int blockLimit = 3;

    public List<EntrustDTO> allEntrustList() {
        return entrustRepository.allEntrustList();
    }

    public int write(EntrustDTO entrustDTO, List<MultipartFile> uploadFiles) {
        int result = entrustRepository.write(entrustDTO);
        if (result > 0 && uploadFiles != null && !uploadFiles.isEmpty()) {
            String uploadDir = "C:/upload/entrust";
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

                        EntrustFileDTO fileDTO = new EntrustFileDTO();
                        fileDTO.setBoard_id(entrustDTO.getId());
                        fileDTO.setOriginalFileName(originalName);
                        fileDTO.setStoredFileName(storedName);

                        entrustRepository.saveFile(fileDTO);

                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return result;
    }



    public EntrustDTO findById(long clickId) {
        return entrustRepository.findById(clickId);
    }


    public void delete(long clickId) {
        entrustRepository.delete(clickId);
    }

    public boolean update(EntrustDTO entrustDTO, MultipartFile file) {
        int result = entrustRepository.update(entrustDTO);
        if (result > 0) {
            if (file != null && !file.isEmpty()) {
                entrustRepository.deleteFileById(entrustDTO.getId());

                String uploadDir = "C:/upload/entrust";
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                try {
                    String originalName = file.getOriginalFilename();
                    String storedName = UUID.randomUUID().toString() + "_" + originalName;
                    Path savePath = Paths.get(uploadDir, storedName);
                    file.transferTo(savePath.toFile());

                    EntrustFileDTO fileDTO = new EntrustFileDTO();
                    fileDTO.setBoard_id(entrustDTO.getId());
                    fileDTO.setOriginalFileName(originalName);
                    fileDTO.setStoredFileName(storedName);

                    entrustRepository.saveFile(fileDTO);
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

    public List<EntrustDTO> pagingList(int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        List<EntrustDTO> pagingList = entrustRepository.pagingList(pagingParams);

        return pagingList;
    }

    public PageDTO pagingParam(int page) {
        int boardCount = entrustRepository.boardCount();
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
        entrustRepository.updateViewCount(clickId);
    }


    public List<EntrustFileDTO> findFileById(long clickId) {
        return entrustRepository.findFileById(clickId);
    }

    public List<EntrustDTO> searchPagingList(String searchContent, int page) {
        int pagingStart = (page - 1) * pageLimit;
        return entrustRepository.searchPagingList(searchContent, pagingStart, pageLimit);
    }

    public PageDTO searchPagingParam(String searchContent, int page) {
        int boardCount = entrustRepository.searchCount(searchContent);
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

    public List<EntrustDTO> findMyPosts(String userId) {
        return entrustRepository.findAllByWriter(userId);
    }
}
