package com.spring.ion.yjw.controller;

import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.service.FlagCommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("FlagComment")
public class FlagCommentController {

    private final FlagCommentService flagCommentService;

    // 댓글 작성

    @PostMapping("/write")
    public @ResponseBody List<FlagCommentDTO> write(
            @RequestParam("content") String content,
            @RequestParam("post_id") long post_id,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        String nickname = userDetails.getMemberDTO().getNickname();
        String userId = userDetails.getMemberDTO().getUserId();

        FlagCommentDTO dto = new FlagCommentDTO();
        dto.setNickname(nickname);
        dto.setUserId(userId);
        dto.setContent(content);
        dto.setPost_id(post_id);

        flagCommentService.write(dto);

        return flagCommentService.findAll(post_id);
    }





    // 댓글 삭제
    @GetMapping("/delete")
    public @ResponseBody List<FlagCommentDTO> delete(@RequestParam("id") Long id, @RequestParam("post_id") long post_id) {
        flagCommentService.delete(id);
        List<FlagCommentDTO> flagCommentDTOList = flagCommentService.findAll(post_id);

        // 삭제 후 결과 로그
        for (FlagCommentDTO dto : flagCommentDTOList) {
            System.out.println("삭제 후 댓글 목록: " + dto);
        }

        return flagCommentDTOList;
    }
}
