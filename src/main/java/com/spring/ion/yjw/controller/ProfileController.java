package com.spring.ion.yjw.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.service.MemberService;
import com.spring.ion.lcw.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;

@Controller
public class ProfileController {

    @Autowired
    private MemberService memberService;

    @PostMapping("/profile/upload")
    @ResponseBody
    public Map<String, Object> uploadProfileImg(@RequestParam("profileImg") MultipartFile file) throws IOException {
        Map<String, Object> result = new HashMap<>();
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String userId = user.getUsername();

        String uploadDir = "C:/upload/profile/";
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String originalFileName = file.getOriginalFilename();
        String ext = originalFileName.substring(originalFileName.lastIndexOf('.'));
        String savedName = "profile_" + userId + "_" + System.currentTimeMillis() + ext;
        File dest = new File(uploadDir, savedName);
        file.transferTo(dest);

        // DB에 저장
        memberService.updateProfileImg(userId, savedName);

        // 응답 (이미지 뷰 경로 반환)
        result.put("profileImgUrl", "/profile/img/" + savedName);
        return result;
    }

    // 프로필 이미지 서빙
    @GetMapping("/profile/img/{filename}")
    public void serveProfileImg(@PathVariable String filename, HttpServletResponse response) throws IOException {
        String path = "C:/upload/profile/" + filename;
        File file = new File(path);

        if (file.exists()) {
            String mimeType = Files.probeContentType(file.toPath());
            response.setContentType(mimeType);
            FileInputStream fis = new FileInputStream(file);
            org.springframework.util.FileCopyUtils.copy(fis, response.getOutputStream());
            fis.close();
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}

