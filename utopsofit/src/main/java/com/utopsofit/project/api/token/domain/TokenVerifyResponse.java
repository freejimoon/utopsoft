package com.utopsofit.project.api.token.domain;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;

/** 토큰 검증 응답 DTO */
@Getter
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
@Schema(description = "토큰 검증 응답")
public class TokenVerifyResponse {

    @Schema(description = "토큰 유효 여부", example = "true")
    private final boolean valid;

    @Schema(description = "토큰 만료 여부", example = "false")
    private final boolean expired;

    @Schema(description = "토큰 주체 (appId)", example = "utopsoft-app")
    private final String appId;

    @Schema(description = "토큰 발급 일시 (ISO-8601)", example = "2025-01-01T00:00:00")
    private final String issuedAt;

    @Schema(description = "토큰 만료 일시 (ISO-8601)", example = "2025-01-02T00:00:00")
    private final String expiresAt;

    @Schema(description = "남은 유효 시간 (초) — 만료 시 0 또는 음수", example = "3600")
    private final Long remainingSec;

    @Schema(description = "오류 사유 (valid=true 시 null)", example = "EXPIRED")
    private final String reason;
}
