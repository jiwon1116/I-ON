package com.spring.ion.lcw.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ErrorController {

    @GetMapping("/accessDenied")
    public String accessDenied(Model model) {
        model.addAttribute("msg", "현재 등급은 [일반회원]입니다. 자녀의 재학증명서를 등록하시면 모든 게시판을 사용하실 수 있습니다.");
        model.addAttribute("url", "/mypage");
        return "accessDenied";
    }
}