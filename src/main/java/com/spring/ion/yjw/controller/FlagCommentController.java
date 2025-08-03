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
    public @ResponseBody List<FlagCommentDTO> write(@ModelAttribute FlagCommentDTO flagCommentDTO) {
        flagCommentService.write(flagCommentDTO);
        List<FlagCommentDTO> flagCommentDTOList = flagCommentService.findAll(flagCommentDTO.getPost_id());

        // 디버깅용 로그 출력
        for (FlagCommentDTO dto : flagCommentDTOList) {
            System.out.println("댓글 목록: " + dto);
        }

        return flagCommentDTOList;
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
