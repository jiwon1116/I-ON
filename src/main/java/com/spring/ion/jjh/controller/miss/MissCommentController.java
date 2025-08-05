package com.spring.ion.jjh.controller.miss;

import com.spring.ion.jjh.dto.miss.MissCommentDTO;
import com.spring.ion.jjh.service.miss.MissCommentService;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/missComment")
@RequiredArgsConstructor
public class MissCommentController {
    private final MissCommentService missCommentService;

    @PostMapping("/save")
    public @ResponseBody List<MissCommentDTO> save(@ModelAttribute MissCommentDTO commentDTO, Model model){
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        commentDTO.setNickname(user.getMemberDTO().getNickname());
        commentDTO.setUserId(user.getUsername());
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);
        missCommentService.save(commentDTO);
        // 해당 게시글에 작성된 댓글 리스트 반환
        // 원래 있던 댓글 리스트 반환
        List<MissCommentDTO> commentDTOList = missCommentService.findAll(commentDTO.getPost_id());
        return commentDTOList;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        MissCommentDTO comment = missCommentService.findById(id);
        long postId = comment.getPost_id(); // 게시글 ID 추출

        if (comment != null) {
            missCommentService.delete(id);
        }
        return "redirect:/miss/" + postId;
    }
}
