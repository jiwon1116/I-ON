package com.spring.ion.jjh.dto.miss;

import lombok.Data;

import java.util.Date;

@Data
public class MissCommentDTO {
    private long id;
    private long post_id;
    private String nickname;
    private String content;
    private Date created_at;
    private String userId;
}
