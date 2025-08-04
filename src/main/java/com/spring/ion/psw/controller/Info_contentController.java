package com.spring.ion.psw.controller;

import com.spring.ion.psw.dto.Info_PageDTO;
import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.service.Info_commentService;
import com.spring.ion.psw.service.Info_contentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/info")
@RequiredArgsConstructor
public class Info_contentController{
    private final Info_contentService infoContentService;
    private final Info_commentService infoCommentService;


    //게시물 불러오는 리스트
    @GetMapping
    public String list(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page) {

        List<Info_contentDTO> pagingList = infoContentService.pagingList(page);
        Info_PageDTO pageDTO = infoContentService.pagingParam(page);

        model.addAttribute("postList", pagingList);
        model.addAttribute("paging", pageDTO);

        return "psw/paging";

    }

    //글 쓰기 폼으로 이동
    @GetMapping("/save")
    public String writeForm() {

        return "psw/write";
    }

    // 글 저장처리
    @PostMapping("/save")
    public String save(@ModelAttribute Info_contentDTO dto) {

        infoContentService.save(dto);
        return "redirect:/info/paging";
    }


    // 상세보기
    @GetMapping("/detail")
    public String detailForm(@RequestParam("id") long id, Model model) {
        // 조회수 증가
        infoContentService.updateHits(id);
        Info_contentDTO findDto = infoContentService.findContext(id);
        List<Info_commentDTO> infoCommentList= infoCommentService.findAll(id);

        model.addAttribute("findDto", findDto);
        model.addAttribute("commentList", infoCommentList);
        return "psw/detail";
    }

    // 글 수정 폼
    @PostMapping("/detail")
    public String updateForm(@ModelAttribute Info_contentDTO infoContentDTO, Model model) {
        Info_contentDTO findDto = infoContentService.findContext(infoContentDTO.getId());
        model.addAttribute("findDto", findDto);
        return "psw/update";
    }
    
    // 좋아요수 증가
    @PostMapping("/like")
    @ResponseBody
    public ResponseEntity<Integer> likeUpdate(@RequestParam("id") long id) {
        infoContentService.updateLike(id);
        Info_contentDTO updatedDto = infoContentService.findContext(id);
        int likeCount = updatedDto.getLike_count(); // 좋아요 수 필드에 따라 수정
        return ResponseEntity.ok(likeCount);
    }


    // 글 수정 처리
    @PostMapping("/update")
    public String update(@ModelAttribute Info_contentDTO infoContentDTO) {
        boolean result = infoContentService.update(infoContentDTO);
        if (result) {
            return "redirect:/info/";
        } else {
            return "psw/update";
        }
    }

    // 글 삭제
    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        infoContentService.delete(id);
        return "redirect:/info/";
    }

    // 페이징
    @GetMapping("/paging")
    public String paging(Model model,
                         @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        System.out.println("현제 페이지"+page);
        List<Info_contentDTO> pagingList = infoContentService.pagingList(page);
        Info_PageDTO pageDTO = infoContentService.pagingParam(page);

        model.addAttribute("postList", pagingList);
        model.addAttribute("paging", pageDTO);

        return "psw/paging";
    }


}
