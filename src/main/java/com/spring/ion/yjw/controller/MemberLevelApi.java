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

    private final MemberRepository memberRepository;
    private final TrustScoreService trustScoreService;

    @GetMapping("/levels")
    public Map<String, Integer> levels(@RequestParam String nicknames) {
        var names = Arrays.stream(nicknames.split(","))
                .map(String::trim).filter(s -> !s.isEmpty()).distinct()
                .collect(Collectors.toList());
        var map = memberRepository.findLevelsByNicknames(names);
        if (map == null) map = new HashMap<>();
        for (String n : names) {
            if (!map.containsKey(n)) {
                var dto = trustScoreService.getTrustScore(n);
                int lv = dto.getTotalScore() >= 30 ? 3 : (dto.getTotalScore() >= 10 ? 2 : 1);
                map.put(n, lv);
            }
        }
        return map;
    }

    @GetMapping("/badges")
    public Map<String, Map<String, Object>> badges(@RequestParam String nicknames) {
        var names = Arrays.stream(nicknames.split(","))
                .map(String::trim).filter(s -> !s.isEmpty()).distinct()
                .collect(Collectors.toList());
        if (names.isEmpty()) return Collections.emptyMap();

        var meta = memberRepository.findBadgeMetaByNicknames(names);
        if (meta == null) meta = new HashMap<>();

        for (String n : names) {
            if (!meta.containsKey(n)) {
                var dto = trustScoreService.getTrustScore(n);
                int lv = dto.getTotalScore() >= 30 ? 3 : (dto.getTotalScore() >= 10 ? 2 : 1);
                boolean isAdmin = Boolean.TRUE.equals(memberRepository.isAdminByNickname(n));
                var row = new HashMap<String, Object>();
                row.put("level", lv);
                row.put("admin", isAdmin);
                meta.put(n, row);
            } else {
                var row = meta.get(n);
                if (row.get("level") == null) {
                    var dto = trustScoreService.getTrustScore(n);
                    int lv = dto.getTotalScore() >= 30 ? 3 : (dto.getTotalScore() >= 10 ? 2 : 1);
                    row.put("level", lv);
                }
                Object admin = row.get("admin");
                boolean isAdmin = (admin instanceof Boolean) ? (Boolean) admin
                        : "1".equals(String.valueOf(admin)) || "Y".equals(admin) || "true".equalsIgnoreCase(String.valueOf(admin));
                row.put("admin", isAdmin);
            }
        }
        return meta;
    }
}
