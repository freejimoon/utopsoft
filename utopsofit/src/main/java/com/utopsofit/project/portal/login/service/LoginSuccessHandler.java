package com.utopsofit.project.portal.login.service;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.utopsofit.project.portal.login.dao.UsrMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

/**
 * 로그인 성공 핸들러 - 최종 로그인 일시 갱신
 */
@Component
@RequiredArgsConstructor
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final UsrMapper usrMapper;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        String usrId = authentication.getName();
        usrMapper.updateLastLogin(usrId);
        usrMapper.updateLoginFailCnt(usrId, 0);
        response.sendRedirect(request.getContextPath() + "/");
    }
}
