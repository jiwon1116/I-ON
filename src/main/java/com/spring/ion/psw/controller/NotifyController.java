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
        // 1. Authentication 객체를 가져와서 null인지 확인하여 NullPointerException 방지
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getPrincipal().equals("anonymousUser")) {
            return Collections.emptyList(); // 비로그인 상태일 경우, 빈 리스트 반환
        }

        CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();
        System.out.println("알림컨트롤러로 넘어온 member" + memberDTO);

        // 2. DTO 객체나 닉네임이 null인 경우를 대비하여 방어 코드 추가
        if (memberDTO == null || memberDTO.getNickname() == null) {
            return Collections.emptyList();
        }

        // 3. MemberDTO의 getter 메서드 이름에 맞춰서 호출
        boolean isVerified = memberDTO.isEnrollment_verified();

        System.out.println("회원 인증 여부 isVerified:" + isVerified);

        return notifyService.findAllByNotify(memberDTO.getNickname(), isVerified);
    }

    // 알림 삭제 - RESTful 원칙에 맞게 DELETE 메서드와 URL 경로 변수 사용
    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<String> deleteNotification(@PathVariable("id") Long id) {
        notifyService.deleteById(id);
        return ResponseEntity.ok().body("삭제 성공");
    }
}