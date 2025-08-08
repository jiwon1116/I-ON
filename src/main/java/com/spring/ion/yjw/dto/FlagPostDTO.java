package com.spring.ion.yjw.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

// 관리자만 작성 가능
@Data
public class FlagPostDTO {
    private long id; //게시물 아이디
    private String nickname;
    private String title; // 게시물 제목
    private String content; // 게시물 내용
    private int like_count; // 좋아요 수
    private int view_count; // 조회수
    private Date created_at; // 작성일
    private String userId;
    private String city;
    private String district;
    private String status;


    private Boolean liked;


}
