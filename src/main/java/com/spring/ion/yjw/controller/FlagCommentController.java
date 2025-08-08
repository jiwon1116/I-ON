package com.spring.ion.yjw.controller;

import com.spring.ion.jjh.dto.entrust.EntrustDTO;
import com.spring.ion.jjh.service.entrust.EntrustService;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.service.NotifyService;
import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.service.FlagCommentService;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.yjw.service.FlagService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/FlagComment")
public class FlagCommentController {

    private final FlagCommentService flagCommentService;
    private final FlagService flagService;
    private final NotifyService notifyService;

    // 댓글 등록
    @PostMapping("/write")
    @ResponseBody
    public List<FlagCommentDTO> write(@RequestParam("content") String content,
                                      @RequestParam("post_id") long post_id) {
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        FlagCommentDTO dto = new FlagCommentDTO();
        dto.setNickname(user.getMemberDTO().getNickname());
        dto.setUserId(user.getUsername()); // 실제로는 userId 값!
        dto.setContent(content);
        dto.setPost_id(post_id);

        //게시글 정보 조회
        FlagPostDTO post = flagService.findById(dto.getPost_id());

        // 알림 생성 (서비스에서 nickname null 여부 처리)
        notifyService.createCommentNotify(post.getNickname(),dto.getNickname(),post.getId(),dto.getId(),"flag");

        flagCommentService.write(dto);
        return flagCommentService.findAll(post_id);
    }

    // 댓글 삭제
    @GetMapping("/delete")
    public @ResponseBody List<FlagCommentDTO> delete(
            @RequestParam("id") long id,
            @RequestParam("post_id") long postId
    ) {
        // 현재 로그인 유저
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = user.getUsername(); // 또는 getMemberDTO().getUserId();

        // 댓글 정보 조회
        FlagCommentDTO comment = flagCommentService.findById(id);

        // 작성자와 로그인 유저가 다르면 삭제 불가
        if (!loginUserId.equals(comment.getUserId())) {
            throw new RuntimeException("본인 댓글만 삭제할 수 있습니다.");
        }

        // 삭제 진행
        flagCommentService.delete(id);
        return flagCommentService.findAll(postId);
    }

}
