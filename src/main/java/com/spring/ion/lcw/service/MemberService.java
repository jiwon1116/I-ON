package com.spring.ion.lcw.service;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    public void save(MemberDTO memberDTO){
        memberRepository.save(memberDTO);
    }

    @Transactional
    public void delete(String username) {
        memberRepository.delete(username);
    }

    public void edit(MemberDTO memberDTO){
        memberRepository.edit(memberDTO);
    }


}
