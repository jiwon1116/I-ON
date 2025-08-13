package com.spring.ion.yjw.controller;

import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.yjw.dto.StudentCertDTO;
import com.spring.ion.yjw.service.StudentCertService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/cert")
public class StudentCertController {

    private final StudentCertService service;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("all",      service.findAll());
        model.addAttribute("pending",  service.findAllByStatus("PENDING"));
        model.addAttribute("approved", service.findAllByStatus("APPROVED"));
        model.addAttribute("rejected", service.findAllByStatus("REJECTED"));
        return "yjw/certList";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        model.addAttribute("detail", service.detail(id));
        return "yjw/certDetail";
    }

    @GetMapping("/upload")
    public String uploadForm(Model model) {
        String userId = resolveUserId();
        if (userId == null) return "redirect:/login";
        return "yjw/certUpload";
    }

    @GetMapping("/my")
    public String myList(Model model) {
        String userId = resolveUserId();
        if (userId == null) return "redirect:/login";
        model.addAttribute("items", service.findByUser(userId));
        return "yjw/certMyList";
    }

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

        int calcAge = (childAge != null) ? childAge :
                LocalDate.now().getYear() - childBirth.getYear()
                        - (LocalDate.now().getDayOfYear()
                        < childBirth.withYear(LocalDate.now().getYear()).getDayOfYear() ? 1 : 0);

        StudentCertDTO dto = new StudentCertDTO();
        dto.setUserId(userId);
        dto.setChildName(childName);
        dto.setChildBirth(childBirth);
        dto.setChildAge(calcAge);
        dto.setChildSchool(childSchool);
        dto.setChildGrade(childGrade);

        service.upload(file, dto);
        res.put("message", "재학증명서가 접수되었습니다.");
        return res;
    }


    @GetMapping("/admin/list")
    public String legacyListRedirect() {
        return "redirect:/cert";
    }

    @GetMapping("/admin/{id}/page")
    public String legacyDetailRedirect(@PathVariable Long id) {
        return "redirect:/cert/" + id;
    }

    @GetMapping("/admin/{id}")
    @ResponseBody
    public Map<String, Object> detailJson(@PathVariable Long id) {
        Map<String, Object> res = new HashMap<>();
        res.put("detail", service.detail(id));
        return res;
    }

    @PostMapping("/admin/{id}/approve")
    @ResponseBody
    public Map<String,Object> approve(@PathVariable Long id,
                                      @RequestParam("reviewer") String reviewer) {
        Map<String,Object> res = new HashMap<>();
        try {
            service.approve(id, reviewer);
            res.put("ok", true);
        } catch (Exception e) {
            res.put("ok", false);
            res.put("error", e.getMessage());
        }
        return res;
    }

    @PostMapping("/admin/{id}/reject")
    @ResponseBody
    public Map<String, Object> reject(@PathVariable Long id,
                                      @RequestParam("reviewer") String reviewer,
                                      @RequestParam("reason") String reason) {
        Map<String, Object> res = new HashMap<>();
        service.reject(id, reason, reviewer);
        res.put("ok", true);
        return res;
    }


    @PostMapping("/{id}/resubmit")
    @ResponseBody
    public Map<String,Object> resubmit(@PathVariable Long id,
                                       @RequestParam(value="file", required=false) MultipartFile file,
                                       @RequestParam("childName") String childName,
                                       @RequestParam("childBirth") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate childBirth,
                                       @RequestParam(value="childSchool", required=false) String childSchool,
                                       @RequestParam(value="childGrade", required=false) String childGrade) {
        Map<String,Object> res = new HashMap<>();
        String userId = resolveUserId();
        if (userId == null) { res.put("ok", false); res.put("error","로그인이 필요합니다."); return res; }

        int calcAge = LocalDate.now().getYear() - childBirth.getYear()
                - (LocalDate.now().getDayOfYear() < childBirth.withYear(LocalDate.now().getYear()).getDayOfYear() ? 1 : 0);

        StudentCertDTO dto = new StudentCertDTO();
        dto.setId(id);
        dto.setUserId(userId);
        dto.setChildName(childName);
        dto.setChildBirth(childBirth);
        dto.setChildAge(calcAge);
        dto.setChildSchool(childSchool);
        dto.setChildGrade(childGrade);

        try {
            service.resubmit(file, dto);
            StudentCertDTO updated = service.detail(id);
            res.put("ok", true);
            res.put("message", "재제출되었습니다. 승인 대기(PENDING)로 변경되었습니다.");
            res.put("item", updated);
        } catch (Exception e) {
            res.put("ok", false);
            res.put("error", e.getMessage());
        }
        return res;
    }



    @GetMapping("/preview/{id}")
    public void preview(@PathVariable long id, HttpServletResponse response) throws IOException {
        StudentCertDTO detail = service.detail(id);
        if (detail == null || detail.getFilePath() == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File file = new File(detail.getFilePath());
        if (!file.exists()) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = Files.probeContentType(file.toPath());
        response.setContentType(mime != null ? mime : "application/octet-stream");

        try (FileInputStream in = new FileInputStream(file)) {
            org.springframework.util.FileCopyUtils.copy(in, response.getOutputStream());
        }
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
