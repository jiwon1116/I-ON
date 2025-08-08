package com.spring.ion.lcw.repository;

import com.spring.ion.lcw.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    public void edit(MemberDTO memberDTO){
        sql.update("Member.updateMember", memberDTO);
    }

    public void unban(MemberDTO memberDTO) {
        sql.update("Member.unban", memberDTO);
    }

/*    // 작성자 제외한 같은 지역에 사는 회원 조회
    public List<MemberDTO> findByRegionExceptWriter(String city, String writerNickname) {
        Map<String, String> params = new HashMap<>();
        params.put("city", city);
        params.put("writerNickname", writerNickname);

        return sql.selectList("Member.findByRegionExceptWriter", params);
    }*/
}
