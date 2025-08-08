package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.ReportDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class ReportRepository {

    private final SqlSessionTemplate sql;

    public void insertReport(ReportDTO dto) {
        sql.insert("Report.insertReport", dto);

    }
}
