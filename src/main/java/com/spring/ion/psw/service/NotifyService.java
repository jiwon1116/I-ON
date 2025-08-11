package com.spring.ion.psw.service;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.repository.MemberRepository;
import com.spring.ion.psw.dto.NotifyDTO;
import com.spring.ion.psw.repository.NotifyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.ArrayList; // ArrayList를 사용하기 위해 추가

@Service
@RequiredArgsConstructor
public class NotifyService {
    private final NotifyRepository notifyRepository;
    private final MemberRepository memberRepository;

    // 댓글 알림저장
    public void createCommentNotify(String postWriter, String commentWriter, Long postId, Long commentId, String boardType) {
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
    public void createDangerNotify(String postWriter, Long postId, String city,String district, String boardType) {
        String writerNickname = postWriter;

        // 작성자 제외 같은 지역 회원 출력
        List<MemberDTO> members = memberRepository.findByRegionExceptWriter(city, district, writerNickname);
        String fullRegion = city + " " + district;

        for (MemberDTO m : members) {
            if (m.getUserId().equals("admin")){
                continue;
            }
            NotifyDTO notify = new NotifyDTO();
            notify.setNickname(m.getNickname()); // 수신자
            notify.setType(NotifyDTO.NotificationType.DANGER_ALERT);
            notify.setContent("⚠️ [" + city + district + "]에 위험 제보가 접수되었습니다.");
            notify.setRelated_post_id(postId);
            notify.setRelated_board(boardType);
            notify.setRelated_region(fullRegion);
            notify.setCreated_at(new Date());
            notifyRepository.saveNotify(notify);
        }

    }
    public List<NotifyDTO> findAllByNotify(String nickname) {
        return notifyRepository.findAllByNotify(nickname);
    }

    public void deleteById(Long id) {
        notifyRepository.deleteById(id);
    }

    // 게시글 번호로 알림 지우기
    public void deleteByPostId(long id) {
        notifyRepository.deleteByPostId(id);
    }
}