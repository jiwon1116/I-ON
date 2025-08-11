package com.spring.ion.lcw.repository;

import com.spring.ion.lcw.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
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
    public MemberDTO findById(Long id) {
        return sql.selectOne("Member.findById", id);
    }
    public MemberDTO findByUserId(String username) {
        return sql.selectOne("Member.findByUserId", username);
    }
    public MemberDTO findByNickname(String nickname){
        return sql.selectOne("Member.findByNickname", nickname);
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

    public void updateProfileImg(String userId, String profileImg) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("profileImg", profileImg);
        sql.update("Member.updateProfileImg", param);
    }
}
