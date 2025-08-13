package com.spring.ion.jjh.controller.entrust;

import com.spring.ion.jjh.dto.entrust.EntrustCommentDTO;
import com.spring.ion.jjh.dto.entrust.EntrustDTO;
import com.spring.ion.jjh.service.entrust.EntrustCommentService;
import com.spring.ion.jjh.service.entrust.EntrustService;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.service.NotifyService;
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
    private final EntrustService entrustService;
    private final NotifyService notifyService;

    @PostMapping("/save")
    public @ResponseBody List<EntrustCommentDTO> save(@ModelAttribute EntrustCommentDTO commentDTO, Model model){
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        commentDTO.setNickname(user.getMemberDTO().getNickname());
        commentDTO.setUserId(user.getUsername());
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);

        entrustCommentService.save(commentDTO);

        EntrustDTO post = entrustService.findById(commentDTO.getPost_id());

        notifyService.createCommentNotify(post.getNickname(),commentDTO.getNickname(),post.getId(),commentDTO.getId(),"entrust");

        List<EntrustCommentDTO> commentDTOList = entrustCommentService.findAll(commentDTO.getPost_id());
        return commentDTOList;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        EntrustCommentDTO comment = entrustCommentService.findById(id);
        long postId = comment.getPost_id();

        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = user.getUsername();

        boolean isAdmin = false;
        List<String> authorities = user.getMemberDTO().getAuthorities();
        if (authorities != null && authorities.contains("ROLE_ADMIN")) {
            isAdmin = true;
        }

        if (comment != null && (loginUserId.equals(comment.getUserId()) || isAdmin)) {
            entrustCommentService.delete(id);
        }
        return "redirect:/entrust/" + postId;
    }

}
