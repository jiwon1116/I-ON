package com.spring.ion.yjw.controller;

import com.spring.ion.lcw.repository.MemberRepository;
import com.spring.ion.yjw.service.TrustScoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/member")
public class MemberLevelApi {

    private final MemberRepository memberRepository;   // 닉네임 → 레벨/관리자여부
    private final TrustScoreService trustScoreService; // 신뢰도 계산 & 저장

    /** 기존: 레벨만 */
    @GetMapping("/levels")
    public Map<String, Integer> levels(@RequestParam String nicknames) {
        var names = Arrays.stream(nicknames.split(","))
                .map(String::trim).filter(s -> !s.isEmpty()).distinct()
                .collect(Collectors.toList());

        var map = memberRepository.findLevelsByNicknames(names); // {nick -> level}

        // 누락된 닉네임은 즉석 계산 후 응답 보정
        for (String n : names) {
            if (!map.containsKey(n)) {
                var dto = trustScoreService.getTrustScore(n); // 내부에서 trust_score 반영
                int lv = dto.getTotalScore() >= 30 ? 3 : (dto.getTotalScore() >= 10 ? 2 : 1);
                map.put(n, lv);
            }
        }
        return map;
    }

    /** 신규: 레벨 + 관리자 여부 (badge.js가 이걸 사용) */
    @GetMapping("/badges")
    public Map<String, Map<String, Object>> badges(@RequestParam String nicknames) {
        var names = Arrays.stream(nicknames.split(","))
                .map(String::trim).filter(s -> !s.isEmpty()).distinct()
                .collect(Collectors.toList());
        if (names.isEmpty()) return Collections.emptyMap();

        // 1) DB에서 일괄 조회
        var meta = memberRepository.findBadgeMetaByNicknames(names); // {nick -> {level, admin}}

        // 2) 누락된 닉네임은 즉석 계산(레벨), 관리자 여부는 단건 조회
        for (String n : names) {
            if (!meta.containsKey(n)) {
                var dto = trustScoreService.getTrustScore(n); // trust_score 업데이트
                int lv = dto.getTotalScore() >= 30 ? 3 : (dto.getTotalScore() >= 10 ? 2 : 1);
                boolean isAdmin = memberRepository.isAdminByNickname(n);
                var row = new HashMap<String, Object>();
                row.put("level", lv);
                row.put("admin", isAdmin);
                meta.put(n, row);
            }
        }
        return meta;
    }
}
