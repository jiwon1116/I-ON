// src/main/java/com/spring/ion/yjw/service/StudentCertService.java
package com.spring.ion.yjw.service;

import com.spring.ion.lcw.repository.MemberRepository;
import com.spring.ion.yjw.dto.StudentCertDTO;
import com.spring.ion.yjw.repository.MemberAuthorityRepository;
import com.spring.ion.yjw.repository.StudentCertRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class StudentCertService {
    private final StudentCertRepository certRepo;
    private final MemberAuthorityRepository authRepo;
    private final MemberRepository memberRepo;

    private static final String UPLOAD_DIR = "C:/upload/cert";

    public void upload(MultipartFile file, StudentCertDTO dto) {
        if (file == null || file.isEmpty())
            throw new IllegalArgumentException("파일 필수입니다.");
        String ct = file.getContentType();
        if (ct == null || !ct.startsWith("image/"))
            throw new IllegalArgumentException("이미지 파일만 허용합니다.");

        try {
            Path dir = Paths.get(UPLOAD_DIR);
            Files.createDirectories(dir);

            String originalName = Optional.ofNullable(file.getOriginalFilename()).orElse("unknown");
            String ext = "";
            int dot = originalName.lastIndexOf('.');
            if (dot > -1) ext = originalName.substring(dot + 1);

            String savedName = UUID.randomUUID() + (ext.isEmpty() ? "" : "." + ext);
            Path path = dir.resolve(savedName);
            file.transferTo(path.toFile());

            dto.setFilePath(path.toString());
            dto.setStatus("PENDING");
            // reviewer/rejectReason는 기본 null 유지

            certRepo.insert(dto);

        } catch (IOException e) {
            throw new RuntimeException("파일 저장 중 오류", e);
        }
    }

    public List<StudentCertDTO> pending() { return certRepo.findPending(); }
    public StudentCertDTO detail(Long id) { return certRepo.findDetail(id); }

    @Transactional
    public void approve(Long id, String reviewer) {
        StudentCertDTO d = certRepo.findDetail(id);
        if (d == null) throw new IllegalArgumentException("신청 없음");
        certRepo.approve(id, reviewer);
        authRepo.replaceToAuthMember(d.getUserId());
        memberRepo.markVerified(d.getUserId());
    }

    @Transactional
    public void reject(Long id, String reason, String reviewer) {
        StudentCertDTO d = certRepo.findDetail(id);
        if (d == null) throw new IllegalArgumentException("신청 없음");
        certRepo.reject(id, reason, reviewer);
    }

    public List<StudentCertDTO> findByUser(String userId) {
        return certRepo.findByUser(userId);
    }
}

