package com.spring.ion.lcw.controller;

import com.spring.ion.lcw.dto.ChatRoomDTO;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.dto.MessageDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.service.ChatRoomService;
import com.spring.ion.lcw.service.MemberService;
import com.spring.ion.lcw.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class ChatRoomController {

    private final ChatRoomService chatRoomService;
    private final MemberService memberService;
    private final MessageService messageService;


    @GetMapping
    public String chatRoomsList(Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO currentMember = userDetails.getMemberDTO();
        Long id = currentMember.getId();

        List<ChatRoomDTO> chatRooms = chatRoomService.findChatRoomsById(id);

        model.addAttribute("chatRooms", chatRooms);

        return "chat";
    }
    @PostMapping("/create")
    public String createChatRoom(@RequestParam("nickname") String nickname, RedirectAttributes redirectAttributes) {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO currentMember = userDetails.getMemberDTO();
        Long user1Id = currentMember.getId();

        MemberDTO user2 = memberService.findByNickname(nickname);
        if(currentMember.getNickname().equals(nickname)){
            redirectAttributes.addFlashAttribute("findFail", "본인입니다.");
            return "redirect:/chat/";
        }
        else if (user2 == null) {
            redirectAttributes.addFlashAttribute("findFail", "존재하지 않는 사용자입니다.");
            return "redirect:/chat/";
        }
        Long user2Id = user2.getId();

        ChatRoomDTO existingChatRoom = chatRoomService.findChatRoomByIds(user1Id, user2Id);

        if (existingChatRoom != null) {
            return "redirect:/chat/room/" + existingChatRoom.getId();
        }

        ChatRoomDTO chatRoom = new ChatRoomDTO();
        chatRoom.setUser1Id(user1Id);
        chatRoom.setUser2Id(user2Id);
        chatRoomService.insertChatRoom(chatRoom);

        return "redirect:/chat";
    }

    @GetMapping("/room/{roomId}")
    public String chatRoomDetail(@PathVariable("roomId") Long roomId, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO currentMember = userDetails.getMemberDTO();
        Long currentUserId = currentMember.getId();

        ChatRoomDTO chatRoom = chatRoomService.findChatRoomById(roomId);
        if (chatRoom == null) {
            return "redirect:/chat";
        }

        Long partnerId = (chatRoom.getUser1Id().equals(currentUserId)) ? chatRoom.getUser2Id() : chatRoom.getUser1Id();
        MemberDTO partnerMember = memberService.findById(partnerId);

        chatRoomService.setZeroUnreadCount(roomId, currentUserId);
        List<MessageDTO> messages = messageService.findMessagesByRoomid(roomId);

        model.addAttribute("chatRoom", chatRoom);
        model.addAttribute("messages", messages);
        model.addAttribute("partnerNickname", partnerMember.getNickname());
        return "chatRoom";
    }

    @PostMapping("/room/{roomId}/read/{currentUserId}")
    public String setZeroUnreadCount(@PathVariable("roomId") Long roomId, @PathVariable("currentUserId") Long currentUserId) {
        try {
            chatRoomService.setZeroUnreadCount(roomId, currentUserId);
            return "Unread count updated successfully.";
        } catch (Exception e) {
            return "Failed to update unread count: " + e.getMessage();
        }
    }
}