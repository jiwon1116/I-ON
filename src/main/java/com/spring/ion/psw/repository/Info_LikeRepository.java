package com.spring.ion.psw.repository;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class Info_LikeRepository {
    private final SqlSessionTemplate sql;

    public boolean exists(Long findId, String memberId) {

        Map<String, Object> param = new HashMap<>();
        param.put("findId", findId);
        param.put("memberId", memberId);
        int count = sql.selectOne("InfoLikeMapper.exists", param);
        return count > 0;
    }

    public void insert(Long findId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("findId", findId);
        param.put("memberId", memberId);
        sql.insert("InfoLikeMapper.insert", param);
    }

    public void delete(Long findId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("findId", findId);
        param.put("memberId", memberId);
        sql.delete("InfoLikeMapper.delete", param);
    }

    public int count(Long findId) {
        return sql.selectOne("InfoLikeMapper.count", findId);
    }

    public void updateLikeCount(Long findId) {
        sql.update("InfoLikeMapper.infoUpdateLikeCount", findId);
    }
}
