package com.spring.ion.jjh.repository.free;

import com.spring.ion.jjh.dto.free.FreeDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class FreeRepository {
    private final SqlSessionTemplate sql;

//    public List<FreeDTO> allFreeList() {
//        return sql.selectList("Free.allFreeList");
//    }

    public int write(FreeDTO freeDTO) {
        return sql.insert("Free.write", freeDTO);
    }
}
