package com.spring.ion.lcw.dto;

import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class MemberDTO implements Serializable {

    private Long id;
    private String userId;
    private String password;
    private String nickname;
    private String gender;
    private String region;
    private String profile_img;
    private Boolean enrollment_verified;
    private Integer trust_score;
    private LocalDateTime created_at;
    private Boolean enabled;
    private List<String> authorities;
}