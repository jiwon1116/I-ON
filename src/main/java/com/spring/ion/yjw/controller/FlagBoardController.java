package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.service.FlagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/flag")
public class FlagBoardController {

    private final FlagService flagService;

//    @GetMapping
//    public String flag() {
//        return "yjw/flag";
//    }

    // 글쓰기 폼 이동
    @GetMapping("write")
    public String writeForm() {
        return "yjw/flagWrite";
    }

    // 글 저장 처리
    @PostMapping("/write")
    public String write(FlagPostDTO flagPostDTO) {
        int writeResult = flagService.write(flagPostDTO);
        if (writeResult > 0) {
            return "redirect:/flag"; // 수정됨: redirect 경로를 /flag로
        } else {
            return "yjw/flagWrite";
        }
    }
    // 게시글 목록 조회
    @GetMapping
    public String findAll(Model model) {
        // DB 에서 모든 회원 리스트 조회
        List<FlagPostDTO> flags = flagService.findAll();
        model.addAttribute("postList", flags);
        return "yjw/flag";
    }



}
