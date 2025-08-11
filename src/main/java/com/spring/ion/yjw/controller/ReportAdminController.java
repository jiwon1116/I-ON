package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.ReportDTO;
import com.spring.ion.yjw.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Set;

@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportAdminController {

    private final ReportService reportService;

    @PostMapping
    @ResponseBody
    public ResponseEntity<Void> newReport(@RequestBody ReportDTO dto) {
        String reporterId = SecurityContextHolder.getContext().getAuthentication().getName();
        dto.setReporterId(reporterId);

        reportService.saveReport(dto);
        return ResponseEntity.ok().build();
    }

    // 목록 화면
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String board, Model model) {
        if (board == null) {
            // 승인 대기(PENDING)인 건만
            model.addAttribute("reportList", reportService.findPending());
        } else {
            model.addAttribute("reportList", reportService.findPendingByBoard(board));
        }
        return "jjh/reportList";
    }

    // 신고 승인 + 원글 삭제
    @PostMapping("/{id}/approve")
    public String approve(@PathVariable Long id, RedirectAttributes ra) {
        reportService.approve(id);
        ra.addFlashAttribute("editSuccess", "신고 승인 처리 및 원글 삭제가 완료되었습니다.");
        return "redirect:/report/list";
    }

    // 반려
    @PostMapping("/{id}/reject")
    public String reject(@PathVariable Long id, RedirectAttributes ra) {
        reportService.updateStatus(id, "REJECTED");
        ra.addFlashAttribute("editSuccess", "신고를 반려했습니다.");
        return "redirect:/report/list";
    }

}
