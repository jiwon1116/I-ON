package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.FlagDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class FlagRepository {
    private final SqlSessionTemplate sql;


    public List<FlagDTO> findAll() {
        return sql.selectList("Flag.findAll");
    }


    public int save(FlagDTO flagDTO) {
        return sql.insert("Flag.save", flagDTO);
    }
}
