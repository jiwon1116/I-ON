package com.spring.ion.lcw.controller;

import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@ControllerAdvice
public class TotalUnreadCountAdvice {

    private final ChatRoomService chatRoomService;

    @ModelAttribute
    public void addTotalUnreadCount(HttpServletRequest request) {
        int count = 0;
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            Long currentUserId = userDetails.getMemberDTO().getId();
            count = chatRoomService.calculateTotalUnreadCount(currentUserId);
        }
        request.setAttribute("totalUnreadCount", count);
    }
}
