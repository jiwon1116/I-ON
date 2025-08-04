package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.service.FlagCommentService;
import lombok.RequiredArgsConstructor;
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
    public List<FlagCommentDTO> write(@RequestParam("nickname") String nickname,
                                      @RequestParam("content") String content,
                                      @RequestParam("post_id") long post_id) {
        FlagCommentDTO dto = new FlagCommentDTO();
        dto.setNickname(nickname);
        dto.setContent(content);
        dto.setPost_id(post_id);


        flagCommentService.write(dto);

        System.out.println("닉네임: " + nickname);
        System.out.println("내용: " + content);
        System.out.println("게시글 ID: " + post_id);



        return flagCommentService.findAll(post_id);
    }


    // 댓글 삭제
    @DeleteMapping("/delete/{id}")
    public @ResponseBody List<FlagCommentDTO> delete(@PathVariable Long id, @RequestParam("post_id") long postId) {
        flagCommentService.delete(id);
        List<FlagCommentDTO> flagCommentDTOList = flagCommentService.findAll(postId);

        // 삭제 후 결과 로그
        for (FlagCommentDTO dto : flagCommentDTOList) {
            System.out.println("삭제 후 댓글 목록: " + dto);
        }

        return flagCommentDTOList;
    }
}
