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
    public void createDangerNotify(String postWriter, Long postId, String city, String district, String boardType) {
        String writerNickname = postWriter;
        System.out.println("[NotifyService] fullRegion=" + city + district + ", writer=" + writerNickname);
        List<MemberDTO> members = memberRepository.findByRegionExceptWriter(city, district, writerNickname);
        System.out.println("[NotifyService] 대상 회원 수=" + members.size());
        String fullRegion = city + " " + district;

        // 재학생 인증 회원에게만 알림 생성 (람다식 사용)
        List<MemberDTO> verifiedMembers = new ArrayList<>();
        for (MemberDTO member : members) {
                        if (member.isEnrollment_verified()) {
                verifiedMembers.add(member);
            }
        }

        for (MemberDTO m : verifiedMembers) {
            if (m.getUserId().equals("admin")) {
                continue;
            }
            NotifyDTO notify = new NotifyDTO();
            notify.setNickname(m.getNickname()); // 수신자
            notify.setType(NotifyDTO.NotificationType.DANGER_ALERT);
            notify.setContent("⚠️ [" + fullRegion + "]에 위험 제보가 접수되었습니다.");
            notify.setRelated_post_id(postId);
            notify.setRelated_board(boardType);
            notify.setRelated_region(fullRegion);
            notify.setCreated_at(new Date());
            notifyRepository.saveNotify(notify);
        }
    }

    // 알림 목록 가져오기 (재학생 인증 여부 포함)
    public List<NotifyDTO> findAllByNotify(String nickname, boolean isEnrollmentVerified) {
        List<NotifyDTO> allNotifications = notifyRepository.findAllByNotify(nickname);

        // 재학생 인증 회원이 아닌 경우, 위험 알림을 목록에서 제거
        if (!isEnrollmentVerified) {
            // for를 사용해 위험 알림만 제거
            allNotifications.removeIf(n -> n.getType() == NotifyDTO.NotificationType.DANGER_ALERT);
        }
        return allNotifications;
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