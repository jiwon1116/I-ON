package com.spring.ion.jjh.dto.miss;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MissCommentDTO {
    private long id;
    private long post_id;
    private long member_id;
    private String content;
    private LocalDateTime created_at;
}
