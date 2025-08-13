package com.spring.ion.jjh.service.miss;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.entrust.EntrustDTO;
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

    int pageLimit = 5;
    int blockLimit = 3;

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
                        fileDTO.setBoard_id(missDTO.getId());
                        fileDTO.setOriginalFileName(originalName);
                        fileDTO.setStoredFileName(storedName);

                        missRepository.saveFile(fileDTO);

                    } catch (IOException e) {
                        e.printStackTrace();
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
            if (file != null && !file.isEmpty()) {
                missRepository.deleteFileById(missDTO.getId());

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

        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        List<MissDTO> pagingList = missRepository.pagingList(pagingParams);

        return pagingList;
    }

    public PageDTO pagingParam(int page) {
        int boardCount = missRepository.boardCount();
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

    public List<MissDTO> findMyPosts(String userId) {
        return missRepository.findAllByWriter(userId);
    }
}
