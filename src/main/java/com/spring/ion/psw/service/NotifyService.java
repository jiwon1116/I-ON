package com.spring.ion.psw.service;

import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.dto.NotifyDTO;
import com.spring.ion.psw.repository.NotifyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;


@Service
@RequiredArgsConstructor
public class NotifyService {
    private final NotifyRepository notifyRepository;

    // 댓글 알림저장
    public void createCommentNotify(Info_commentDTO infoCommentDTO, Info_contentDTO content) {

        // 닉네임이 없으면 관리자
        String receiver = (content.getNickname() != null) ? content.getNickname() : "admin";

        NotifyDTO notify = new NotifyDTO();
        notify.setNickname(receiver);
        notify.setType(NotifyDTO.NotificationType.COMMENT);
        notify.setContent(infoCommentDTO.getNickname() + "님이 댓글을 남겼습니다.");
        notify.setRelated_post_id(infoCommentDTO.getPost_id()); // 관련 게시글
        notify.setRelated_comment_id(infoCommentDTO.getId()); // 관련 댓글
        notify.setIs_read(false);
        notify.setCreated_at(new Date());

        notifyRepository.saveNotify(notify);
       }
    // 해당 닉네임의 알림 가져오기
    public List<NotifyDTO> findAllByNotify(String nickname) {
        return notifyRepository.findAllByNotify(nickname);
    }
}

