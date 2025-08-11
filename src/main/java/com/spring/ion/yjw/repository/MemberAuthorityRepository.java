// src/main/java/com/spring/ion/yjw/repository/MemberAuthorityRepository.java
package com.spring.ion.yjw.repository;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class MemberAuthorityRepository {
    private final SqlSessionTemplate sql;

    public void replaceToAuthMember(String userId){
        Map<String,Object> p = Map.of("userId", userId);

        // 1) 우선 UPDATE로 승격
        int updated = sql.update("MemberAuthority.promoteToAuthMember", p);

        // 2) 기존 ROLE_MEMBER가 없던 사용자라면 추가
        if (updated == 0) {
            sql.insert("MemberAuthority.insertRoleAuthMember", p);
        }

        // (선호 시) 안전하게 한 번 더 정리
        // sql.delete("MemberAuthority.deleteRoleMember", p);
    }
}


