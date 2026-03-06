<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>공통코드 관리 - ${grp.grpNm}</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf"        content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<meta name="_csrf_param"  content="${_csrf.parameterName}"/>
<link rel="stylesheet" href="${ctx}/css/style.css">
<link rel="stylesheet" href="${ctx}/js/jquery.dataTables.min.css">
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">

  <div class="page-header">
    <div>
      <h1>공통코드 관리</h1>
      <p class="page-desc">그룹: <strong>${grp.grpNm}</strong> (${grp.grpCd})</p>
    </div>
    <div class="page-header-actions">
      <form method="post" action="${ctx}/code/grp/list">
        <input type="hidden" name="page" value="1"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-outline">← 그룹 목록</button>
      </form>
      <form method="post" action="${ctx}/code/form">
        <input type="hidden" name="grpCd" value="${grp.grpCd}"/>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-primary">+ 코드 등록</button>
      </form>
    </div>
  </div>

  <c:if test="${not empty message}">
    <p class="alert-success">${message}</p>
  </c:if>

  <table class="code-table" id="codeTable">
    <thead>
      <tr>
        <th>코드</th>
        <th>코드명</th>
        <th>설명</th>
        <th>사용여부</th>
        <th>정렬</th>
        <th>관리</th>
      </tr>
    </thead>
  </table>

</div>
<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<script>
(function () {
  var grpCd     = '${grp.grpCd}';
  var ctx       = '${ctx}';
  var csrfParam = $('meta[name="_csrf_param"]').attr('content');
  var csrfToken = $('meta[name="_csrf"]').attr('content');

  var DT_LANG = {
    emptyTable: '조회된 데이터가 없습니다.',
    info:       '전체 _TOTAL_ 건 중 _START_ ~ _END_',
    infoEmpty:  '데이터 없음',
    lengthMenu: '_MENU_ 건씩 보기',
    paginate:   { first: '«', previous: '‹', next: '›', last: '»' }
  };

  function csrf() {
    return '<input type="hidden" name="' + csrfParam + '" value="' + csrfToken + '">';
  }

  $('#codeTable').DataTable({
    processing: true,
    autoWidth: false,
    pageLength: 10,
    ajax: { url: ctx + '/code/list/json', data: { grpCd: grpCd }, dataSrc: '' },
    language: DT_LANG,
    columns: [
      { data: 'code' },
      { data: 'codeNm' },
      { data: 'codeDesc', defaultContent: '' },
      {
        data: 'useYn',
        render: function (data) {
          return data === 'Y'
            ? '<span class="badge badge-active">사용</span>'
            : '<span class="badge badge-inactive">미사용</span>';
        }
      },
      { data: 'sortOrd' },
      {
        data: null, orderable: false, searchable: false,
        render: function (data, type, row) {
          var edit =
            '<form method="post" action="' + ctx + '/code/form" style="display:inline;">' +
            '<input type="hidden" name="grpCd" value="' + row.grpCd + '">' +
            '<input type="hidden" name="code"  value="' + row.code  + '">' +
            csrf() +
            '<button type="submit" class="btn btn-sm btn-outline">수정</button></form>';

          var del =
            '<form method="post" action="' + ctx + '/code/delete" style="display:inline;"' +
            ' onsubmit="return confirm(\'삭제하시겠습니까?\');">' +
            '<input type="hidden" name="grpCd" value="' + row.grpCd + '">' +
            '<input type="hidden" name="code"  value="' + row.code  + '">' +
            csrf() +
            '<button type="submit" class="btn btn-sm btn-danger">삭제</button></form>';

          return edit + ' ' + del;
        }
      }
    ]
  });
})();
</script>
</body>
</html>
