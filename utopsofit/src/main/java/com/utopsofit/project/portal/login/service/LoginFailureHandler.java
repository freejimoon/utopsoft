package com.utopsofit.project.portal.login.service;

import java.io.IOException;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import com.utopsofit.project.portal.login.dao.UsrMapper;
import com.utopsofit.project.portal.login.domain.Usr;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

/**
 * 로그인 실패 핸들러 - 실패 횟수 증가 및 5회 초과 시 계정 잠금
 */
@Component
@RequiredArgsConstructor
public class LoginFailureHandler implements AuthenticationFailureHandler {

    private static final int MAX_FAIL_COUNT = 5;

    private final UsrMapper usrMapper;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                        AuthenticationException exception) throws IOException, ServletException {
        String usrId = request.getParameter("username");

        if (usrId != null && !usrId.trim().isEmpty()) {
            Usr usr = usrMapper.selectUsrById(usrId);
            if (usr != null) {
                int failCnt = usr.getLoginFailCnt() + 1;
                usrMapper.updateLoginFailCnt(usrId, failCnt);
                if (failCnt >= MAX_FAIL_COUNT) {
                    usrMapper.updateLockYn(usrId, "Y");
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/login?error=true");
    }
}
