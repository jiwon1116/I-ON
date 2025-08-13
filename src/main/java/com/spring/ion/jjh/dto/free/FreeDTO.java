package com.spring.ion.jjh.dto.free;

import lombok.Data;

import java.util.Date;

@Data
public class FreeDTO {
    private long id;
    private String userId;
    private String nickname;
    private String title;
    private String content;
    private int like_count;
    private int view_count;
    private Date created_at;

    private Boolean liked;
}
