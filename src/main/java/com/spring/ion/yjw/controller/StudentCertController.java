// src/main/java/com/spring/ion/yjw/controller/StudentCertController.java
package com.spring.ion.yjw.controller;

import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.yjw.dto.StudentCertDTO;
import com.spring.ion.yjw.service.StudentCertService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;                 // ★ RestController 아님
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/cert")
public class StudentCertController {

    private final StudentCertService service;

    // 폼 화면: /WEB-INF/views/yjw/certUpload.jsp 렌더링
    @GetMapping("/upload")
    public String uploadForm(org.springframework.ui.Model model) {
        String userId = resolveUserId();
        if (userId == null) return "redirect:/login";
        return "yjw/certUpload";
    }


    // StudentCertController

    @GetMapping("/my")
    public String myList(org.springframework.ui.Model model){
        String userId = resolveUserId();
        if (userId == null) return "redirect:/login"; // 로그인 필요
        model.addAttribute("items", service.findByUser(userId));
        return "yjw/certMyList";
    }



    // 업로드(사용자)
    @PostMapping("/upload")
    @ResponseBody
    public Map<String, Object> upload(@RequestParam("file") MultipartFile file,
                                      @RequestParam("childName") String childName,
                                      @RequestParam("childBirth") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate childBirth,
                                      @RequestParam(value = "childAge", required = false) Integer childAge,
                                      @RequestParam(value = "childSchool", required = false) String childSchool,
                                      @RequestParam(value = "childGrade", required = false) String childGrade) {
        Map<String, Object> res = new HashMap<>();
        String userId = resolveUserId();
        if (userId == null) {
            res.put("error", "로그인이 필요합니다.");
            return res;
        }

        // 서버에서도 나이 재계산
        int calcAge = (childAge != null) ? childAge :
                LocalDate.now().getYear() - childBirth.getYear()
                        - (LocalDate.now().getDayOfYear() < childBirth.withYear(LocalDate.now().getYear()).getDayOfYear() ? 1 : 0);

        // 서비스에 전달할 DTO 구성
        StudentCertDTO dto = new StudentCertDTO();
        dto.setUserId(userId);
        dto.setChildName(childName);
        dto.setChildBirth(childBirth);
        dto.setChildAge(calcAge);
        dto.setChildSchool(childSchool);
        dto.setChildGrade(childGrade);

        service.upload(file, dto); // 서비스 시그니처 변경

        res.put("message", "재학증명서가 접수되었습니다.");
        return res;
    }

    @GetMapping("/admin/list")
    public String legacyListForward() {
        return "forward:/admin/certs";
    }

    @GetMapping("/admin/{id}/page")
    public String legacyDetailForward(@PathVariable Long id) {
        return "forward:/admin/certs/" + id;
    }

    @GetMapping("/admin/{id}") @ResponseBody
    public Map<String, Object> detail(@PathVariable Long id) {
        Map<String, Object> res = new HashMap<>();
        res.put("detail", service.detail(id));
        return res;
    }

    @PostMapping("/admin/{id}/approve") @ResponseBody
    public Map<String, Object> approve(@PathVariable Long id,
                                       @RequestParam("reviewer") String reviewer) {
        Map<String, Object> res = new HashMap<>();
        service.approve(id, reviewer);
        res.put("ok", true);
        return res;
    }

    @PostMapping("/admin/{id}/reject") @ResponseBody
    public Map<String, Object> reject(@PathVariable Long id,
                                      @RequestParam("reviewer") String reviewer,
                                      @RequestParam("reason") String reason) {
        Map<String, Object> res = new HashMap<>();
        service.reject(id, reason, reviewer);
        res.put("ok", true);
        return res;
    }

    private String resolveUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Object principal = (authentication != null) ? authentication.getPrincipal() : null;
        if (principal instanceof CustomUserDetails) {
            return ((CustomUserDetails) principal).getUsername();
        } else if (principal instanceof org.springframework.security.core.userdetails.User) {
            return ((org.springframework.security.core.userdetails.User) principal).getUsername();
        } else if (principal instanceof String) {
            String p = (String) principal;
            return "anonymousUser".equals(p) ? null : p;
        }
        return null;
    }
}
