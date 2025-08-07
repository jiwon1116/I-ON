package com.spring.ion.lcw.security;

import org.springframework.security.authentication.*;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CustomLoginFailHandler extends SimpleUrlAuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
        String loginError;

        if (exception instanceof LockedException || (exception.getCause() != null && exception.getCause() instanceof LockedException)) {
            loginError = "잠긴 계정입니다.";
        } else if (exception instanceof DisabledException || (exception.getCause() != null && exception.getCause() instanceof DisabledException)) {
            loginError = exception.getMessage();
        } else if (exception instanceof AccountExpiredException || (exception.getCause() != null && exception.getCause() instanceof AccountExpiredException)) {
            loginError = "만료된 계정입니다.";
        } else if (exception instanceof CredentialsExpiredException || (exception.getCause() != null && exception.getCause() instanceof CredentialsExpiredException)) {
            loginError = "비밀번호가 만료되었습니다.";
        } else if (exception instanceof BadCredentialsException || (exception.getCause() != null && exception.getCause() instanceof BadCredentialsException)) {
            loginError = "아이디 또는 비밀번호가 틀립니다.";
        } else if (exception instanceof UsernameNotFoundException || (exception.getCause() != null && exception.getCause() instanceof UsernameNotFoundException)) {
            loginError = "존재하지 않는 사용자입니다.";
        } else {
            loginError = "알 수 없는 이유로 로그인에 실패했습니다.";
        }

        request.getSession().setAttribute("loginError", loginError);
        setDefaultFailureUrl("/login");
        super.onAuthenticationFailure(request, response, exception);
    }
}