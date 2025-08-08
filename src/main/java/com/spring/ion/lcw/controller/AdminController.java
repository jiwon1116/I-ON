package com.spring.ion.lcw.controller;

import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.service.FlagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class AdminController {
    private final FlagService flagService;

    // 관리자만 볼 수 있는 승인 대기글 목록 (이 메소드만 남김!)
    @GetMapping("/admin")
    public String pendingList(Model model) {
        List<FlagPostDTO> pendingList = flagService.findAllPending();
        model.addAttribute("pendingList", pendingList);
        return "admin";
    }

    // 승인
    @PostMapping("/admin/approve/{id}")
    public String approve(@PathVariable("id") long id) {
        flagService.approvePost(id);
        return "redirect:/admin";
    }

    // 반려(삭제)
    @PostMapping("/admin/reject/{id}")
    public String reject(@PathVariable("id") long id) {
        flagService.rejectPost(id);
        return "redirect:/admin";
    }
}

