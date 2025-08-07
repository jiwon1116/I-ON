package com.spring.ion.yjw.dto;

import lombok.Data;

@Data
public class TrustScoreDTO {
    private String nickname;      // 회원 닉네임
    private int commentCount;     // 전체 댓글 수
    private int reportCount;      // 제보/신고 커뮤니티 게시글 수
    private int entrustCount;     // 위탁글 수
    private int totalScore;       // 합산 점수(댓글+제보+위탁)
    private String grade;         // 등급(새싹맘/도토리맘/캡숑맘 등)
}
