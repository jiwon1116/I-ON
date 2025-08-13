package com.spring.ion.lcw.security;

import com.spring.ion.lcw.dto.MemberDTO;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Getter
public class CustomUserDetails implements UserDetails, Serializable {

    private final MemberDTO memberDTO;

    public CustomUserDetails(MemberDTO memberDTO) {
        if (memberDTO == null) {
            throw new IllegalArgumentException("MemberDTO is null");
        }
        this.memberDTO = memberDTO;
    }
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<String> authorities = memberDTO.getAuthorities();
        if (authorities == null) {
            return List.of();
        }

        return authorities.stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return memberDTO.getPassword();
    }

    @Override
    public String getUsername() {
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
        Boolean enabled = memberDTO.getEnabled();
        return enabled != null && enabled;
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CustomUserDetails that = (CustomUserDetails) o;
        return getUsername().equals(that.getUsername());
    }
    @Override
    public int hashCode() {
        return Objects.hash(getUsername());
    }
}
