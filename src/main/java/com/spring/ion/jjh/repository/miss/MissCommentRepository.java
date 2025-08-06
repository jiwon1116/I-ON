package com.spring.ion.jjh.repository.miss;

import com.spring.ion.jjh.dto.miss.MissCommentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MissCommentRepository {
    private final SqlSessionTemplate sql;
    public void save(MissCommentDTO commentDTO) {
        sql.insert("MissComment.save", commentDTO);
    }

    public List<MissCommentDTO> findAll(long postId) {
        return sql.selectList("MissComment.findAll", postId);
    }

    public MissCommentDTO findById(long id) {
        return sql.selectOne("MissComment.findById", id);
    }

    public void delete(long id) {
        sql.delete("MissComment.delete", id);
    }

    public List<MissCommentDTO> findAllByUserId(String userId) {
        return sql.selectList("MissComment.findAllByUserId", userId);
    }
}
