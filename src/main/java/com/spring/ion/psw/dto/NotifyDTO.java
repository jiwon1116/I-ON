package com.spring.ion.psw.dto;

import lombok.Data;

import java.util.Date;

@Data
public class NotifyDTO {
    private long id;
    private String nickname; // 알림 받는 사람
    private NotificationType type;
    private String content;
    private Boolean is_read;
    private Date created_at;

    //  연관 데이터 참조용 필드
    private Long related_post_id;      // 게시글 ID
    private Long related_comment_id;   // 댓글 ID
    private String related_region;    // 위험지역 코드나 이름....

    public enum NotificationType {
        COMMENT, // 댓글
        REPLY, // 쪽지 답글
        DANGER_ALERT, // 위험 알림
        POPULAR //  인기글(제거예정)
    }
}
