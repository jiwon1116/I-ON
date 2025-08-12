package com.spring.ion.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    @GetMapping("/")

    public String index(Model model){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
            MemberDTO memberDTO = user.getMemberDTO();

            model.addAttribute("member", memberDTO);
            System.out.println("로그인 멤버 정보: " + memberDTO);

            if(memberDTO != null && memberDTO.getAuthorities() != null && memberDTO.getAuthorities().contains("ROLE_ADMIN")){
                return "admin";
            }
        }
        return "redirect:/mypage/";

    }
}