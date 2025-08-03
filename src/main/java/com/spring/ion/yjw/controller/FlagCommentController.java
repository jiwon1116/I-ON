package com.spring.ion.yjw.controller;

import com.spring.ion.jjh.dto.free.FreeCommentDTO;
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

    @PostMapping("/write")
    public @ResponseBody List<FlagCommentDTO> write(@ModelAttribute FlagCommentDTO flagCommentDTO) {
        flagCommentService.write(flagCommentDTO);
        System.out.println("댓글 dto : " + flagCommentDTO);
        // 해당 게시글에 작성된 댓글 리스트 반환
        // 원래 있던 댓글 리스트 반환
        List<FlagCommentDTO> flagCommentDTOList = flagCommentService.findAll(flagCommentDTO.getPost_id());
        return flagCommentDTOList;
    }

    @DeleteMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        int result = flagCommentService.delete(id);
        return (result > 0) ? "success" : "fail";
    }




}
