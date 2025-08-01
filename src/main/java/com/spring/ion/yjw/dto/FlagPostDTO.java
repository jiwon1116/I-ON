package com.spring.ion.yjw.dto;

import lombok.Data;

import java.time.LocalDateTime;

// 관리자만 작성 가능
@Data
public class FlagPostDTO {
    private long id; //게시물 아이디
    private String title; // 게시물 제목
    private String content; // 게시물 내용
    private int like_count; // 좋아요 수
    private int view_count; // 조회수
    private LocalDateTime created_at; // 작성일

}
