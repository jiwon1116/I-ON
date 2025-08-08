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

        //게시글 정보 조회
        EntrustDTO post = entrustService.findById(commentDTO.getPost_id());

        // 알림 생성 (서비스에서 nickname null 여부 처리)
        notifyService.createCommentNotify(post.getNickname(),commentDTO.getNickname(),post.getId(),commentDTO.getId(),"entrust");

        // 해당 게시글에 작성된 댓글 리스트 반환
       // 원래 있던 댓글 리스트 반환
        List<EntrustCommentDTO> commentDTOList = entrustCommentService.findAll(commentDTO.getPost_id());
        return commentDTOList;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        EntrustCommentDTO comment = entrustCommentService.findById(id);
        long postId = comment.getPost_id(); // 게시글 ID 추출

        // 로그인 유저 정보 + 권한
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = user.getUsername();

        boolean isAdmin = false;
        List<String> authorities = user.getMemberDTO().getAuthorities();
        if (authorities != null && authorities.contains("ROLE_ADMIN")) {
            isAdmin = true;
        }

        // 권한 체크: 작성자 or 관리자
        if (comment != null && (loginUserId.equals(comment.getUserId()) || isAdmin)) {
            entrustCommentService.delete(id);
        }
        return "redirect:/entrust/" + postId;
    }

}
