package com.spring.ion.jjh.repository.entrust;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class EntrustLikeRepository {
    private final SqlSessionTemplate sql;

    public boolean exists(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        int count = sql.selectOne("EntrustLike.exists", param);
        return count > 0;
    }

    public void insert(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        sql.insert("EntrustLike.insert", param);
    }

    public void delete(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        sql.delete("EntrustLike.delete", param);
    }


    public int count(Long postId) {
        return sql.selectOne("EntrustLike.count", postId);
    }
}
