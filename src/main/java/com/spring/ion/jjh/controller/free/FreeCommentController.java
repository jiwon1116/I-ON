package com.spring.ion.jjh.controller.free;

import com.spring.ion.jjh.dto.free.FreeCommentDTO;
import com.spring.ion.jjh.service.free.FreeCommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/comment")
@RequiredArgsConstructor
public class FreeCommentController {
    private final FreeCommentService freeCommentService;

    @PostMapping("/save")
    public @ResponseBody List<FreeCommentDTO> save(@ModelAttribute FreeCommentDTO commentDTO) {
        freeCommentService.save(commentDTO);
        System.out.println("댓글 dto : " + commentDTO);
        // 해당 게시글에 작성된 댓글 리스트 반환
        // 원래 있던 댓글 리스트 반환
        List<FreeCommentDTO> commentDTOList = freeCommentService.findAll(commentDTO.getPost_id());
        return commentDTOList;
    }
}
