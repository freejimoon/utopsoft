package com.utopsofit.project.cmm.exception;

import com.utopsofit.project.cmm.util.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * REST API (/api/**) 전역 예외 처리
 * → 모든 예외를 ApiResponse JSON 포맷으로 반환
 */
@Slf4j
@RestControllerAdvice(basePackages = "com.utopsofit.project.api")
public class ApiExceptionHandler {

    /** 필수 파라미터 누락 (400) */
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ApiResponse<Void>> handleMissingParam(MissingServletRequestParameterException e) {
        log.warn("[API] 필수 파라미터 누락: {}", e.getParameterName());
        return ResponseEntity.badRequest()
                .body(ApiResponse.error(400, "필수 파라미터가 누락되었습니다: " + e.getParameterName()));
    }

    /** 허용되지 않는 HTTP 메서드 (405) */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<Void>> handleMethodNotSupported(HttpRequestMethodNotSupportedException e) {
        log.warn("[API] 허용되지 않는 메서드: {}", e.getMethod());
        return ResponseEntity.status(HttpStatus.METHOD_NOT_ALLOWED)
                .body(ApiResponse.error(405, "허용되지 않는 HTTP 메서드입니다: " + e.getMethod()));
    }

    /** 접근 거부 (403) */
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse<Void>> handleAccessDenied(AccessDeniedException e) {
        log.warn("[API] 접근 거부: {}", e.getMessage());
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(ApiResponse.error(403, "접근 권한이 없습니다."));
    }

    /** 그 외 모든 예외 (500) */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleException(Exception e) {
        log.error("[API] 처리되지 않은 예외 발생", e);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error(500, "서버 내부 오류가 발생했습니다."));
    }
}
