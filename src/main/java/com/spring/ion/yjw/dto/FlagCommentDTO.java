package com.spring.ion.yjw.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;


@Data
public class FlagCommentDTO {
    private long id; // 댓글 아이디
    private long post_id; // 정보 공유 게시물 아이디
    private String nickname; // 댓글 작성자 아이디
    private String content; // 댓글 내용
    private LocalDateTime created_at; // 댓글 작성일


    public String getFormattedCreatedAt() {
        return created_at != null ? created_at.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "";
    }
}
