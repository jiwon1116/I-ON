package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class FlagCommentRepository {
    private final SqlSessionTemplate sql;


    public List<FlagCommentDTO> findAll(int id) {
        return sql.selectList("Comment.findAll",id);
    }

    public void write(FlagCommentDTO flagCommentDTO) {
        sql.insert("Comment.write", flagCommentDTO);
    }
}
