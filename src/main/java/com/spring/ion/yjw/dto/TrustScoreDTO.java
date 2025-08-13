package com.spring.ion.yjw.dto;

import lombok.Data;

@Data
public class TrustScoreDTO {
    private String nickname;
    private int commentCount;
    private int reportCount;
    private int entrustCount;
    private int totalScore;
    private String grade;
}
