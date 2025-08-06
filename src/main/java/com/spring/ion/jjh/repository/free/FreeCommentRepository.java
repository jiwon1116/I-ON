package com.spring.ion.jjh.repository.free;

import com.spring.ion.jjh.dto.free.FreeCommentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class FreeCommentRepository {
    private final SqlSessionTemplate sql;
    public void save(FreeCommentDTO commentDTO) {
        sql.insert("FreeComment.save", commentDTO);
    }

    public List<FreeCommentDTO> findAll(long postId) {
        return sql.selectList("FreeComment.findAll", postId);
    }

    public FreeCommentDTO findById(long id) {
        return sql.selectOne("FreeComment.findById", id);
    }

    public void delete(long id) {
        sql.delete("FreeComment.delete", id);
    }

    public List<FreeCommentDTO> findAllByUserId(String nickname) {
        return sql.selectList("FreeComment.findAllByUserId", nickname);
    }
}
