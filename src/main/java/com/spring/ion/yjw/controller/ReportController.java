package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.ReportDTO;
import com.spring.ion.yjw.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/flag")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @PostMapping("/report")
    public ResponseEntity<String> report(@RequestBody ReportDTO dto) {

        if (dto.getTargetId() == null) {
            return ResponseEntity.badRequest().body("대상 ID가 필요합니다.");
        }
        if (!StringUtils.hasText(dto.getType())) {
            return ResponseEntity.badRequest().body("신고 유형을 선택해주세요.");
        }
        if (!StringUtils.hasText(dto.getContent())) {
            return ResponseEntity.badRequest().body("신고 사유를 입력해주세요.");
        }

        dto.setStatus("PENDING"); // 접수 대기 상태

        reportService.saveReport(dto);

        return ResponseEntity.ok("OK");
    }
}
