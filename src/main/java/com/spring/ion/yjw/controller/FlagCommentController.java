package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.service.FlagCommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("comment")
public class FlagCommentController {

    private final FlagCommentService flagCommentService;

    @PostMapping("/write")
    @ResponseBody
    public List<FlagCommentDTO> write(@RequestParam("nickname") String nickname,
                                      @RequestParam("content") String content,
                                      @RequestParam("post_id") int post_id) {
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




}
