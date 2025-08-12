package com.spring.ion.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    @GetMapping("/")
    public String index(Model model){
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);
        System.out.println("로그인 멤버 정보: " + memberDTO);
        if(memberDTO.getAuthorities().contains("ROLE_ADMIN")){
            return "admin";
        }

        return "/mypage";
    }
}
