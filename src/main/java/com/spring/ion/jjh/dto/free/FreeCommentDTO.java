package com.spring.ion.jjh.dto.free;

import lombok.Data;

import java.util.Date;

@Data
public class FreeCommentDTO {
    private long id;
    private long post_id;
    private String userId;
    private String nickname;
    private String content;
    private Date created_at;
}
