package com.spring.ion.jjh.dto.entrust;

import lombok.Data;

import java.util.Date;

@Data
public class EntrustCommentDTO {
    private long id;
    private long post_id;
    private String nickname;
    private String content;
    private Date created_at;
}
