package com.spring.ion.psw.controller;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.dto.NotifyDTO;
import com.spring.ion.psw.service.NotifyService;
import com.spring.ion.yjw.service.TrustScoreService;
import com.spring.ion.yjw.dto.TrustScoreDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/myPage")
@RequiredArgsConstructor
public class MypageController {
    private final NotifyService notifyService;
    private final TrustScoreService trustScoreService;

    // mypage로 이동하며 정보(알림, 신뢰도) 뿌림
    @GetMapping
    public String notifyList(Model model) {
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO member = user.getMemberDTO();

        System.out.println("마이페이지 로그인 유저 객체:"+member);

        String nickname = member.getNickname(); // 로그인한 회원 닉네임

        //알림 모아둔 리스트에서 해당 닉네임 가진 알림 가져오기
        List<NotifyDTO> notifyList = notifyService.findAllByNotify(nickname);

         model.addAttribute("notifyList", notifyList);
         model.addAttribute("member", member);

         // 신뢰도 점수판 정보 추가
        TrustScoreDTO trustScoreDTO = trustScoreService.getTrustScore(nickname);
        model.addAttribute("trustScore",trustScoreDTO);
        return "mypage";
    }


}

