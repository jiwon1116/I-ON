package com.spring.ion.lcw.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.lcw.service.MemberService;
import com.spring.ion.lcw.service.NaverLoginService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RequiredArgsConstructor
@Controller
public class NaverLoginController {

    private final NaverLoginService naverLoginService;
    private final MemberService memberService;

    @GetMapping("/naverLogin")
    public void naverLogin(HttpServletResponse response, HttpSession session) throws IOException {
        String clientId = "tDu0Knn2MBz39f7vATkw";
        String redirectUri = "http://localhost:8080/auth/naver/callback";

        String state = new java.math.BigInteger(130, new java.security.SecureRandom()).toString(32);
        session.setAttribute("naverState", state);

        String naverAuthUrl = "https://nid.naver.com/oauth2.0/authorize?response_type=code" +
                "&client_id=" + clientId +
                "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8.name()) +
                "&state=" + state;

        response.sendRedirect(naverAuthUrl);
    }

    @GetMapping("/auth/naver/callback")
    public String naverCallback(@RequestParam String code, @RequestParam String state, HttpSession session) throws IOException {
        String sessionState = (String) session.getAttribute("naverState");

        if (!state.equals(sessionState)) {
            return "redirect:/login?error=state_mismatch";
        }

        String accessToken = naverLoginService.getAccessToken(code, state);

        if (accessToken == null) {
            return "redirect:/login?error=token_request_failed";
        }

        JsonNode userProfile = naverLoginService.getUserProfile(accessToken);

        if (userProfile == null) {
            return "redirect:/login?error=profile_request_failed";
        }

        JsonNode responseNode = userProfile.get("response");

        String naverId = null;
        if (responseNode.has("id")) {
            naverId = responseNode.get("id").asText();
        }


        MemberDTO memberDTO = memberService.findByUserId(naverId);

        if (memberDTO == null) {
            session.setAttribute("naverId", naverId);
            return "redirect:/naver-register";
        }

        CustomUserDetails customUserDetails = new CustomUserDetails(memberDTO);
        Authentication authentication = new UsernamePasswordAuthenticationToken(customUserDetails, null, customUserDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);

        return "redirect:/";

    }
}