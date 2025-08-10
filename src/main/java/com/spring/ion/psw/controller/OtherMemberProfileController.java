package com.spring.ion.psw.controller;

import com.spring.ion.jjh.service.entrust.EntrustCommentService;
import com.spring.ion.jjh.service.entrust.EntrustService;
import com.spring.ion.jjh.service.free.FreeCommentService;
import com.spring.ion.jjh.service.free.FreeService;
import com.spring.ion.jjh.service.miss.MissCommentService;
import com.spring.ion.jjh.service.miss.MissService;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.service.MemberService;
import com.spring.ion.yjw.dto.TrustScoreDTO;
import com.spring.ion.yjw.service.FlagCommentService;
import com.spring.ion.yjw.service.FlagService;
import com.spring.ion.yjw.service.TrustScoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;


@Controller
@RequestMapping("/othermemberprofile")
@RequiredArgsConstructor
public class OtherMemberProfileController {

    private final MemberService memberService;
    private final FreeService freeService;
    private final FlagService flagService;
    private final MissService missService;
    private final EntrustService entrustService;

    private final FreeCommentService freeCommentService;
    private final FlagCommentService flagCommentService;
    private final MissCommentService missCommentService;
    private final EntrustCommentService entrustCommentService;

    // 타 회원 마이페이지 조회
    @GetMapping("/checkprofile")
    public String checkProfile(@RequestParam("nickname") String nickname, Model model) {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return "redirect:/login";
        }

        CustomUserDetails user = (CustomUserDetails) auth.getPrincipal();
        String userId = user.getUsername();

        MemberDTO loginMember = memberService.findByUserId(userId);

        String loginNickname = loginMember.getNickname();

        if (nickname.equals(loginNickname)) {
            return "redirect:/mypage";
        }

        MemberDTO target = memberService.findByNickname(nickname);
        if (target == null) {
            return "redirect:/";
        }
        model.addAttribute("target", target);
        return "otherMemberProfile";
    }

    /* 타회원이 작성한 게시물 목록 */
    @GetMapping("/otherPost")
    public String allMyPosts(@RequestParam("userId") String userId, Model model) {
        // 타 회원 닉네임
        MemberDTO memberDTO = memberService.findByUserId(userId);
        String nickname = memberDTO.getNickname();

        model.addAttribute("freePosts", freeService.findMyPosts(userId));
        model.addAttribute("flagPosts", flagService.findMyPosts(userId));
        model.addAttribute("missPosts", missService.findMyPosts(userId));
        model.addAttribute("entrustPosts", entrustService.findMyPosts(userId));
        model.addAttribute("nickname", nickname);


        return "psw/otherPost";
    }
    /* 타회원이 작성한 댓글 목록 */
    @GetMapping("/otherComment")
    public String allMyComments(@RequestParam("userId") String userId, Model model) {

        // 타 회원 닉네임
        MemberDTO memberDTO = memberService.findByUserId(userId);
        String nickname = memberDTO.getNickname();

        model.addAttribute("freeComments", freeCommentService.findMyComments(userId));
        model.addAttribute("flagComments", flagCommentService.findMyComments(userId));
        model.addAttribute("missComments", missCommentService.findMyComments(userId));
        model.addAttribute("entrustComments", entrustCommentService.findMyComments(userId));
        model.addAttribute("nickname", nickname);

        return "psw/otherComment";
    }

}