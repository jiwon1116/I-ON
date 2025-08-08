package com.spring.ion.lcw.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.UUID;

@Controller
public class NaverRegisterController {

    @Autowired
    private MemberService memberService;

    @GetMapping("/naver-register")
    public String showNaverRegisterForm(HttpSession session) {
        if (session.getAttribute("naverId") == null) {
            return "redirect:/login";
        }
        return "naver-register";
    }

    @PostMapping("/naver-register")
    public String registerNaverMember(@RequestParam String nickname, @RequestParam String city, @RequestParam String district, @RequestParam String gender, HttpSession session) {
        String naverId = (String) session.getAttribute("naverId");
        if (naverId == null) {
            return "redirect:/login";
        }

        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setUserId(naverId);
        memberDTO.setPassword(UUID.randomUUID().toString());
        memberDTO.setNickname(nickname);
        memberDTO.setCity(city);
        memberDTO.setDistrict(district);
        memberDTO.setGender(gender);
        memberDTO.setProvider("NAVER");
        memberDTO.setEnabled(true);

        memberService.save(memberDTO);

        MemberDTO newlyRegisteredMember = memberService.findByUserId(naverId);

        CustomUserDetails customUserDetails = new CustomUserDetails(newlyRegisteredMember);

        Authentication authentication = new UsernamePasswordAuthenticationToken(customUserDetails, null, customUserDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);

        session.removeAttribute("naverId");
        return "redirect:/";
    }
}