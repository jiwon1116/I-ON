package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.ReportDTO;
import com.spring.ion.yjw.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Set;

@RestController
@RequestMapping
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    // 프론트는 각 게시판에서 /flag/report, /free/report ... 로 그대로 POST
    @PostMapping(value = {"/flag/report", "/free/report", "/entrust/report", "/miss/report"},
            produces = "text/plain;charset=UTF-8")
    public ResponseEntity<String> report(@RequestBody ReportDTO dto, HttpServletRequest request) {
        // 로그인 사용자
        var auth = SecurityContextHolder.getContext().getAuthentication();
        var cud  = (com.spring.ion.lcw.security.CustomUserDetails) auth.getPrincipal();
        String userId = cud.getMemberDTO().getUserId();
        dto.setReporterId(userId);

        // URI에서 게시판명 추출 -> FLAG/FREE/ENTRUST/MISS
        String uri = request.getRequestURI();           // 예) /flag/report
        String board = uri.replaceFirst("^/+", "").split("/")[0].toUpperCase();
        Set<String> allowed = Set.of("FLAG", "FREE", "ENTRUST", "MISS");
        if (!allowed.contains(board)) {
            return ResponseEntity.badRequest().body("Invalid board");
        }
        dto.setTargetBoard(board);

        // 기본 상태
        dto.setStatus("PENDING");

        reportService.saveReport(dto);
        return ResponseEntity.ok("OK");
    }
}
