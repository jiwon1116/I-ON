package com.spring.ion.psw.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.service.MemberService;
import com.spring.ion.psw.dto.NotifyDTO;
import com.spring.ion.psw.service.NotifyService;
import com.spring.ion.yjw.dto.TrustScoreDTO;
import com.spring.ion.yjw.service.TrustScoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MypageController {
    private final NotifyService notifyService;
    private final TrustScoreService trustScoreService;
    private final MemberService memberService;

    // mypage로 이동하며 정보(알림, 신뢰도) 뿌림
    @GetMapping
    public String notifyList(Model model) {
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String userId = user.getUsername(); // 또는 user.getMemberDTO().getUserId();

        // ★ DB에서 항상 최신 MemberDTO를 가져온다!
        MemberDTO latestMember = memberService.findByUserId(userId);

        String nickname = latestMember.getNickname();

        List<NotifyDTO> notifyList = notifyService.findAllByNotify(nickname);

        model.addAttribute("notifyList", notifyList);
        model.addAttribute("member", latestMember); // 최신 값으로 넘기기
        System.out.println("알림 객체: " + notifyList);

        model.addAttribute("notifyList", notifyList);
        model.addAttribute("member", latestMember);

        // 신뢰도 점수판 정보 추가
        TrustScoreDTO trustScoreDTO = trustScoreService.getTrustScore(nickname);
        model.addAttribute("trustScore", trustScoreDTO);
        return "mypage";

    }


    // 알림 삭제
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> deleteNotification(@RequestParam("id") Long id) {
        notifyService.deleteById(id);
        return ResponseEntity.ok().body("삭제 성공");
    }
}
