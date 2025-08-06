package com.spring.ion.lcw.controller;

import com.spring.ion.lcw.repository.MemberRepository;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class MemberController {
    @Autowired
    private MemberService memberService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MemberRepository memberRepository;
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
    public String register(MemberDTO memberDTO, RedirectAttributes redirectAttributes) {

        String encodedPassword = passwordEncoder.encode(memberDTO.getPassword());
        memberDTO.setPassword(encodedPassword);
        memberDTO.setEnabled(true);

        try {
            memberService.save(memberDTO);
            redirectAttributes.addFlashAttribute("registerSuccess", "회원가입이 완료되었습니다!");
            return "redirect:/login";

        } catch (DataIntegrityViolationException e) {
            redirectAttributes.addFlashAttribute("registerError", "이미 사용 중인 아이디 또는 닉네임입니다.");
            return "redirect:/register";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("registerError", "회원가입 중 알 수 없는 오류가 발생했습니다.");
            return "redirect:/register";
        }
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
//        try {
//            memberService.save(memberDTO);
//            redirectAttributes.addFlashAttribute("registerSuccess", "회원가입이 완료되었습니다!");
//            return "redirect:/login";
//
//        } catch (DataIntegrityViolationException e) {
//            redirectAttributes.addFlashAttribute("registerError", "이미 사용 중인 아이디 또는 닉네임입니다.");
//            return "redirect:/register";
//
//        } catch (Exception e) {
//            redirectAttributes.addFlashAttribute("registerError", "회원가입 중 알 수 없는 오류가 발생했습니다.");
//            return "redirect:/register";
//        }
//    }


    @DeleteMapping("/withdraw")
    public String withdraw(HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        String userId = null;
        Object principal = auth.getPrincipal();
        if (principal instanceof CustomUserDetails) {
            userId = ((CustomUserDetails) principal).getUsername();
        } else {
            return "redirect:/";
        }

        try {
            memberService.delete(userId);
            redirectAttributes.addFlashAttribute("withdrawSuccess", "회원 탈퇴 처리가 완료되었습니다.");
            new SecurityContextLogoutHandler().logout(request, response, auth);
            return "redirect:/login";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("withdrawError", "회원 탈퇴 처리에 실패했습니다. 다시 로그인하여 시도해 보시고, 같은 문제가 반복될 경우 관리자에게 문의해 주세요.");
            return "redirect:/";
        }
    }

    @GetMapping("/edit")
    public String showEditForm(Model model) {

            CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            MemberDTO memberDTO = user.getMemberDTO();
            model.addAttribute("member", memberDTO);

        return "edit";
    }


    @PatchMapping("/edit")
    public String edit(@ModelAttribute MemberDTO memberDTO, RedirectAttributes redirectAttributes){
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO currentMember = userDetails.getMemberDTO();

        if (memberDTO.getNickname() != null && !memberDTO.getNickname().isEmpty()) {
            currentMember.setNickname(memberDTO.getNickname());
        }

        if (memberDTO.getPassword() != null && !memberDTO.getPassword().isEmpty()) {
            String encodedPassword = passwordEncoder.encode(memberDTO.getPassword());
            currentMember.setPassword(encodedPassword);
        }
        try {
            memberService.edit(currentMember);
            redirectAttributes.addFlashAttribute("editSuccess", "회원 정보가 수정되었습니다!");
            return "redirect:/mypage";
        }catch (DataIntegrityViolationException e){
            redirectAttributes.addFlashAttribute("editError", "이미 사용 중인 닉네임입니다.");
            redirectAttributes.addFlashAttribute("member", currentMember);
            return "redirect:/edit";
        } catch (Exception e){
            redirectAttributes.addFlashAttribute("editError", "회원정보 수정 중 알 수 없는 오류가 발생했습니다.");
            redirectAttributes.addFlashAttribute("member", currentMember);
            return "redirect:/edit";
        }
    }


}
