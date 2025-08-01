package com.spring.ion.jjh.controller.free;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.free.FreeCommentDTO;
import com.spring.ion.jjh.dto.free.FreeDTO;
import com.spring.ion.jjh.service.free.FreeCommentService;
import com.spring.ion.jjh.service.free.FreeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/free")
@RequiredArgsConstructor
public class FreeController {
    private final FreeService freeService;
    private final FreeCommentService commentService;

    @GetMapping
    public String paging(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
            // 현재 페이지에 해당하는 게시글 목록 가져오기
            List<FreeDTO> pagingList = freeService.pagingList(page);

            // 페이징에 필요한 정보 계산(전체 페이지수, 현재 페이지, 시작 페이지 등)
            PageDTO pageDTO = freeService.pagingParam(page);

            model.addAttribute("freeboardList", pagingList);
            model.addAttribute("paging", pageDTO);

        return "jjh/free/free";
    }

    @GetMapping("/write")
    public String writeForm() {
        return "jjh/free/write";
    }

    @PostMapping("/write")
    public String write(FreeDTO freeDTO) {
        int result = freeService.write(freeDTO);

        if (result > 0) {
            return "redirect:/free";
        } else {
            return "jjh/free/write";
        }
    }

    @GetMapping("/detail")
    public String detail(FreeDTO freeDTO, Model model) {
        long clickId = freeDTO.getId();
        freeService.updateViewCount(clickId);
        FreeDTO free = freeService.findById(clickId);
        model.addAttribute("free", free);
        List<FreeCommentDTO> commentDTO = commentService.findAll(clickId);
        model.addAttribute("commentList", commentDTO);
        return "jjh/free/detail";
    }

    @GetMapping("/updateLikeCount")
    public String updateLikeCount(FreeDTO freeDTO, Model model) {
        long clickId = freeDTO.getId();
        freeService.updateLikeCount(clickId);
        FreeDTO free = freeService.findById(clickId);
        model.addAttribute("free", free);
        List<FreeCommentDTO> commentDTO = commentService.findAll(clickId);
        model.addAttribute("commentList", commentDTO);
        return "jjh/free/detail";
    }

    @GetMapping("/update")
    public String updateForm(FreeDTO freeDTO, Model model) {
        long clickId = freeDTO.getId();
        FreeDTO free = freeService.findById(clickId);
        model.addAttribute("free", free);
        return "jjh/free/update";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute FreeDTO freeDTO) {
        boolean result = freeService.update(freeDTO);

        if (result) {
            return "redirect:/free";
        } else {
            return "jjh/free/update";
        }
    }

    @GetMapping("/delete")
    public String delete(FreeDTO freeDTO) {
        long clickId = freeDTO.getId();
        FreeDTO free = freeService.findById(clickId);

        if (free != null) {
            freeService.delete(clickId);
        }
        return "redirect:/free";
    }
}
