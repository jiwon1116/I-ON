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

    // 게시물 뿌리는 리스트
   /* private void loadInfoList(Model model) {
        List<Info_contentDTO> contentList = infoContentService.AllfindList();
        model.addAttribute("ContentList", contentList);
    }*/



    // 글 작성 페이지 이동
    @GetMapping("/save")
    public String writeForm(){
        return "psw/write";
    }



    // 실제 글 DB 저장 후 게시물 페이지 이동
    @PostMapping("/save")
    public String infoForm(Info_contentDTO infoContentDTO){
        System.out.println("작성글:"+ infoContentDTO);
   //     infoContentService.save(infoContentDTO);

        
      return "psw/info";
    }


    // 글 상세보기 페이지 지동
    @GetMapping("/detail")
    public String detailForm (){
        return "detail";
    }


}
