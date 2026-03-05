package com.utopsofit.project.cmm.filter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.utopsofit.project.cmm.util.JwtUtil;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * JWT 인증 필터
 * Authorization: Bearer {token} 헤더를 검증하여 SecurityContext 에 인증 정보를 설정한다.
 * /api/token 은 필터를 통과시키고, 그 외 /api/** 는 유효한 토큰이 없으면 401 반환.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        // 토큰 발급 엔드포인트는 필터 제외
        return path.startsWith("/api/token");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {

        String uri = request.getRequestURI();

        // /api/** 가 아닌 경로는 그냥 통과
        if (!uri.startsWith("/api/")) {
            chain.doFilter(request, response);
            return;
        }

        String header = request.getHeader("Authorization");
        log.debug("[JwtAuthFilter] URI={} | Authorization={}", uri,
                  header == null ? "없음" : header.substring(0, Math.min(header.length(), 30)) + "...");

        if (header == null || !header.startsWith("Bearer ")) {
            log.warn("[JwtAuthFilter] Authorization 헤더 누락 또는 형식 오류 — URI={}", uri);
            sendUnauthorized(response, "Authorization 헤더가 없거나 형식이 올바르지 않습니다. (Bearer {token})");
            return;
        }

        String token = header.substring(7);

        try {
            String appId = jwtUtil.getAppId(token);
            log.debug("[JwtAuthFilter] 인증 성공 — appId={}", appId);
            UsernamePasswordAuthenticationToken auth =
                    new UsernamePasswordAuthenticationToken(appId, null, Collections.emptyList());
            SecurityContextHolder.getContext().setAuthentication(auth);
            chain.doFilter(request, response);
        } catch (JwtException e) {
            log.warn("[JwtAuthFilter] 토큰 검증 실패 — {}", e.getMessage());
            sendUnauthorized(response, "토큰이 유효하지 않거나 만료되었습니다.");
        }
    }

    private void sendUnauthorized(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("code", 401);
        body.put("message", message);
        body.put("data", null);
        response.getWriter().write(objectMapper.writeValueAsString(body));
    }
}
