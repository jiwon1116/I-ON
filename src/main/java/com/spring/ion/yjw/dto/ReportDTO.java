package com.spring.ion.yjw.dto;

import lombok.Data;

import java.util.Date;

@Data
public class ReportDTO {
    private Long id;
    private Long reporterId;      // 신고자 user PK
    private Long targetId;        // 신고 대상 PK (게시글, 댓글, 유저 등)
    private String targetType;
    private String type;          // 신고 유형 (스팸/욕설 등)
    private String status;        // 신고 처리 상태
    private String content;       // 신고 사유
    private Date createdAt;
    private Date updatedAt;
    private Date deletedAt;
}
