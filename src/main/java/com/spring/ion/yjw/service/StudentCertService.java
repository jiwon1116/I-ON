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


            certRepo.insert(dto);

        } catch (IOException e) {
            throw new RuntimeException("파일 저장 중 오류", e);
        }
    }

    public List<StudentCertDTO> pending() {
        return certRepo.findPending();
    }

    public StudentCertDTO detail(Long id) {
        return certRepo.findDetail(id);
    }

    @Transactional
    public void approve(Long id, String reviewer) {
        var d = certRepo.findDetail(id);
        if (d == null) throw new IllegalArgumentException("신청 없음");
        if (!"PENDING".equals(d.getStatus())) throw new IllegalStateException("이미 처리된 건입니다.");

        int rows = certRepo.approveIfPending(id, reviewer);
        if (rows != 1) throw new IllegalStateException("승인 불가 상태입니다."); // 경합 방어

        // 권한/검증 변경
        authRepo.replaceToAuthMember(d.getUserId()); // 중복 insert 방지 로직도 같이 보완(INSERT IGNORE 또는 MERGE)
        memberRepo.markVerified(d.getUserId());
    }

    @Transactional
    public void reject(Long id, String reason, String reviewer) {
        var d = certRepo.findDetail(id);
        if (d == null) throw new IllegalArgumentException("신청 없음");
        if (!"PENDING".equals(d.getStatus())) throw new IllegalStateException("이미 처리된 건입니다.");

        int rows = certRepo.rejectIfPending(id, reason, reviewer);
        if (rows != 1) throw new IllegalStateException("반려 불가 상태입니다.");
    }

    @Transactional
    public void resubmit(MultipartFile file, StudentCertDTO dto) {
        var d = certRepo.findDetail(dto.getId());
        if (d == null) throw new IllegalArgumentException("신청 없음");
        if (!"REJECTED".equals(d.getStatus())) throw new IllegalStateException("반려건만 재제출 가능합니다.");
        if (!d.getUserId().equals(dto.getUserId())) throw new SecurityException("본인 건만 수정 가능");

        if (file != null && !file.isEmpty()) {
            try {
                Path dir = Paths.get(UPLOAD_DIR);
                Files.createDirectories(dir);

                String originalName = Optional.ofNullable(file.getOriginalFilename()).orElse("unknown");
                int dot = originalName.lastIndexOf('.');
                String ext = (dot > -1) ? originalName.substring(dot + 1) : "";
                String savedName = UUID.randomUUID() + (ext.isEmpty() ? "" : "." + ext);

                Path path = dir.resolve(savedName);
                file.transferTo(path.toFile());                               // ✅ IOException 처리 필요
                dto.setFilePath(path.toString());
            } catch (IOException e) {
                throw new RuntimeException("파일 저장 중 오류", e);
            }
        } else {
            dto.setFilePath(d.getFilePath());
        }

        int rows = certRepo.resubmit(dto);
        if (rows != 1) throw new IllegalStateException("재제출 실패");
    }


    public List<StudentCertDTO> findByUser(String userId) {
        return certRepo.findByUser(userId);
    }

    public List<StudentCertDTO> findAll() {
        return certRepo.findAll();
    }
    public List<StudentCertDTO> findAllByStatus(String status) {
        if (status == null || "ALL".equalsIgnoreCase(status)) return certRepo.findAll();
        return certRepo.findAllByStatus(status);
    }




}

