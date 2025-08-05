package com.spring.ion.jjh.controller.entrust;

import com.spring.ion.jjh.dto.entrust.EntrustCommentDTO;
import com.spring.ion.jjh.service.entrust.EntrustCommentService;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/entrustComment")
@RequiredArgsConstructor
public class EntrustCommentController {
    private final EntrustCommentService entrustCommentService;

    @PostMapping("/save")
    public @ResponseBody List<EntrustCommentDTO> save(@ModelAttribute EntrustCommentDTO commentDTO, Model model){
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        commentDTO.setNickname(user.getMemberDTO().getNickname());
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);
        entrustCommentService.save(commentDTO);

        // 해당 게시글에 작성된 댓글 리스트 반환
        //        // 원래 있던 댓글 리스트 반환
        List<EntrustCommentDTO> commentDTOList = entrustCommentService.findAll(commentDTO.getPost_id());
        return commentDTOList;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        EntrustCommentDTO comment = entrustCommentService.findById(id);
        long postId = comment.getPost_id(); // 게시글 ID 추출

        if (comment != null) {
            entrustCommentService.delete(id);
        }
        return "redirect:/entrust/detail?id=" + postId;
    }
}
