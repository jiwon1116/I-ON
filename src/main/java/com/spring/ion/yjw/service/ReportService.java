package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.ReportDTO;
import com.spring.ion.yjw.repository.ReportRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ReportService {
    private final ReportRepository reportRepository;

    public void saveReport(ReportDTO dto) {
        reportRepository.insertReport(dto);
    }
}
