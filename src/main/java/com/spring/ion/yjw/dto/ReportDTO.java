package com.spring.ion.yjw.dto;

import lombok.Data;

import java.util.Date;

@Data
public class ReportDTO {
    private Long id;
    private String reporterId;
    private String targetBoard;
    private Long targetContentId;
    private String type;
    private String status;
    private String description;
}
