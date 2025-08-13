package com.spring.ion.yjw.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Data
public class StudentCertDTO {
    private Long id;
    private String userId;
    private String childName;
    private LocalDate childBirth;
    private Integer childAge;
    private String childSchool;
    private String childGrade;
    private String filePath;
    private String status;
    private String reviewer;
    private String rejectReason;
    private LocalDateTime createdAt;
    private String nickname;
}
