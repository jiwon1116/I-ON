package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.ReportDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ReportRepository {

    private final SqlSessionTemplate sql;

    public void insertReport(ReportDTO dto) {
        sql.insert("Report.insertReport", dto);
    }

    public ReportDTO findById(Long id) {
        return sql.selectOne("Report.findById", id);
    }

    public List<ReportDTO> findAllOrderByNewest() {
        return sql.selectList("Report.findAllOrderByNewest");
    }

    public List<ReportDTO> findByBoard(String board) {
        return sql.selectList("Report.findByBoard", board);
    }

    public List<ReportDTO> findPending() {
        return sql.selectList("Report.findPending");
    }

    public int updateStatus(Long id, String status) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("status", status);
        return sql.update("Report.updateStatus", params);
    }

    public int delete(Long id) {
        return sql.delete("Report.delete", id);
    }

    public List<ReportDTO> findPendingByBoard(String board) {
        return sql.selectList("Report.findPendingByBoard", board);
    }

}
