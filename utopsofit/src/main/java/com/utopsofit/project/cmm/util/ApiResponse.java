package com.utopsofit.project.cmm.util;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;

/**
 * 앱 API 공통 응답 래퍼
 */
@Getter
@Schema(description = "API 공통 응답")
public class ApiResponse<T> {

    @Schema(description = "응답 코드 (200: 성공, 4xx/5xx: 오류)", example = "200")
    private final int code;

    @Schema(description = "응답 메시지", example = "success")
    private final String message;

    @Schema(description = "응답 데이터")
    private final T data;

    private ApiResponse(int code, String message, T data) {
        this.code    = code;
        this.message = message;
        this.data    = data;
    }

    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(200, "success", data);
    }

    public static <T> ApiResponse<T> ok() {
        return new ApiResponse<>(200, "success", null);
    }

    public static <T> ApiResponse<T> error(int code, String message) {
        return new ApiResponse<>(code, message, null);
    }
}
