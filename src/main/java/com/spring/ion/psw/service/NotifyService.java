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
    public void createCommentNotify(String postWriter, String commentWriter, Long postId, Long commentId,String boardType) {
        if (postWriter == null || postWriter.equals(commentWriter)) return; // 자기 글엔 알림 X

        NotifyDTO notify = new NotifyDTO();
        notify.setNickname(postWriter); // 알림 받는 사람
        notify.setType(NotifyDTO.NotificationType.COMMENT);
        notify.setContent(commentWriter + "님이 댓글을 남겼습니다.");
        notify.setRelated_post_id(postId);  // 게시글 ID
        notify.setRelated_comment_id(commentId);
        notify.setCreated_at(new Date());
        notify.setRelated_board(boardType);

        notifyRepository.saveNotify(notify);
    }

    // 위험지역 알림저장
    public void createDangerNotify(String postWriter, String contentWriter, Long postId, String city,String district, String boardType) {
       /* if (postWriter == null || postWriter.equals(contentWriter)) return; // 자기가 작성한 제보 글은 알림 X*/

        NotifyDTO notify = new NotifyDTO();
        notify.setNickname(postWriter); // 알림 받는 사람
        notify.setType(NotifyDTO.NotificationType.DANGER_ALERT);
        notify.setRelated_post_id(postId);  // 제보 게시글 ID
        notify.setCreated_at(new Date());
        String fullRegion = city + " " + district;
        notify.setContent(postWriter + "님"+ fullRegion +"에 신고제보가 들어왔습니다 주의하세요!" );
        notify.setRelated_region(fullRegion); // 제보 글에서의 지역
        notify.setRelated_board(boardType);

        notifyRepository.saveNotify(notify);
    }

    // 해당 닉네임의 알림 가져오기
    public List<NotifyDTO> findAllByNotify(String nickname) {
        return notifyRepository.findAllByNotify(nickname);
    }

    public void deleteById(Long id) {
            notifyRepository.deleteById(id);
    }

    public boolean hasDangerAlertForRegion(String userRegion) {
            return notifyRepository.countDangerAlertByRegion(userRegion) > 0;
    }

}

