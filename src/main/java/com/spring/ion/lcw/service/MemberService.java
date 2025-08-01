package com.spring.ion.lcw.service;

import com.spring.ion.lcw.dto.MemberDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class MemberService {

    public void save(MemberDTO memberDTO){
//        memberMapper.insertMember(memberDTO);
//        memberMapper.insertMemberAuthority(memberDTO);
    }
}
