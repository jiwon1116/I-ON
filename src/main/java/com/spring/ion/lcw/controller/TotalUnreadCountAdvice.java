package com.spring.ion.lcw.controller;

import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@RequiredArgsConstructor
@ControllerAdvice
public class TotalUnreadCountAdvice {

    private final ChatRoomService chatRoomService;

    @ModelAttribute("totalUnreadCount")
    public int totalUnreadCount() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            Long currentUserId = userDetails.getMemberDTO().getId();
            return chatRoomService.calculateTotalUnreadCount(currentUserId);
        }
        return 0;
    }
}