package com.spring.ion.lcw.mapper;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class MemberRepository {
    public final SqlSessionTemplate sql;

    public void save(MemberDTO memberDTO) {
        sql.insert("Member.insertMember", memberDTO);
        sql.insert("Member.insertMemberAuthority", memberDTO);

    }

    public void delete(String username) {
        sql.delete("Member.deleteMemberAuthorities", username);
        sql.delete("Member.deleteMember", username);

    }

    public MemberDTO findByUserId(String username) {
        return sql.selectOne("Member.findByUserId", username);
    }

    public MemberDTO findByUserIdWithAuthorities(String username) {
        return sql.selectOne("Member.findByUserIdWithAuthorities", username);
    }
}
