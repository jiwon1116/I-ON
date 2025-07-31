package com.spring.ion.psw.controller;

import com.spring.ion.psw.dto.Info_FileDTO;
import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.service.Info_contentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Controller
@RequestMapping("/info")
@RequiredArgsConstructor
public class Info_contentController {
    private final Info_contentService infoContentService;

    // 글 작성 페이지 이동
    @GetMapping("/save")
    public String writeForm(){
        return "psw/write";
    }


    // 실제 글 DB 저장 후 게시물 페이지 이동
    @PostMapping("/save")
    public String infoForm(Info_contentDTO infoContentDTO, Model model){
        int saveResult = infoContentService.save(infoContentDTO);
        if (saveResult > 0) {
            List<Info_contentDTO> contentList = infoContentService.AllfindList();
            model.addAttribute("contentList", contentList);
            return "psw/info";
        } else {
            return "psw/write";
        }
    }

    // 글 상세보기 페이지 지동
    @GetMapping("/detail/{id}")
    public String detailForm (@PathVariable("id") long id, Model model){
        System.out.println("detail id:"+id);
        Info_contentDTO findDto = infoContentService.findContext(id); // 게시글
        model.addAttribute("findDto", findDto);
        return "psw/detail";
    }

    // 수정페이지로 이동
    @PostMapping("/update")
    public String updateForm (){

        return "psw/update";
    }
}
