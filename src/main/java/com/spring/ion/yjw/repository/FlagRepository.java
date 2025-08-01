package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.FlagPostDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class FlagRepository {
    private final SqlSessionTemplate sql;


    public int write(FlagPostDTO flagPostDTO) {
        return sql.insert("Flag.write", flagPostDTO);
    }

    public List<FlagPostDTO> findAll() {
        return sql.selectList("Flag.findAll");
    }

    public FlagPostDTO findById(int id) {
        return sql.selectOne("Flag.findById",id);
    }

    public int update(FlagPostDTO flagPostDTO) {
        return sql.update("Flag.update",flagPostDTO);
    }

    public void delete(int id) {
         sql.delete("Flag.delete",id);
    }

    public List<FlagPostDTO> pagingList(Map<String, Integer> pagingParams) {
        return sql.selectList("Flag.pagingList", pagingParams);
    }

    public int flagCount() {
        return sql.selectOne("Flag.flagCount");
    }
}
