package com.spring.ion.jjh.controller.free;

import com.spring.ion.jjh.dto.free.FreeCommentDTO;
import com.spring.ion.jjh.service.free.FreeCommentService;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/comment")
@RequiredArgsConstructor
public class FreeCommentController {
    private final FreeCommentService freeCommentService;

    @PostMapping("/save")
    public @ResponseBody List<FreeCommentDTO> save(@ModelAttribute FreeCommentDTO commentDTO, Model model){
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        commentDTO.setNickname(user.getMemberDTO().getNickname());
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);
        freeCommentService.save(commentDTO);

        // 해당 게시글에 작성된 댓글 리스트 반환
        //        // 원래 있던 댓글 리스트 반환
        List<FreeCommentDTO> commentDTOList = freeCommentService.findAll(commentDTO.getPost_id());
        return commentDTOList;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        FreeCommentDTO comment = freeCommentService.findById(id);
        long postId = comment.getPost_id(); // 게시글 ID 추출

        if (comment != null) {
            freeCommentService.delete(id);
        }
        return "redirect:/free/detail?id=" + postId;
    }
}
