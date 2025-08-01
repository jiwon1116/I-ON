package com.spring.ion.jjh.dto.free;

import lombok.Data;

import java.util.Date;

@Data
public class FreeDTO {
    private long id; // PK. 글번호
    private String nickname; // FK. 멤버 닉네임 = 작성자
    private String title; // 제목
    private String content; // 내용
    private int like_count; // 좋아요 수
    private int view_count; // 조회수
    private Date created_at; // 등록 날짜
}
