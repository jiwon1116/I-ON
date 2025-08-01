package com.spring.ion.psw.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;

@Data
public class Info_commentDTO {
    private long id; // 댓글 아이디
    private long post_id; // 정보 공유 게시물 아이디

    private String nickname; // 댓글 작성자 닉네임

    private String content; // 댓글 내용
    private Date created_at; // 댓글 작성일
}
