package com.spring.ion.lcw.controller;

import com.spring.ion.yjw.dto.FlagPostDTO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class AdminController {
    @GetMapping("/admin")
    public String showAdminPage() {
        return "admin";
    }

//    // 관리자만 볼 수 있는 승인 대기글 목록
//    @GetMapping("/admin/pending")
//    public String pendingList(Model model) {
//        List<FlagPostDTO> pendingList = flagService.findAllPending();
//        model.addAttribute("pendingList", pendingList);
//        return "yjw/flagAdminPending"; // 이 JSP에서 승인/삭제 버튼 구현
//    }


}
