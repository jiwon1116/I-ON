package com.spring.ion.jjh.dto.miss;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MissDTO {
    private long id;
    private long member_id;
    private String title;
    private String content;
    private int like_count;
    private int view_count;
    private LocalDateTime created_at;
}
