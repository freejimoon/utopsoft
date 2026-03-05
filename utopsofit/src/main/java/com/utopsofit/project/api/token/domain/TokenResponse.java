package com.utopsofit.project.api.token.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Getter;

/** 토큰 발급 응답 DTO */
@Getter
@AllArgsConstructor
@Schema(description = "토큰 발급 응답")
public class TokenResponse {

    @Schema(description = "Bearer 토큰 타입", example = "Bearer")
    private final String tokenType;

    @Schema(description = "JWT 액세스 토큰")
    private final String accessToken;

    @Schema(description = "만료 시간 (초)", example = "86400")
    private final long expiresIn;
}
