package com.spring.ion.yjw.controller;

import com.spring.ion.jjh.service.entrust.EntrustCommentService;
import com.spring.ion.jjh.service.entrust.EntrustService;
import com.spring.ion.jjh.service.free.FreeCommentService;
import com.spring.ion.jjh.service.free.FreeService;
import com.spring.ion.jjh.service.miss.MissCommentService;
import com.spring.ion.jjh.service.miss.MissService;
import com.spring.ion.yjw.service.FlagCommentService;
import com.spring.ion.yjw.service.FlagService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;

@Controller
public class MyPostController {

    private final FreeService freeService;
    private final FlagService flagService;
    private final MissService missService;
    private final EntrustService entrustService;

    private final FreeCommentService freeCommentService;
    private final FlagCommentService flagCommentService;
    private final MissCommentService missCommentService;
    private final EntrustCommentService entrustCommentService;

    // 모든 서비스 의존성 한 번에 생성자 주입!
    public MyPostController(
            FreeService freeService,
            FlagService flagService,
            MissService missService,
            EntrustService entrustService,
            FreeCommentService freeCommentService,
            FlagCommentService flagCommentService,
            MissCommentService missCommentService,
            EntrustCommentService entrustCommentService
    ) {
        this.freeService = freeService;
        this.flagService = flagService;
        this.missService = missService;
        this.entrustService = entrustService;
        this.freeCommentService = freeCommentService;
        this.flagCommentService = flagCommentService;
        this.missCommentService = missCommentService;
        this.entrustCommentService = entrustCommentService;
    }

    /** 내가 쓴 글 목록 */
    @GetMapping("/myPost")
    public String allMyPosts(Model model, Principal principal) {
        String userId = principal.getName();
        model.addAttribute("freePosts", freeService.findMyPosts(userId));
        model.addAttribute("flagPosts", flagService.findMyPosts(userId));
        model.addAttribute("missPosts", missService.findMyPosts(userId));
        model.addAttribute("entrustPosts", entrustService.findMyPosts(userId));
        return "yjw/myPost";
    }

    /** 내가 쓴 댓글 목록 */
    @GetMapping("/myComment")
    public String allMyComments(Model model, Principal principal) {
        String userId = principal.getName();
        model.addAttribute("freeComments", freeCommentService.findMyComments(userId));
        model.addAttribute("flagComments", flagCommentService.findMyComments(userId));
        model.addAttribute("missComments", missCommentService.findMyComments(userId));
        model.addAttribute("entrustComments", entrustCommentService.findMyComments(userId));
        return "yjw/myComment";
    }
}
