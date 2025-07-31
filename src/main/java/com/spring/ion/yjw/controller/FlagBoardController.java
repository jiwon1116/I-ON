package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.FlagDTO;
import com.spring.ion.yjw.service.FlagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@RequestMapping("/flag")
public class FlagBoardController {
    private final FlagService flagService;

    @GetMapping
    public String flag() {
        return "yjw/flag"; // 또는 "flag/list", 혹은 게시글 보여주는 JSP
    }

    @GetMapping("/list")
    public String listPage(Model model) {
        List<FlagDTO> flagList = flagService.findAll(); // 게시글 전부 불러오기
        model.addAttribute("postList", flagList);       // jsp에서 꺼낼 수 있도록 담아줌
        return "yjw/flag"; // => /WEB-INF/views/yjw/flag.jsp
    }

    @GetMapping("save")
    public String saveForm() {
        return "yjw/flagWrite";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute FlagDTO flagDTO,
                       @RequestParam(value = "boardFile", required = false) MultipartFile boardFile,
                       HttpSession session) throws IOException {

        // 닉네임 세션에서 가져오기
        String nickname = (String) session.getAttribute("loginNickname");
        flagDTO.setNickname(nickname); // DTO에 setNickname 필요

        // 파일이 첨부된 경우 처리
        if (!boardFile.isEmpty()) {
            // 원본 파일명
            String originalFileName = boardFile.getOriginalFilename();

            // 고유한 파일명을 위한 UUID 생성
            String uuid = UUID.randomUUID().toString();

            // 서버에 저장될 파일명
            String storedFileName = uuid + "_" + originalFileName;

            // 실제 파일 저장 경로
            String savePath = "C:/upload/" + storedFileName;
            boardFile.transferTo(new File(savePath));

            // DTO에 파일 정보 저장 (필요시 DTO에 필드 추가해야 함)
            flagDTO.setOriginalFileName(originalFileName);
            flagDTO.setStoredFileName(storedFileName);
        }

        // 서비스 호출하여 DB 저장
        flagService.save(flagDTO);

        // 저장 후 목록 페이지로 이동
        return "redirect:/flag";
    }







}
