package com.spring.ion.psw.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.dto.NotifyDTO;
import com.spring.ion.psw.service.NotifyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

// NotifyController.java
@Controller
@RequestMapping("/notify")
@RequiredArgsConstructor
public class NotifyController {
    private final NotifyService notifyService;

    // 알림 팝오버에 데이터 뿌리기
    @ResponseBody
    @GetMapping("/list")
    public List<NotifyDTO> list() {
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();

        String memberNickname =  memberDTO.getNickname();
        if (memberNickname == null) return Collections.emptyList(); // 비로그인: 빈 배열
        return notifyService.findAllByNotify(memberNickname);
    }

    // 알림 삭제 - RESTful 원칙에 맞게 DELETE 메서드와 URL 경로 변수 사용
    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<String> deleteNotification(@PathVariable("id") Long id) {
        notifyService.deleteById(id);
        return ResponseEntity.ok().body("삭제 성공");
    }
}