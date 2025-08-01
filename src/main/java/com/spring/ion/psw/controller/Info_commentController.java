package com.spring.ion.psw.controller;

import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.service.Info_commentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/infocomment")
@RequiredArgsConstructor
public class Info_commentController {
    private final Info_commentService infoCommentService;


    @PostMapping("/save")
    public @ResponseBody List<Info_commentDTO> save (@ModelAttribute Info_commentDTO infoCommentDTO){
        System.out.println("댓글 저장정보 전송 완");
        infoCommentService.save(infoCommentDTO);
        List<Info_commentDTO> CommentDTOList = infoCommentService.findAll(infoCommentDTO.getPost_id());
        return CommentDTOList;
    }

   }


