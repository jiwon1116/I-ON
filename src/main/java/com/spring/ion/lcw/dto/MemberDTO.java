package com.spring.ion.lcw.dto;

import lombok.Data;
import lombok.ToString;

import java.sql.Timestamp;
import java.util.List;

@Data
@ToString
public class MemberDTO {
    private Long id;
    private String userId;
    private String password;
    private String nickname;
    private String gender;
    private String region;
    private String profile_img;
    private Boolean enrollment_verified;
    private Integer trust_score;
    private Timestamp created_at;
    private Boolean enabled;
    private List<String> authorities;
}