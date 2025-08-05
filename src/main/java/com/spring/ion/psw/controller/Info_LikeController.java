package com.spring.ion.psw.controller;

import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.service.Info_LikeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController // @Controller + @ResponseBody
@RequiredArgsConstructor
@RequestMapping("/infoLike")
public class Info_LikeController {
    private final Info_LikeService infoLikeService;

    // 좋아요 토글
    @PostMapping("/like/{findId}")
    @ResponseBody
    public Map<String, Object> likeAjax(@PathVariable("findId") Long findId) {
        Map<String, Object> result = new HashMap<>();
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Object principal = authentication.getPrincipal();

        System.out.println("principal 클래스: " + principal.getClass());
        System.out.println("principal 값: " + principal);

        String memberId = null;
        if (principal instanceof CustomUserDetails) {
            memberId = ((CustomUserDetails) principal).getUsername();
        } else if (principal instanceof org.springframework.security.core.userdetails.User) {
            memberId = ((org.springframework.security.core.userdetails.User) principal).getUsername();
        } else if (principal instanceof String) {
            // 로그인 안 한 상태는 대부분 "anonymousUser" 문자열임
            if ("anonymousUser".equals(principal)) {
                memberId = null;
            } else {
                memberId = (String) principal;
            }
        }

        System.out.println("로그인 유저 userId: " + memberId);

        if (memberId == null) {
            result.put("error", "로그인 필요");
            return result;
        }
        boolean liked = infoLikeService.toggleLike(findId, memberId);
        int likeCount = infoLikeService.getLikeCount(findId);
        System.out.println("boolean liked:"+liked);

        result.put("likeCount", likeCount);
        result.put("liked", liked);
        return result;
    }




}
