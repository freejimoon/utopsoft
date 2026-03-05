<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>공통코드 그룹 관리</title>
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
      <h1>공통코드 그룹 관리</h1>
      <p class="page-desc">코드 그룹을 등록하고 관리합니다.</p>
    </div>
    <div class="page-actions">
      <form method="post" action="${ctx}/code/grp/form">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-primary">+ 그룹 등록</button>
      </form>
    </div>
  </div>

  <c:if test="${not empty message}">
    <p class="alert-success">${message}</p>
  </c:if>

  <table class="code-table" id="grpTable">
    <thead>
      <tr>
        <th>그룹코드</th>
        <th>그룹명</th>
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
  var ctx       = '${ctx}';
  var csrfParam = $('meta[name="_csrf_param"]').attr('content');
  var csrfToken = $('meta[name="_csrf"]').attr('content');

  var DT_LANG = {
    processing:   '처리중...',
    search:       '검색:',
    lengthMenu:   '_MENU_ 건씩 보기',
    info:         '전체 _TOTAL_건 중 _START_ - _END_',
    infoEmpty:    '데이터 없음',
    infoFiltered: '(전체 _MAX_건 중 필터링)',
    zeroRecords:  '등록된 그룹이 없습니다.',
    paginate:     { first:'처음', previous:'이전', next:'다음', last:'마지막' }
  };

  function csrf() {
    return '<input type="hidden" name="' + csrfParam + '" value="' + csrfToken + '">';
  }

  $('#grpTable').DataTable({
    processing: true,
    ajax: { url: ctx + '/code/grp/list/json', dataSrc: '' },
    order: [[4, 'asc']],
    language: DT_LANG,
    columns: [
      { data: 'grpCd' },
      {
        data: 'grpNm',
        render: function (data, type, row) {
          if (type !== 'display') return data;
          return '<form method="post" action="' + ctx + '/code/list" style="display:inline;">' +
                   '<input type="hidden" name="grpCd" value="' + row.grpCd + '">' +
                   '<input type="hidden" name="page"  value="1">' +
                   csrf() +
                   '<button type="submit" class="link-btn">' + data + '</button>' +
                 '</form>';
        }
      },
      { data: 'grpDesc', defaultContent: '' },
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
            '<form method="post" action="' + ctx + '/code/grp/form" style="display:inline;">' +
            '<input type="hidden" name="grpCd" value="' + row.grpCd + '">' +
            csrf() +
            '<button type="submit" class="btn btn-sm btn-outline">수정</button></form>';

          var del =
            '<form method="post" action="' + ctx + '/code/grp/delete" style="display:inline;"' +
            ' onsubmit="return confirm(\'삭제하시겠습니까?\');">' +
            '<input type="hidden" name="grpCd" value="' + row.grpCd + '">' +
            csrf() +
            '<button type="submit" class="btn btn-sm btn-danger">삭제</button></form>';

          var codes =
            '<form method="post" action="' + ctx + '/code/list" style="display:inline;">' +
            '<input type="hidden" name="grpCd" value="' + row.grpCd + '">' +
            '<input type="hidden" name="page"  value="1">' +
            csrf() +
            '<button type="submit" class="btn btn-sm btn-primary">코드관리</button></form>';

          return edit + ' ' + del + ' ' + codes;
        }
      }
    ]
  });
})();
</script>
</body>
</html>
