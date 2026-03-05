<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>홈 - UTOPSOFT</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf"        content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<meta name="_csrf_param"  content="${_csrf.parameterName}"/>
<link rel="stylesheet" href="${ctx}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">
  <h1>대시보드</h1>
  <div class="dashboard-welcome">
    <p>안녕하세요<c:if test="${not empty username}">, <strong>${username}</strong></c:if> 님. UTOPSOFT 관리 시스템에 오신 것을 환영합니다.</p>
  </div>
  <div class="dashboard-cards">
    <a href="${ctx}/code/grp/list" class="dash-card">
      <div class="dash-card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/>
          <line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/>
          <line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/>
        </svg>
      </div>
      <div class="dash-card-body">
        <p class="dash-card-title">공통코드 그룹 관리</p>
        <p class="dash-card-desc">코드 그룹을 조회하고 관리합니다.</p>
      </div>
    </a>
    <a href="${ctx}/user/list" class="dash-card">
      <div class="dash-card-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
        </svg>
      </div>
      <div class="dash-card-body">
        <p class="dash-card-title">사용자 관리</p>
        <p class="dash-card-desc">사용자 목록을 조회하고 관리합니다.</p>
      </div>
    </a>
  </div>
</div>
<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>
</body>
</html>
