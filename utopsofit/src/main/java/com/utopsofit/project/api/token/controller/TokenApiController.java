package com.utopsofit.project.api.token.controller;

import com.utopsofit.project.api.token.domain.TokenResponse;
import com.utopsofit.project.cmm.util.ApiResponse;
import com.utopsofit.project.cmm.util.JwtUtil;
import com.utopsofit.project.portal.system.dao.AppClientMapper;
import com.utopsofit.project.portal.system.domain.AppClientVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 앱 API 토큰 발급
 * POST /api/token  — appId / appSecret 검증 후 JWT 반환
 *
 * 발급받은 토큰은 이후 API 요청 헤더에 포함
 * Authorization: Bearer {accessToken}
 */
@Tag(name = "Token API", description = "앱 클라이언트 JWT 토큰 발급")
@RestController
@RequestMapping("/api/token")
@RequiredArgsConstructor
public class TokenApiController {

    private final AppClientMapper appClientMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil         jwtUtil;

    @Operation(
        summary = "토큰 발급",
        description = "앱 클라이언트 관리에서 발급받은 **appId** / **appSecret(평문)** 으로 JWT 를 발급합니다.\n\n" +
                      "발급된 토큰은 이후 API 요청 헤더에 포함하세요.\n\n" +
                      "`Authorization: Bearer {accessToken}`"
    )
    @PostMapping(consumes = "application/x-www-form-urlencoded")
    public ResponseEntity<ApiResponse<TokenResponse>> issue(
            @Parameter(description = "앱 클라이언트 ID", required = true, example = "utopsoft-app")
            @RequestParam String appId,
            @Parameter(description = "앱 클라이언트 Secret (발급 시 표시된 평문)", required = true)
            @RequestParam String appSecret) {

        // appId 조회
        AppClientVO client = appClientMapper.selectByPk(appId);
        if (client == null || !"Y".equals(client.getUseYn())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error(401, "appId 또는 appSecret 이 올바르지 않습니다."));
        }

        // secret 검증 (BCrypt)
        if (!passwordEncoder.matches(appSecret, client.getAppSecret())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error(401, "appId 또는 appSecret 이 올바르지 않습니다."));
        }

        // JWT 생성
        String jwt = jwtUtil.generate(client.getAppId());
        TokenResponse token = new TokenResponse("Bearer", jwt, jwtUtil.getExpirationSec());
        return ResponseEntity.ok(ApiResponse.ok(token));
    }
}
