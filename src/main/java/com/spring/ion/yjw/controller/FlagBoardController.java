package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.FlagDTO;
import com.spring.ion.yjw.service.FlagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@RequestMapping("/flag")
public class FlagBoardController {
    private final FlagService flagService;


    @GetMapping("save")
    public String saveForm() {
        return "save";
    }

    // 실제 게시글을 DB에 저장 (파일 업로드 포함)
    @PostMapping("/save")
    public String save(@ModelAttribute FlagDTO flagDTO, // ModelAttribute 어노테이션을 사용하여  DTO와 자동 매핑
                       @RequestParam("boardFile") MultipartFile boardFile) throws IOException { // 첨부된 파일 받기
        // 파일이 실제로 첨부되어 있는지 확인

        // 게시글 정보 + 파일 정보를 서비스로 전달
        flagService.save(flagDTO);
        // 저장 후 게시판 목록으로 이동
        return "redirect:/flag/paging";
    }



}
