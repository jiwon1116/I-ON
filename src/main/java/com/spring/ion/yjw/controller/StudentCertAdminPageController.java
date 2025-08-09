// src/main/java/com/spring/ion/yjw/controller/StudentCertAdminPageController.java
package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.service.StudentCertService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/certs")
public class StudentCertAdminPageController {

    private final StudentCertService service;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("items", service.pending());
        return "yjw/certList";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model) {
        model.addAttribute("detail", service.detail(id));
        return "yjw/certDetail";
    }

}
