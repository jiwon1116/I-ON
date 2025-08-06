package com.spring.ion.psw.service;

import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.dto.NotifyDTO;
import com.spring.ion.psw.repository.NotifyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;


@Service
@RequiredArgsConstructor
public class NotifyService {
    private final NotifyRepository notifyRepository;

    // 댓글 알림저장
    public void createCommentNotify(Info_commentDTO infoCommentDTO, Info_contentDTO post) {

        NotifyDTO notify = new NotifyDTO();
        notify.setNickname(post.getNickname());
        notify.setType(NotifyDTO.NotificationType.COMMENT);
        notify.setContent(infoCommentDTO.getNickname() + "님이 댓글을 남겼습니다.");
        notify.setRelated_post_id(infoCommentDTO.getPost_id()); // 관련 게시글
        notify.setRelated_comment_id(infoCommentDTO.getId()); // 관련 댓글
        notify.setIs_read(false);
        notify.setCreated_at(new Date());

        notifyRepository.saveNotify(notify);
       }
    }

