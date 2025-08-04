package com.spring.ion.lcw.service;

import com.spring.ion.lcw.dto.CustomUserDetails;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.mapper.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberRepository memberRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberDTO memberDTO = memberRepository.findByUserIdWithAuthorities(username);
        if (memberDTO == null) {
            throw new UsernameNotFoundException("memberDTO is null");
        }
        return new CustomUserDetails(memberDTO);
    }
}