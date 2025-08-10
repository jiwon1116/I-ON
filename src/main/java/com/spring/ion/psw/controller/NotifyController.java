package com.spring.ion.psw.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.dto.NotifyDTO;
import com.spring.ion.psw.service.NotifyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/notify")
@RequiredArgsConstructor
public class NotifyController {
    private final NotifyService notifyService;

    // 알림 팝오버에 데이터 뿌리기
    @ResponseBody  //JSP 뷰를 렌더링이 아니라 JSON을 보내도록 설정
    @GetMapping("/list")
    public List<NotifyDTO> list() {
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();

        String memberNickname =  memberDTO.getNickname();
        System.out.println("알림 컨드롤러 로그인 이름 반환:"+ memberNickname);
        if (memberNickname == null) return Collections.emptyList(); // 비로그인: 빈 배열
        List<NotifyDTO> notifyDTO = notifyService.findAllByNotify(memberNickname);
        System.out.println("반환된 알림 리스트:"+notifyDTO);
        return notifyService.findAllByNotify(memberNickname);
    }

    // 알림 삭제
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> deleteNotification(@RequestParam("id") Long id) {
        notifyService.deleteById(id);
        return ResponseEntity.ok().body("삭제 성공");
    }


}

