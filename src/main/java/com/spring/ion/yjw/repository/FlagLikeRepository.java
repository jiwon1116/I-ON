package com.spring.ion.yjw.repository;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class FlagLikeRepository {
    private final SqlSessionTemplate sql;

    public boolean exists(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        int count = sql.selectOne("FlagLikeMapper.exists", param);
        return count > 0;
    }

    public void insert(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        sql.insert("FlagLikeMapper.insert", param);
    }

    public void delete(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        sql.delete("FlagLikeMapper.delete", param);
    }

    public int count(Long postId) {
        return sql.selectOne("FlagLikeMapper.count", postId);
    }

    public void updateLikeCount(Long postId) {
        sql.update("FlagLikeMapper.updateLikeCount", postId);
    }

}
