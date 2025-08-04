package com.spring.ion.lcw.controller;

//import com.spring.ion.lcw.service.MemberService;
import com.spring.ion.lcw.dto.CustomUserDetails;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.service.MemberService;
import com.spring.ion.lcw.service.ReCaptchaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class MemberController {
    @Autowired
    private MemberService memberService;

    @Autowired
    private PasswordEncoder passwordEncoder;

//    @Autowired
//    private ReCaptchaService reCaptchaService;

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register( MemberDTO memberDTO) {

        String encodedPassword = passwordEncoder.encode(memberDTO.getPassword());
        memberDTO.setPassword(encodedPassword);
        memberDTO.setEnabled(true);
        memberService.save(memberDTO);
        return "redirect:/login";
    }

//    @PostMapping("/register")
//    public String register(@RequestParam("g-recaptcha-response") String reCaptchaResponse, MemberDTO memberDTO, Model model) {
//        if (!reCaptchaService.verify(reCaptchaResponse)) {
//            model.addAttribute("reCaptchaError", "CAPTCHA 인증 실패");
//            return "register";
//        }
//
//        String encodedPassword = passwordEncoder.encode(memberDTO.getPassword());
//        memberDTO.setPassword(encodedPassword);
//        memberDTO.setEnabled(true);
//        memberService.save(memberDTO);
//        return "redirect:/login";
//    }


    @DeleteMapping("/withdraw")
    public String withdraw(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String userId = null;
        if (auth != null) {
            Object principal = auth.getPrincipal();
            if (principal instanceof CustomUserDetails) {
                userId = ((CustomUserDetails) principal).getUsername();
            }
            new SecurityContextLogoutHandler().logout(request, response, auth);
            if (userId != null) {
                memberService.delete(userId);
            }
        }

        return "redirect:/";
    }


}
