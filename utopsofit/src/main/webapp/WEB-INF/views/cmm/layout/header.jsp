<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- ===== 레이아웃 래퍼 시작 (footer.jsp에서 닫힘) ===== -->
<div class="layout-wrapper">

  <!-- 사이드바 -->
  <%@ include file="sidebar.jsp" %>

  <!-- 메인 영역 (헤더 + 콘텐츠 + 푸터 포함) -->
  <div class="layout-main" id="layoutMain">

    <!-- 상단 헤더 -->
    <header class="site-header">
      <div class="header-inner">
        <button class="btn-sidebar-toggle" id="sidebarToggle" aria-label="메뉴 토글">&#9776;</button>
        <div class="header-actions">
          <span class="header-user">
            <c:if test="${not empty pageContext.request.userPrincipal}">
              ${pageContext.request.userPrincipal.name} 님
            </c:if>
          </span>
          <form method="post" action="${ctx}/logout" id="logoutForm" class="logout-form">
            <button type="submit" class="btn-logout">로그아웃</button>
          </form>
        </div>
      </div>
    </header>
