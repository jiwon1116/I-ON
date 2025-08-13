package com.spring.ion.jjh.dto.miss;

import lombok.Data;

import java.util.Date;

@Data
public class MissDTO {
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
