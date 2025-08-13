package com.spring.ion.yjw.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;


@Data
public class FlagCommentDTO {
    private long id;
    private long post_id;
    private String nickname;
    private String content;
    private Date created_at;
    private String userId;

}
