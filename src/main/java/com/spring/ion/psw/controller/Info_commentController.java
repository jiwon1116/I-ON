package com.spring.ion.psw.controller;

import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.service.Info_commentService;
import com.spring.ion.psw.service.Info_contentService;
import com.spring.ion.psw.service.NotifyService;
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
    private final Info_contentService infoContentService;
    private final NotifyService notifyService;

    // 댓글 저장과 알림 한번에 구현
    @PostMapping("/save")
    public @ResponseBody List<Info_commentDTO> save (@ModelAttribute Info_commentDTO infoCommentDTO){
        // 댓글 저장
        infoCommentService.save(infoCommentDTO);

        //게시글 정보 조회
        Info_contentDTO post = infoContentService.findContext(infoCommentDTO.getPost_id());

        // 알림 생성 (서비스에서 nickname null 여부 처리)
        notifyService.createCommentNotify(post.getNickname(),infoCommentDTO.getNickname(),post.getId(),infoCommentDTO.getId(),"info");

        // 댓글 목록 반환
        List<Info_commentDTO> commentDTOList = infoCommentService.findAll(infoCommentDTO.getPost_id());
        return commentDTOList;
    }

    // 댓글 삭제 기능
    @PostMapping("/delete")
    public @ResponseBody List<Info_commentDTO> delete (@ModelAttribute Info_commentDTO infoCommentDTO){
        infoCommentService.delete(infoCommentDTO);
        List<Info_commentDTO> commentDTOList = infoCommentService.findAll(infoCommentDTO.getPost_id());
        return commentDTOList;
     }
   }


