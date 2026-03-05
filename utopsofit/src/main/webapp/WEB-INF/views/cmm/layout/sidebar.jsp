<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx"    value="${pageContext.request.contextPath}" />
<c:set var="reqUri" value="${pageContext.request.requestURI}" />

<aside class="sidebar" id="sidebar">

  <!-- 브랜드 영역 -->
  <div class="sidebar-brand">
    <span class="brand-avatar">U</span>
    <span class="brand-name">UTOPSOFT</span>
  </div>

  <!-- 내비게이션 -->
  <nav class="sidebar-nav">
    <ul class="nav-list">

      <!-- 대시보드 -->
      <li class="nav-item">
        <a href="${ctx}/" class="nav-link">
          <svg class="nav-svg" viewBox="0 0 20 20" fill="currentColor">
            <path d="M3 4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V4zm0 9a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-3zm8-9a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-4a1 1 0 0 1-1-1V4zm0 7a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1h-4a1 1 0 0 1-1-1v-5z"/>
          </svg>
          <span>대시보드(홈)</span>
        </a>
      </li>

      <!-- 공통코드 관리 그룹 -->
      <li class="nav-group <c:if test="${fn:contains(reqUri, '/code')}">open</c:if>">
        <div class="nav-group-header">
          <svg class="nav-svg" viewBox="0 0 20 20" fill="currentColor">
            <path  d="M3 4a1 1 0 0 1 1-1h12a1 1 0 1 1 0 2H4a1 1 0 0 1-1-1zm0 4a1 1 0 0 1 1-1h12a1 1 0 1 1 0 2H4a1 1 0 0 1-1-1zm0 4a1 1 0 0 1 1-1h6a1 1 0 1 1 0 2H4a1 1 0 0 1-1-1z" />
          </svg>
          <span>공통코드 관리</span>
          <svg class="nav-arrow" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/>
          </svg>
        </div>
        <ul class="nav-sub">
          <li>
            <a href="${ctx}/code/grp/list"
               class="nav-sub-link" data-nav-key="code-grp-list">
              코드 그룹 관리
            </a>
          </li>
        </ul>
      </li>

      <!-- 사용자 관리 그룹 -->
      <li class="nav-group <c:if test="${fn:contains(reqUri, '/user')}">open</c:if>">
        <div class="nav-group-header">
          <svg class="nav-svg" viewBox="0 0 20 20" fill="currentColor">
            <path d="M9 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0zm8 0a3 3 0 1 1-6 0 3 3 0 0 1 6 0zM9.415 13.012C8.83 12.395 8 11.61 8 11a4 4 0 0 0-8 0v1a2 2 0 0 0 2 2h5.086a5.476 5.476 0 0 1 2.329-1v-.988zM18 12a4 4 0 0 0-8 0v1a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2v-1z"/>
          </svg>
          <span>회원 관리</span>
          <svg class="nav-arrow" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/>
          </svg>
        </div>
        <ul class="nav-sub">
          <li>
            <a href="${ctx}/user/list"
               class="nav-sub-link" data-nav-key="user-list">
              사용자 목록
            </a>
          </li>
          <li>
            <a href="${ctx}/user/form"
               class="nav-sub-link" data-nav-key="user-form">
              사용자 등록
            </a>
          </li>
        </ul>
      </li>

      <!-- 게시판 관리 그룹 -->
      <li class="nav-group <c:if test="${fn:contains(reqUri, '/board')}">open</c:if>">
        <div class="nav-group-header">
          <svg class="nav-svg" viewBox="0 0 20 20" fill="currentColor">
            <path d="M2 5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5zm3 1h10v1H5V6zm0 3h10v1H5V9zm0 3h6v1H5v-1z"/>
          </svg>
          <span>게시판 관리</span>
          <svg class="nav-arrow" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/>
          </svg>
        </div>
        <ul class="nav-sub">
          <li>
            <a href="${ctx}/board/inquiry/list"
               class="nav-sub-link" data-nav-key="board-inquiry-list">
              문의 관리
            </a>
          </li>
          <li>
            <a href="${ctx}/board/faq/list"
               class="nav-sub-link" data-nav-key="board-faq-list">
              FAQ 관리
            </a>
          </li>
          <li>
            <a href="${ctx}/board/terms/list"
               class="nav-sub-link" data-nav-key="board-terms-list">
              약관 관리
            </a>
          </li>
        </ul>
      </li>

      <!-- 시스템 설정 그룹 -->
      <li class="nav-group <c:if test="${fn:contains(reqUri, '/system')}">open</c:if>">
        <div class="nav-group-header">
          <svg class="nav-svg" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 0 1-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 0 1 .947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 0 1 2.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 0 1 2.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 0 1 .947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 0 1-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 0 1-2.287-.947zM10 13a3 3 0 1 0 0-6 3 3 0 0 0 0 6z" clip-rule="evenodd"/>
          </svg>
          <span>시스템 설정</span>
          <svg class="nav-arrow" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 0 1 0-1.414L10.586 10 7.293 6.707a1 1 0 0 1 1.414-1.414l4 4a1 1 0 0 1 0 1.414l-4 4a1 1 0 0 1-1.414 0z" clip-rule="evenodd"/>
          </svg>
        </div>
        <ul class="nav-sub">
          <li>
            <a href="${ctx}/system/auth/list"
               class="nav-sub-link" data-nav-key="system-auth-list">
              관리자 권한 관리
            </a>
          </li>
          <li>
            <a href="${ctx}/system/version/list"
               class="nav-sub-link" data-nav-key="system-version-list">
              앱 버전 관리
            </a>
          </li>
        </ul>
      </li>

    </ul>
  </nav>

</aside>
