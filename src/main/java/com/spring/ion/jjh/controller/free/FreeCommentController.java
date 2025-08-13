package com.spring.ion.jjh.controller.free;

import com.spring.ion.jjh.dto.entrust.EntrustDTO;
import com.spring.ion.jjh.dto.free.FreeCommentDTO;
import com.spring.ion.jjh.dto.free.FreeDTO;
import com.spring.ion.jjh.service.entrust.EntrustService;
import com.spring.ion.jjh.service.free.FreeCommentService;
import com.spring.ion.jjh.service.free.FreeService;
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
@RequestMapping("/comment")
@RequiredArgsConstructor
public class FreeCommentController {
    private final FreeCommentService freeCommentService;
    private final FreeService freeService;
    private final NotifyService notifyService;


    @PostMapping("/save")
    public @ResponseBody List<FreeCommentDTO> save(@ModelAttribute FreeCommentDTO commentDTO, Model model){
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        commentDTO.setNickname(user.getMemberDTO().getNickname());
        commentDTO.setUserId(user.getUsername());
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);
        freeCommentService.save(commentDTO);

        FreeDTO post = freeService.findById(commentDTO.getPost_id());

        notifyService.createCommentNotify(post.getNickname(),commentDTO.getNickname(),post.getId(),commentDTO.getId(),"free");

        List<FreeCommentDTO> commentDTOList = freeCommentService.findAll(commentDTO.getPost_id());
        return commentDTOList;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        FreeCommentDTO comment = freeCommentService.findById(id);
        long postId = comment.getPost_id();

        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = user.getUsername();

        boolean isAdmin = false;
        List<String> authorities = user.getMemberDTO().getAuthorities();
        if (authorities != null && authorities.contains("ROLE_ADMIN")) {
            isAdmin = true;
        }

        if (comment != null && (loginUserId.equals(comment.getUserId()) || isAdmin)) {
            freeCommentService.delete(id);
        }

        return "redirect:/free/" + postId;
    }
}
