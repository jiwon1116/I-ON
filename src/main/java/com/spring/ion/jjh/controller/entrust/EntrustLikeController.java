package com.spring.ion.jjh.controller.entrust;

import com.spring.ion.jjh.service.entrust.EntrustLikeService;
import com.spring.ion.lcw.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/entrustLike")
public class EntrustLikeController {
    private final EntrustLikeService entrustLikeService;

    @PostMapping("/like/{postId}")
    @ResponseBody
    public Map<String, Object> likeAjax(@PathVariable("postId") Long postId) {
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
        boolean liked = entrustLikeService.toggleLike(postId, memberId);
        int likeCount = entrustLikeService.getLikeCount(postId);

        result.put("likeCount", likeCount);
        result.put("liked", liked);
        return result;
    }


}
