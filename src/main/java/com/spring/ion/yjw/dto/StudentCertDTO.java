package com.spring.ion.yjw.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Data
public class StudentCertDTO {
    private Long id;
    private String userId;

    // 자녀 정보
    private String childName;
    private LocalDate childBirth;
    private Integer childAge;
    private String childSchool;
    private String childGrade;

    // 파일
    private String filePath;

    // 심사/상태
    private String status;        // PENDING / APPROVED / REJECTED
    private String reviewer;
    private String rejectReason;

    // 타임스탬프
    private LocalDateTime createdAt;

    // (선택) 조인용
    private String nickname;

}
