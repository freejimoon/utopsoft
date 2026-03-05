<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title><c:choose><c:when test="${empty item.code}">코드 등록</c:when><c:otherwise>코드 수정</c:otherwise></c:choose> - ${grp.grpNm}</title>
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
<h1>공통코드 <c:choose><c:when test="${empty item.code}">등록</c:when><c:otherwise>수정</c:otherwise></c:choose> (${grp.grpNm})</h1>

<form id="saveForm" method="post" action="${ctx}/code/save" class="code-form">
  <input type="hidden" name="grpCd" value="${item.grpCd}" />
  <p><label>코드</label>
    <c:choose>
      <c:when test="${empty item.code}"><input type="text" name="code" required /></c:when>
      <c:otherwise><input type="text" name="code" value="${item.code}" readonly /></c:otherwise>
    </c:choose>
  </p>
  <p><label>코드명</label> <input type="text" name="codeNm" value="${item.codeNm}" required /></p>
  <p><label>설명</label> <textarea name="codeDesc" rows="2" cols="40">${item.codeDesc}</textarea></p>
  <p><label>사용여부</label>
    <select name="useYn">
      <option value="Y" <c:if test="${item.useYn != 'N'}">selected</c:if>>Y</option>
      <option value="N" <c:if test="${item.useYn == 'N'}">selected</c:if>>N</option>
    </select>
  </p>
  <p><label>정렬순서</label> <input type="number" name="sortOrd" value="${item.sortOrd}" /></p>
  <p><label>속성1</label> <input type="text" name="attr1" value="${item.attr1}" /></p>
  <p><label>속성2</label> <input type="text" name="attr2" value="${item.attr2}" /></p>
  <p><label>속성3</label> <input type="text" name="attr3" value="${item.attr3}" /></p>
  <p class="form-actions">
    <button type="submit">저장</button>
    <button type="button" onclick="document.getElementById('listForm').submit();">목록</button>
  </p>
</form>

<form id="listForm" method="post" action="${ctx}/code/list">
  <input type="hidden" name="grpCd" value="${item.grpCd}" />
  <input type="hidden" name="page" value="1" />
</form>
</div>
<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>
</body>
</html>
