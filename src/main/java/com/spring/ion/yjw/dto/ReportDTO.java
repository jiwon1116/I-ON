package com.spring.ion.yjw.dto;

import lombok.Data;

import java.util.Date;

@Data
public class ReportDTO {
    private Long id;
    private String reporterId;          // 신고자 user PK
    private String targetBoard;         // 게시판 종류
    private Long targetContentId;       // 신고 대상 게시글 번호
    private String type;                // 신고 유형 (부적절한 글/스팸/욕설)
    private String status;              // 신고 처리 상태
    private String description;         // 신고 사유
}
