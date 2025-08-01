package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.FlagPostDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class FlagRepository {
    private final SqlSessionTemplate sql;


    public int write(FlagPostDTO flag_postDTO) {
        return sql.insert("Flag.write", flag_postDTO);
    }

    public List<FlagPostDTO> findAll() {
        return sql.selectList("Flag.findAll");
    }
}
