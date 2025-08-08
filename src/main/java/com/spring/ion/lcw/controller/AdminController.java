package com.spring.ion.lcw.controller;

import com.spring.ion.psw.service.NotifyService;
import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.service.FlagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class AdminController {
    private final FlagService flagService;
    private final NotifyService notifyService;

    // 관리자만 볼 수 있는 승인 대기글 목록 (이 메소드만 남김!)
    @GetMapping("/admin")
    public String pendingList(Model model) {
        List<FlagPostDTO> pendingList = flagService.findAllPending(); // 승인 대기 글 가져오기
        model.addAttribute("pendingList", pendingList);
        return "admin";
    }

    // 승인 게시물
    @PostMapping("/admin/approve/{id}")
    public String approve(@PathVariable("id") long id) {
        flagService.approvePost(id); // 승인 상태로 변경
        FlagPostDTO flagPost = flagService.findById(id); // id에 해당하는 flag글 찾기

        String city = flagPost.getCity(); // 제보글 시/도
        String district = flagPost.getDistrict(); // 구/군

        System.out.println("글 작성자:"+ flagPost.getNickname());
        System.out.println("글 아이디:"+ flagPost.getId());
        System.out.println("제보글 시/도:"+ city);
        System.out.println("제보글 구/군:"+district);

        // 알림 저장
        notifyService.createDangerNotify(flagPost.getNickname(),flagPost.getId(),city,district,"flag");


        return "redirect:/admin";
    }

    // 반려(삭제)
    @PostMapping("/admin/reject/{id}")
    public String reject(@PathVariable("id") long id) {
        flagService.rejectPost(id);
        return "redirect:/admin";
    }
}

