package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.FlagDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class FlagRepository {
    private final SqlSessionTemplate sql;

    public int save(FlagDTO flagDTO) {
        return sql.insert("Flag.save",flagDTO);
    }
}
