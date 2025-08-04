package com.spring.ion.psw.repository;

import com.spring.ion.psw.dto.Info_commentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class Info_commentRepository {
    private final SqlSessionTemplate sql;

    public void save(Info_commentDTO infoCommentDTO) {
        int result=  sql.insert("infoComment.save", infoCommentDTO);
        System.out.println("댓글 저장 완료:"+result);

    }

    // 댓글 불러오기
    public List<Info_commentDTO> findAll(long postId) {
        return sql.selectList("infoComment.findAll", postId);
    }
}
