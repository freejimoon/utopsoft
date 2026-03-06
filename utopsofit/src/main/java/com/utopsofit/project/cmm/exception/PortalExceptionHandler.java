package com.utopsofit.project.cmm.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

import jakarta.servlet.http.HttpServletRequest;

/**
 * 포털 (JSP) 전역 예외 처리
 * → 예외 유형에 따라 에러 JSP 페이지로 포워딩
 */
@Slf4j
@ControllerAdvice(basePackages = "com.utopsofit.project.portal")
public class PortalExceptionHandler {

    /** 404 — 페이지 없음 */
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ModelAndView handleNotFound(HttpServletRequest req, NoHandlerFoundException e) {
        log.warn("[Portal] 404 Not Found: {}", req.getRequestURI());
        return errorView("cmm/error/404", 404, "페이지를 찾을 수 없습니다.", req.getRequestURI());
    }

    /** 403 — 접근 거부 */
    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public ModelAndView handleAccessDenied(HttpServletRequest req, AccessDeniedException e) {
        log.warn("[Portal] 403 Forbidden: {} — {}", req.getRequestURI(), e.getMessage());
        return errorView("cmm/error/403", 403, "접근 권한이 없습니다.", req.getRequestURI());
    }

    /** 500 — 서버 오류 */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ModelAndView handleException(HttpServletRequest req, Exception e) {
        log.error("[Portal] 500 Internal Server Error: {}", req.getRequestURI(), e);
        return errorView("cmm/error/500", 500, "서버 오류가 발생했습니다.", req.getRequestURI());
    }

    private ModelAndView errorView(String viewName, int status, String message, String path) {
        ModelAndView mav = new ModelAndView(viewName);
        mav.addObject("status", status);
        mav.addObject("message", message);
        mav.addObject("path", path);
        return mav;
    }
}
