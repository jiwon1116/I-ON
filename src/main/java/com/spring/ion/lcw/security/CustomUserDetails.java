package com.spring.ion.lcw.security;

import com.spring.ion.lcw.dto.MemberDTO;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Spring Security에서 사용할 사용자 정보 클래스
 * MyBatis가 아닌 Java 코드에서 MemberDTO를 통해 직접 생성해야 함
 */
@Getter
public class CustomUserDetails implements UserDetails, Serializable {

    private final MemberDTO memberDTO;

    public CustomUserDetails(MemberDTO memberDTO) {
        if (memberDTO == null) {
            throw new IllegalArgumentException("MemberDTO must not be null");
        }
        this.memberDTO = memberDTO;
    }

    /**
     * 사용자의 권한 목록을 반환합니다.
     * List<String> 형태의 권한들을 SimpleGrantedAuthority로 변환합니다.
     */
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<String> authorities = memberDTO.getAuthorities();
        if (authorities == null) {
            return List.of(); // 권한이 없을 경우 빈 리스트 반환
        }

        return authorities.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }

    /**
     * 사용자 비밀번호
     */
    @Override
    public String getPassword() {
        return memberDTO.getPassword();
    }

    /**
     * 사용자 ID (로그인에 사용)
     */
    @Override
    public String getUsername() {
        return memberDTO.getUserId();  // 로그인 ID로 userId 사용
    }

    @Override
    public boolean isAccountNonExpired() {
        return true; // 계정 만료 여부 (true: 만료 아님)
    }

    @Override
    public boolean isAccountNonLocked() {
        return true; // 계정 잠금 여부 (true: 잠기지 않음)
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true; // 비밀번호 만료 여부
    }

    /**
     * 계정 활성화 여부 (DB에서 enabled 필드 사용)
     */
    @Override
    public boolean isEnabled() {
        Boolean enabled = memberDTO.getEnabled();
        return enabled != null && enabled;
    }
}
