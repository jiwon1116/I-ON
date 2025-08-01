package com.spring.ion.psw.repository;

import com.spring.ion.psw.dto.Info_contentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class Info_contentRepository {

    public final SqlSessionTemplate sql;

    public List<Info_contentDTO> AllfindList() {
       return sql.selectList("Info.allInfoList");
    }

    //게시물 추가
    public int save(Info_contentDTO infoContentDTO) {
        return sql.insert("Info.save",infoContentDTO);
    }


    public Info_contentDTO findContext(long id) {
        return sql.selectOne("Info.find",id);
    }

    //게시물 수정
    public int update(Info_contentDTO infoContentDTO) {
        return sql.update("Info.update",infoContentDTO);
    }
}
