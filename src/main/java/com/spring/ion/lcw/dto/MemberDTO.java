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
    private String profile_img;
    private Boolean enrollment_verified;
    private Integer trust_score;
    private LocalDateTime created_at;
    private Boolean enabled;
    private LocalDateTime banUntil;
    private LocalDateTime infoUntil;
    private String provider;
    private List<String> authorities;
    private String city;
    private String district;
}