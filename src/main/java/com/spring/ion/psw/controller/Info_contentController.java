package com.spring.ion.psw.controller;

import com.spring.ion.psw.service.Info_contentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/info")
@RequiredArgsConstructor
public class Info_contentController {
    private final Info_contentService infoContentService;

    @GetMapping("/write")
    public String writeForm(){
        return "write";
    }


    // 글 상세보기 페이지 지동
    @GetMapping("/detail")
    public String detailForm (){
        return "detail";
    }


}
