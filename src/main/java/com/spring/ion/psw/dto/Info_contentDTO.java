package com.spring.ion.psw.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.Date;

// 관리자만 작성 가능
@Data
public class Info_contentDTO {
    private long id; //정보 공유 게시물 아이디
    private String nickname; //회원 닉네임
    private String title; // 게시물 제목
    private String content; // 게시물 내용
    private int like_count; // 좋아요 수
    private int view_count; // 조회수
    private Date created_at; // 작성일

    private Boolean liked;

}
