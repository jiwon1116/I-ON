package com.spring.ion.psw.controller;

import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.service.Info_commentService;
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
public class Info_contentController{
    private final Info_contentService infoContentService;
    private final Info_commentService infoCommentService;

    //게시물 불러오는 리스트
    private void addContentListl(Model model) {
        List<Info_contentDTO> contentList = infoContentService.AllfindList();
        model.addAttribute("contentList", contentList);
    }
    @GetMapping
    public String info(Model model){
        addContentListl(model);
        return "psw/info";
    }

    @GetMapping("/save")
    public String writeForm() {
        return "psw/write";
    }

    @PostMapping("/save")
    public String infoForm(@ModelAttribute Info_contentDTO infoContentDTO,Model model) {
        System.out.println("글작성내용:"+infoContentDTO);
        int saveResult = infoContentService.save(infoContentDTO);
        if (saveResult > 0) {
            addContentListl(model);
            return "psw/info";
        } else {
            return "psw/write";
        }
    }

    @GetMapping("/detail/{id}")
    public String detailForm(@PathVariable("id") long id, Model model) {
        infoContentService.updateHits(id);
        Info_contentDTO findDto = infoContentService.findContext(id);
        model.addAttribute("findDto", findDto);
        List<Info_commentDTO> infoCommentList= infoCommentService.findAll(id);
        model.addAttribute("commentList", infoCommentList);
        return "psw/detail";
    }

    @PostMapping("/detail")
    public String updateForm(@ModelAttribute Info_contentDTO infoContentDTO, Model model) {
        Info_contentDTO findDto = infoContentService.findContext(infoContentDTO.getId());
        model.addAttribute("findDto", findDto);
        return "psw/update";
    }
    
    // 좋아요수 증가
    @GetMapping("/like")
    public String likeUpdate(@RequestParam("id") long id, Model model) {
        infoContentService.updateLike(id);
        Info_contentDTO findDto = infoContentService.findContext(id);
        model.addAttribute("findDto", findDto);
        return "psw/detail";
    }



    @PostMapping("/update")
    public String update(@ModelAttribute Info_contentDTO infoContentDTO, Model model) {
        boolean result = infoContentService.update(infoContentDTO);
        if (result) {
            addContentListl(model);
            return "psw/info";
        } else {
            return "update";
        }
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id, Model model) {
        infoContentService.delete(id);
        addContentListl(model);
        return "psw/info";
    }
}
