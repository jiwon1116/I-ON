package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class FlagCommentRepository {
    private final SqlSessionTemplate sql;


    public List<FlagCommentDTO> findAll(long postId) {
        return sql.selectList("FlagComment.findAll", postId);
    }


    public void write(FlagCommentDTO flagCommentDTO) {
        sql.insert("FlagComment.write", flagCommentDTO);
    }


    public int delete(Long id) {
        return sql.delete("FlagComment.delete", id);
    }


}
