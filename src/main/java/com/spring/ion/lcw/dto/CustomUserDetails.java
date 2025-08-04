package com.spring.ion.lcw.dto;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;
import java.util.stream.Collectors;

public class CustomUserDetails implements UserDetails {

    private final MemberDTO memberDTO;

    public CustomUserDetails(MemberDTO memberDTO) {
        this.memberDTO = memberDTO;
    }

    public MemberDTO getMemberDTO() {
        return memberDTO;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return memberDTO.getAuthorities().stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return memberDTO.getPassword();
    }

    // 주의: 이름은 getUsername이지만 userId를 반환함(예시: asdf1234)
    @Override
    public String getUsername() {
        if (memberDTO == null) {
            throw new IllegalStateException("MemberDTO is null in CustomUserDetails");
        }
        return memberDTO.getUserId();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return memberDTO.getEnabled();
    }
}