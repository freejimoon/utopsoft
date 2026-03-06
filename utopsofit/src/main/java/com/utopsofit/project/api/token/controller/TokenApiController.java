package com.utopsofit.project.api.token.controller;

import com.utopsofit.project.api.token.domain.TokenResponse;
import com.utopsofit.project.api.token.domain.TokenVerifyResponse;
import com.utopsofit.project.cmm.util.ApiResponse;
import com.utopsofit.project.cmm.util.JwtUtil;
import com.utopsofit.project.portal.system.dao.AppClientMapper;
import com.utopsofit.project.portal.system.domain.AppClientVO;
import io.jsonwebtoken.Claims;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/**
 * 앱 API 토큰 발급 / 검증
 * POST /api/token        — appId / appSecret 검증 후 JWT 반환
 * GET  /api/token/verify — JWT 만료 여부 및 상세 정보 조회
 *
 * 발급받은 토큰은 이후 API 요청 헤더에 포함
 * Authorization: Bearer {accessToken}
 */
@Tag(name = "Token API", description = "앱 클라이언트 JWT 토큰 발급 / 검증")
@RestController
@RequestMapping("/api/token")
@RequiredArgsConstructor
public class TokenApiController {

    private static final DateTimeFormatter DT_FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss").withZone(ZoneId.of("Asia/Seoul"));

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

    @Operation(
        summary = "토큰 만료 확인",
        description = "발급된 JWT 의 유효 여부와 만료 정보를 조회합니다.\n\n" +
                      "- **valid=true** : 정상 토큰\n" +
                      "- **valid=false, reason=EXPIRED** : 만료된 토큰 (발급/만료 시각은 그대로 반환)\n" +
                      "- **valid=false, reason=INVALID** : 위변조 또는 형식 오류\n\n" +
                      "토큰은 `Bearer ` 접두사 없이 순수 JWT 문자열만 입력하세요."
    )
    @GetMapping("/verify")
    public ResponseEntity<ApiResponse<TokenVerifyResponse>> verify(
            @Parameter(description = "검증할 JWT (Bearer 접두사 제외)", required = true)
            @RequestParam String token) {

        String status = jwtUtil.verify(token);

        if ("INVALID".equals(status)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error(401, "유효하지 않은 토큰입니다."));
        }

        // 만료 여부와 관계없이 Claims 추출 (만료 토큰도 정보 반환)
        Claims claims  = jwtUtil.parseIgnoreExpiry(token);
        boolean expired = "EXPIRED".equals(status);

        Instant issuedAt  = claims.getIssuedAt().toInstant();
        Instant expiresAt = claims.getExpiration().toInstant();
        long remaining    = expiresAt.getEpochSecond() - Instant.now().getEpochSecond();

        TokenVerifyResponse body = TokenVerifyResponse.builder()
                .valid(!expired)
                .expired(expired)
                .appId(claims.getSubject())
                .issuedAt(DT_FMT.format(issuedAt))
                .expiresAt(DT_FMT.format(expiresAt))
                .remainingSec(remaining)
                .reason(expired ? "EXPIRED" : null)
                .build();

        return ResponseEntity.ok(ApiResponse.ok(body));
    }
}
