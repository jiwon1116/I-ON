package com.spring.ion.yjw.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

// 관리자만 작성 가능
@Data
public class FlagPostDTO {
    private long id;
    private String nickname;
    private String title;
    private String content;
    private int like_count;
    private int view_count;
    private Date created_at;
    private String userId;
    private String city;
    private String district;
    private String status;
    private String profileImg;
    private Boolean liked;
}
