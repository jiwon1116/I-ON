// src/main/java/com/spring/ion/yjw/repository/StudentCertRepository.java
package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.StudentCertDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class StudentCertRepository {
    private final SqlSessionTemplate sql;

    public void insert(StudentCertDTO dto) {
        sql.insert("StudentCert.insert", dto);
    }

    public List<StudentCertDTO> findPending() {
        return sql.selectList("StudentCert.findPending");
    }

    public StudentCertDTO findDetail(Long id) {
        return sql.selectOne("StudentCert.findDetail", id);
    }

    public void approve(Long id, String reviewer) {
        Map<String,Object> p = new HashMap<>();
        p.put("id", id);
        p.put("reviewer", reviewer);
        sql.update("StudentCert.approve", p);
    }

    public void reject(Long id, String reason, String reviewer) {
        Map<String,Object> p = new HashMap<>();
        p.put("id", id);
        p.put("reason", reason);
        p.put("reviewer", reviewer);
        sql.update("StudentCert.reject", p);
    }

    public List<StudentCertDTO> findByUser(String userId) {
        return sql.selectList("StudentCert.findByUser", userId);
    }
}
