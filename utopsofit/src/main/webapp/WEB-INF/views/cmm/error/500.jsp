<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - 서버 오류</title>
    <link rel="stylesheet" href="${ctx}/css/style.css">
    <style>
        body { display:flex; align-items:center; justify-content:center; min-height:100vh; background:#f8fafc; margin:0; }
        .error-box { text-align:center; padding:60px 40px; background:#fff; border-radius:12px; box-shadow:0 2px 16px rgba(0,0,0,.08); max-width:480px; width:100%; }
        .error-code { font-size:72px; font-weight:800; color:#ef4444; line-height:1; margin-bottom:12px; }
        .error-title { font-size:20px; font-weight:600; color:#1e293b; margin-bottom:8px; }
        .error-msg { color:#64748b; font-size:14px; margin-bottom:32px; line-height:1.6; }
        .error-path { font-size:12px; color:#94a3b8; margin-bottom:28px; word-break:break-all; }
        .btn-home { display:inline-block; padding:10px 28px; background:#3b82f6; color:#fff; border-radius:8px; text-decoration:none; font-size:14px; font-weight:500; }
        .btn-home:hover { background:#2563eb; }
    </style>
</head>
<body>
    <div class="error-box">
        <div class="error-code">500</div>
        <div class="error-title">서버 내부 오류</div>
        <div class="error-msg">요청을 처리하는 중 서버 오류가 발생했습니다.<br>잠시 후 다시 시도해 주세요.</div>
        <c:if test="${not empty path}">
            <div class="error-path">요청 경로: ${path}</div>
        </c:if>
        <a href="${ctx}/" class="btn-home">홈으로 돌아가기</a>
    </div>
</body>
</html>
