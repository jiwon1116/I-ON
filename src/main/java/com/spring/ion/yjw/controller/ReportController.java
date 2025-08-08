package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.ReportDTO;
import com.spring.ion.yjw.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/flag")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @PostMapping("/report")
    public String report(@RequestBody ReportDTO dto, HttpSession session) {
        Long userId = (Long) session.getAttribute("loginId"); // userId (PK) 기준!
        if (userId == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }
        dto.setReporterId(userId);
        dto.setStatus("PENDING");
        dto.setType("ABUSE"); // 예시, 실제 프론트에서 받아오는 값으로 설정하세요
        // targetType/targetId/content는 프론트에서 받는 값 사용
        reportService.saveReport(dto);
        return "OK";
    }
}



