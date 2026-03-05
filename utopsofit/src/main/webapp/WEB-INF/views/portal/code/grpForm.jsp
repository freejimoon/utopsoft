<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title><c:choose><c:when test="${empty grp.grpCd}">그룹 등록</c:when><c:otherwise>그룹 수정</c:otherwise></c:choose></title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<meta name="_csrf_param" content="${_csrf.parameterName}"/>
<link rel="stylesheet" href="${ctx}/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">
<h1><c:choose><c:when test="${empty grp.grpCd}">공통코드 그룹 등록</c:when><c:otherwise>공통코드 그룹 수정</c:otherwise></c:choose></h1>

<form id="saveForm" method="post" action="${ctx}/code/grp/save" class="code-form">
  <p><label>그룹코드</label>
    <c:choose>
      <c:when test="${empty grp.grpCd}"><input type="text" name="grpCd" required /></c:when>
      <c:otherwise><input type="text" name="grpCd" value="${grp.grpCd}" readonly /></c:otherwise>
    </c:choose>
  </p>
  <p><label>그룹명</label> <input type="text" name="grpNm" value="${grp.grpNm}" required /></p>
  <p><label>설명</label> <textarea name="grpDesc" rows="2" cols="40">${grp.grpDesc}</textarea></p>
  <p><label>사용여부</label>
    <select name="useYn">
      <option value="Y" <c:if test="${grp.useYn != 'N'}">selected</c:if>>Y</option>
      <option value="N" <c:if test="${grp.useYn == 'N'}">selected</c:if>>N</option>
    </select>
  </p>
  <p><label>정렬순서</label> <input type="number" name="sortOrd" value="${grp.sortOrd}" /></p>
  <p class="form-actions">
    <button type="submit">저장</button>
    <button type="button" onclick="document.getElementById('listForm').submit();">목록</button>
  </p>
</form>

<form id="listForm" method="post" action="${ctx}/code/grp/list">
  <input type="hidden" name="page" value="1" />
</form>
</div>
<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>
</body>
</html>
