package com.spring.ion.lcw.repository;

import com.spring.ion.lcw.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.*;

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
    // 작성자 제외한 같은 지역에 사는 회원 조회
    public List<MemberDTO> findByRegionExceptWriter(String city,String district, String writerNickname) {
        Map<String, String> params = new HashMap<>();
        params.put("city", city);
        params.put("district", district);
        params.put("writerNickname", writerNickname);

        return sql.selectList("Member.findByRegionExceptWriter", params);
    }



    // 재학증명서 -yjw
    public int markVerified(String userId){
        return sql.update("Member.markVerified", userId); // ← namespace.id 맞추기
    }

    // 뱃지 기능 추가 yjw
    public Map<String, Integer> findLevelsByNicknames(List<String> names) {
        if (names == null || names.isEmpty()) return Collections.emptyMap();
        List<Map<String, Object>> rows = sql.selectList("Member.findLevelsByNicknames", names);
        Map<String, Integer> out = new HashMap<>();
        for (Map<String, Object> r : rows) {
            String nickname = (String) r.get("nickname");
            Object lvl = r.get("level");
            if (nickname != null && lvl != null) out.put(nickname, ((Number) lvl).intValue());
        }
        return out;
    }

    /** 단건 레벨 */
    public Integer findLevelByNickname(String nickname) {
        if (nickname == null || nickname.isBlank()) return null;
        return sql.selectOne("Member.findLevelByNickname", nickname);
    }

    /** 닉네임 → {level, admin} */
    public Map<String, Map<String, Object>> findBadgeMetaByNicknames(List<String> names) {
        if (names == null || names.isEmpty()) return Collections.emptyMap();
        List<Map<String, Object>> rows = sql.selectList("Member.findBadgeMetaByNicknames", names);
        Map<String, Map<String, Object>> out = new HashMap<>();
        for (Map<String, Object> r : rows) {
            String nick = (String) r.get("nickname");
            int level = ((Number) r.get("level")).intValue();
            boolean admin = ((Number) r.get("is_admin")).intValue() == 1;
            Map<String, Object> meta = new HashMap<>();
            meta.put("level", level);
            meta.put("admin", admin);
            out.put(nick, meta);
        }
        return out;
    }

    /** 단건: 관리자 여부 */
    public boolean isAdminByNickname(String nickname) {
        Integer v = sql.selectOne("Member.isAdminByNickname", nickname);
        return v != null && v == 1;
    }


    public int checkDuplicateUserId(String userId) {
        return sql.selectOne("Member.checkDuplicateUserId", userId);
    }

    public int checkDuplicateNickname(String nickname) {
        return sql.selectOne("Member.checkDuplicateNickname", nickname);
    }
}

