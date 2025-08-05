package com.spring.ion.yjw.controller;

import com.spring.ion.jjh.service.entrust.EntrustService;
import com.spring.ion.jjh.service.free.FreeService;
import com.spring.ion.jjh.service.miss.MissService;
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

    public MyPostController(
            FreeService freeService,
            FlagService flagService,
            MissService missService,
            EntrustService entrustService
    ) {
        this.freeService = freeService;
        this.flagService = flagService;
        this.missService = missService;
        this.entrustService = entrustService;
    }

    @GetMapping("/myPost")
    public String allMyPosts(Model model, Principal principal) {
        String nickname = principal.getName(); // 로그인한 유저 아이디

//        model.addAttribute("freePosts", freeService.findMyPosts(loginId));
        model.addAttribute("flagPosts", flagService.findMyPosts(nickname));
//        model.addAttribute("missPosts", missService.findMyPosts(loginId));
//        model.addAttribute("entrustPosts", entrustService.findMyPosts(loginId));

        return "yjw/myPost"; // /WEB-INF/views/myPost.jsp
    }
}

