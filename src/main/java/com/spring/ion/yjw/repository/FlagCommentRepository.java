package com.spring.ion.yjw.repository;

import com.spring.ion.jjh.dto.free.FreeCommentDTO;
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


    public List<FlagCommentDTO> findAll(long post_id) {
        return sql.selectList("FlagComment.findAll", post_id);
    }


    public void write(FlagCommentDTO flagCommentDTO) {
        sql.insert("FlagComment.write", flagCommentDTO);
    }


    public int delete(long id) {
        return sql.delete("FlagComment.delete", id);
    }


    public FlagCommentDTO findById(long id) {
        return sql.selectOne("FlagComment.findById", id);
    }


    public List<FlagCommentDTO> findAllByUserId(String nickname) {
        return sql.selectList("FlagComment.findAllByUserId", nickname);
    }
}
