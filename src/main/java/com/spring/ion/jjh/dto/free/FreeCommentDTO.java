package com.spring.ion.jjh.dto.free;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FreeCommentDTO {
    private long id;
    private long post_id;
    private String nickname;
    private String content;
    private LocalDateTime created_at;
}
