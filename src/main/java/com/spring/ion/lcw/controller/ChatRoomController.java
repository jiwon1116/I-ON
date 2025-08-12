package com.spring.ion.lcw.controller;
import com.spring.ion.lcw.controller.MessageController;
import com.spring.ion.lcw.dto.ChatRoomDTO;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.dto.MessageDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.service.ChatRoomService;
import com.spring.ion.lcw.service.MemberService;
import com.spring.ion.lcw.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class ChatRoomController {

    private final ChatRoomService chatRoomService;
    private final MemberService memberService;
    private final MessageService messageService;
    private final SimpMessagingTemplate messagingTemplate;

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

        MessageController.activeUsers.put(currentUserId, roomId);

        Long partnerId = (chatRoom.getUser1Id().equals(currentUserId)) ? chatRoom.getUser2Id() : chatRoom.getUser1Id();
        MemberDTO partnerMember = memberService.findById(partnerId);

        chatRoomService.setZeroUnreadCount(roomId, currentUserId);

        Map<String, Object> readUpdateMessage = new HashMap<>();
        readUpdateMessage.put("type", "READ_UPDATE");
        readUpdateMessage.put("roomId", roomId);

        messagingTemplate.convertAndSend("/sub/chat/user/" + partnerId, readUpdateMessage);

        String partnerPrincipalName = memberService.findById(partnerId).getNickname();
        messagingTemplate.convertAndSendToUser(partnerPrincipalName, "/sub/chat/user/" + partnerId, readUpdateMessage);

        String currentPrincipalName = currentMember.getNickname();
        messagingTemplate.convertAndSendToUser(currentPrincipalName, "/sub/chat/user/" + currentUserId, readUpdateMessage);

        List<MessageDTO> messages = messageService.findMessagesByRoomid(roomId);

        List<Map<String, Object>> convertedMessages = messages.stream()
                .map(msg -> {
                    Map<String, Object> msgMap = new HashMap<>();
                    msgMap.put("content", msg.getContent());
                    msgMap.put("senderId", msg.getSenderId());
                    msgMap.put("createdAt", Date.from(msg.getCreatedAt().atZone(ZoneId.systemDefault()).toInstant()));
                    return msgMap;
                })
                .collect(Collectors.toList());

        model.addAttribute("chatRoom", chatRoom);
        model.addAttribute("messages", convertedMessages); // 변환된 리스트를 Model에 담아줍니다.
        model.addAttribute("partnerNickname", partnerMember.getNickname());
        return "chatRoom";
    }

    @PostMapping("/exitRoom/{roomId}/{currentUserId}")
    @ResponseBody
    public String exitRoom(@PathVariable("roomId") Long roomId, @PathVariable("currentUserId") Long currentUserId) {
        MessageController.activeUsers.remove(currentUserId);
        return "User left room.";
    }

    @GetMapping("/roomInfo/{roomId}")
    @ResponseBody
    public ChatRoomDTO getChatRoomInfo(@PathVariable("roomId") Long roomId) {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long currentUserId = userDetails.getMemberDTO().getId();

        ChatRoomDTO chatRoom = chatRoomService.findChatRoomById(roomId);
        if (chatRoom == null) {
            return null;
        }

        Long partnerId = chatRoom.getUser1Id().equals(currentUserId) ? chatRoom.getUser2Id() : chatRoom.getUser1Id();
        MemberDTO partnerMember = memberService.findById(partnerId);
        if(partnerMember != null) {
            chatRoom.setPartnerNickname(partnerMember.getNickname());
        } else {
            chatRoom.setPartnerNickname("알 수 없는 사용자");
        }

        return chatRoom;
    }

    @ResponseBody
    @GetMapping("/totalUnreadCount")
    public int getTotalUnreadCount() {
        CustomUserDetails userDetails = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long currentUserId = userDetails.getMemberDTO().getId();
        return chatRoomService.calculateTotalUnreadCount(currentUserId);
    }
}