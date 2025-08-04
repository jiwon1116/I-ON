package com.spring.ion.jjh.repository.free;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class FreeLikeRepository {
    private final SqlSessionTemplate sql;

    public boolean exists(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        int count = sql.selectOne("FreeLike.exists", param);
        return count > 0;
    }

    public void insert(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        sql.insert("FreeLike.insert", param);
    }

    public void delete(Long postId, String memberId) {
        Map<String, Object> param = new HashMap<>();
        param.put("postId", postId);
        param.put("memberId", memberId);
        sql.delete("FreeLike.delete", param);
    }


    public int count(Long postId) {
        return sql.selectOne("FreeLike.count", postId);
    }
}
