// src/main/java/com/spring/ion/yjw/repository/MemberAuthorityRepository.java
package com.spring.ion.yjw.repository;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository
@RequiredArgsConstructor
public class MemberAuthorityRepository {
    private final SqlSessionTemplate sql;

    public void replaceToAuthMember(String userId){
        Map<String,Object> p = Map.of("userId", userId);

        int updated = sql.update("MemberAuthority.promoteToAuthMember", p);

        if (updated == 0) {
            sql.insert("MemberAuthority.insertRoleAuthMember", p);
        }
    }
}


