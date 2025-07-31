package com.spring.ion.yjw.dto;

import lombok.Data;

import java.util.Date;

@Data
public class FlagDTO {
    private Long id;
    private Long memberId;
    private String nickname;
    private String title;
    private String content;
    private int likeCount;
    private int viewCount;
    private Date createdAt;

    private String originalFileName; // 사용자가 업로드한 파일명
    private String storedFileName;
}

