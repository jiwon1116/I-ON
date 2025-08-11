package com.spring.ion.yjw.service;

import com.spring.ion.jjh.repository.entrust.EntrustRepository;
import com.spring.ion.jjh.repository.free.FreeRepository;
import com.spring.ion.jjh.repository.miss.MissRepository;
import com.spring.ion.jjh.service.entrust.EntrustService;
import com.spring.ion.jjh.service.free.FreeService;
import com.spring.ion.jjh.service.miss.MissService;
import com.spring.ion.yjw.dto.ReportDTO;
import com.spring.ion.yjw.repository.FlagRepository;
import com.spring.ion.yjw.repository.ReportRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReportService {
    private final ReportRepository reportRepository;
    private final FreeService freeService;
    private final FlagService flagService;
    private final EntrustService entrustService;
    private final MissService missService;

    public Long saveReport(ReportDTO dto) {
        reportRepository.insertReport(dto);
        return dto.getId();
    }

    public List<ReportDTO> findAllForAdmin() {
        return reportRepository.findAllOrderByNewest();
    }

    public List<ReportDTO> findAllForAdminByBoard(String board) {
        return reportRepository.findByBoard(board); // FLAG/FREE/ENTRUST/MISS
    }

    public ReportDTO findOne(Long id) {
        return reportRepository.findById(id);
    }

    public void updateStatus(Long id, String status) { // PENDING/APPROVED/REJECTED
        reportRepository.updateStatus(id, status);
    }

    public int approve(Long id) {
        ReportDTO r = reportRepository.findById(id);
        if (r == null) throw new IllegalArgumentException("신고를 찾을 수 없습니다. id=" + id);

        Long targetId = r.getTargetContentId(); // = 각 게시판 글 PK
        switch (r.getTargetBoard()) {
            case "FREE":
                freeService.delete(targetId);      // public void delete(long clickId)
                break;
            case "FLAG":
                flagService.delete(Math.toIntExact(targetId));
                break;
            case "ENTRUST":
                entrustService.delete(targetId);
                break;
            case "MISS":
                missService.delete(targetId);
                break;
            default:
                throw new IllegalStateException("알 수 없는 게시판: " + r.getTargetBoard());
        }

        reportRepository.updateStatus(id, "APPROVED");
        return 1;
    }
    public List<ReportDTO> findPending() {
        return reportRepository.findPending();
    }

    public List<ReportDTO> findPendingByBoard(String board) {
        return reportRepository.findPendingByBoard(board); // Repository & Mapper에 추가 필요
    }



}
