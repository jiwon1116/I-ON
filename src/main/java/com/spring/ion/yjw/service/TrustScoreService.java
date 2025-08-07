package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.TrustScoreDTO;
import com.spring.ion.yjw.repository.TrustScoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TrustScoreService {
    private final TrustScoreRepository trustScoreRepository;

    public TrustScoreDTO getTrustScore(String nickname) {
        int commentCount = trustScoreRepository.countAllCommentsByNickname(nickname);
        int reportCount = trustScoreRepository.countAllReportsByNickname(nickname);
        int entrustCount = trustScoreRepository.countAllEntrustsByNickname(nickname);

        int total = commentCount + reportCount + entrustCount;
        String grade;
        if (total >= 30) grade = "캡숑맘";
        else if (total >= 10) grade = "도토리맘";
        else grade = "새싹맘";

        TrustScoreDTO dto = new TrustScoreDTO();
        dto.setNickname(nickname);
        dto.setCommentCount(commentCount);
        dto.setReportCount(reportCount);
        dto.setEntrustCount(entrustCount);
        dto.setTotalScore(total);
        dto.setGrade(grade);
        return dto;
    }
}
