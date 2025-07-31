package com.spring.ion.jjh.dto.miss;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MissDTO {
    private long id; // PK. 글번호
    private String nickname; // FK. 멤버 닉네임 = 작성자
    private String title; // 제목
    private String content; // 내용
    private int like_count; // 좋아요 수
    private int view_count; // 조회수
    private LocalDateTime created_at; // 등록 날짜
}
