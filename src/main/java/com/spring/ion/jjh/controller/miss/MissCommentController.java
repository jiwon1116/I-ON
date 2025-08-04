package com.spring.ion.jjh.controller.miss;

import com.spring.ion.jjh.dto.miss.MissCommentDTO;
import com.spring.ion.jjh.service.miss.MissCommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/missComment")
@RequiredArgsConstructor
public class MissCommentController {
    private final MissCommentService missCommentService;

    @PostMapping("/save")
    public @ResponseBody List<MissCommentDTO> save(@ModelAttribute MissCommentDTO commentDTO) {
        missCommentService.save(commentDTO);

        // 해당 게시글에 작성된 댓글 리스트 반환
        //        // 원래 있던 댓글 리스트 반환
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
        return "redirect:/miss/detail?id=" + postId;
    }
}
