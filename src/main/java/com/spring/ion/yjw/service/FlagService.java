package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.FlagPageDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.repository.FlagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class FlagService {
    private final FlagRepository flagRepository;

    public int write(FlagPostDTO flag_postDTO) {
        return flagRepository.write(flag_postDTO);
    }

    public List<FlagPostDTO> findAll() {
        return flagRepository.findAll();
    }

    public FlagPostDTO findById(int id) {
        return flagRepository.findById(id);
    }

    public boolean update(FlagPostDTO flagPostDTO) {
        int num = flagRepository.update(flagPostDTO);
        return num > 0;
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

}

