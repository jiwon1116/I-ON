package com.spring.ion.psw.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.dto.NotifyDTO;
import com.spring.ion.psw.service.NotifyService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/myPage")
@RequiredArgsConstructor
public class MypageController {
    private final NotifyService notifyService;

    // mypage로 이동하며 정보(알림, 신뢰도) 뿌림
    @GetMapping
    public String notifyList(Model model) {
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO member = user.getMemberDTO();

        String nickname = member.getNickname(); // 로그인한 회원 닉네임

        //알림 모아둔 리스트에서 해당 닉네임 가진 알림 가져오기
        List<NotifyDTO> notifyList = notifyService.findAllByNotify(nickname);
        System.out.println("알림 객체:"+notifyList);



         model.addAttribute("notifyList", notifyList);
         model.addAttribute("member", member);
        return "mypage";

    }

}

