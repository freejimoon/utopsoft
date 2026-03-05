<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인 - UTOPSOFT</title>
<link rel="stylesheet" href="${ctx}/css/style.css">
</head>
<body class="login-body">
<div class="login-wrap">
  <h1>UTOPSOFT</h1>
  <p class="subtitle">시스템에 로그인하세요</p>

  <c:if test="${not empty errorMsg}">
    <div class="msg-error">${errorMsg}</div>
  </c:if>
  <c:if test="${not empty logoutMsg}">
    <div class="msg-success">${logoutMsg}</div>
  </c:if>

  <form method="post" action="${ctx}/login/process">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <div class="form-group">
      <label for="username">아이디</label>
      <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" autofocus />
    </div>
    <div class="form-group">
      <label for="password">비밀번호</label>
      <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" />
    </div>
    <button type="submit" class="btn-login">로그인</button>
  </form>
</div>
</body>
</html>
