package com.spring.ion.jjh.repository.entrust;

import com.spring.ion.jjh.dto.entrust.EntrustCommentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class EntrustCommentRepository {
    private final SqlSessionTemplate sql;
    public void save(EntrustCommentDTO commentDTO) {
        sql.insert("EntrustComment.save", commentDTO);
    }

    public List<EntrustCommentDTO> findAll(long postId) {
        return sql.selectList("EntrustComment.findAll", postId);
    }

    public EntrustCommentDTO findById(long id) {
        return sql.selectOne("EntrustComment.findById", id);
    }

    public void delete(long id) {
        sql.delete("EntrustComment.delete", id);
    }

    public List<EntrustCommentDTO> findAllByUserId(String userId) {
        return sql.selectList("EntrustComment.findAllByUserId", userId);
    }
}
