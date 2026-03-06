<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>단체 회원</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${ctx}/css/style.css">
<link rel="stylesheet" href="${ctx}/js/jquery.dataTables.min.css">
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">

  <div class="page-header">
    <div>
      <h1>단체 회원</h1>
      <p class="page-desc">단체(학교/기업/학원 등) 회원 목록을 조회합니다.</p>
    </div>
  </div>

  <div class="search-box">
    <div class="search-item">
      <span class="search-label">단체 유형</span>
      <select id="searchGroupCd" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${groupTypeCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-item">
      <span class="search-label">검색</span>
      <input type="text" id="searchKeyword" class="search-input search-input-wide" placeholder="단체명, 대표자, 담당자 검색">
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="groupMemberTable">
    <thead>
      <tr>
        <th style="width:60px;">No</th>
        <th>단체명</th>
        <th style="width:90px;">유형</th>
        <th style="width:110px;">대표자</th>
        <th style="width:180px;">담당자 이메일</th>
        <th style="width:100px;">회원 현황</th>
        <th style="width:190px;">계약 기간</th>
        <th style="width:80px;">계약 상태</th>
      </tr>
    </thead>
  </table>

</div>
<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<script>
var ctx = '${ctx}';
var table;
var BADGE_CLS = {
  ACTIVE:'badge-success', PAID:'badge-success', GROUP:'badge-indigo',
  EXPIRED:'badge-danger', CANCELED:'badge-danger', WITHDRAWN:'badge-danger',
  PAUSED:'badge-warning', FREE:'badge-default', NONE:'badge-default'
};
function badgeHtml(code, nm) {
  var cls = BADGE_CLS[code] || 'badge-default';
  return nm ? '<span class="badge ' + cls + '">' + nm + '</span>' : (code || '-');
}
var rowNum = 0;

function loadTable() {
  if (table) { table.destroy(); $('#groupMemberTable tbody').empty(); }
  rowNum = 0;
  $.get(ctx + '/member/group/list/json', {
    searchGroupCd: $('#searchGroupCd').val(),
    searchKeyword: $('#searchKeyword').val()
  }).done(function(data) {
    table = $('#groupMemberTable').DataTable({
      data: data,
      autoWidth: false,
      pageLength: 10,
      columns: [
        { data: null, className: 'dt-center', render: function() { return ++rowNum; } },
        { data: 'groupNm',          defaultContent: '-' },
        { data: 'groupCdNm',        className: 'dt-center', defaultContent: '-' },
        { data: 'representNm',      className: 'dt-center', defaultContent: '-' },
        { data: 'managerEmail',     defaultContent: '-' },
        { data: 'currentMemberCnt', className: 'dt-center',
          render: function(d, t, row) {
            var used  = row.currentMemberCnt != null ? row.currentMemberCnt : 0;
            var total = row.maxMemberCnt     != null ? row.maxMemberCnt     : 0;
            return used + ' / ' + total;
          }
        },
        { data: 'contractStartDt', className: 'dt-center',
          render: function(d, t, row) {
            return (row.contractStartDt || '-') + ' ~ ' + (row.contractEndDt || '-');
          }
        },
        { data: 'contractStatusCd', className: 'dt-center',
          render: function(d, t, row) { return badgeHtml(d, row.contractStatusNm); }
        }
      ],
      order: [[0, 'asc']],
      language: {
        emptyTable: '조회된 데이터가 없습니다.',
        info: '전체 _TOTAL_ 건 중 _START_ ~ _END_',
        infoEmpty: '데이터 없음',
        lengthMenu: '_MENU_ 건씩 보기',
        paginate: { first:'«', previous:'‹', next:'›', last:'»' }
      }
    });
  }).fail(function(xhr) { console.error('[단체회원 오류]', xhr.status); });
}

$('#btnSearch').on('click', loadTable);
$('#searchKeyword').on('keydown', function(e) { if (e.key === 'Enter') loadTable(); });
$('#btnReset').on('click', function() {
  $('#searchGroupCd').val('');
  $('#searchKeyword').val('');
  loadTable();
});
$(document).ready(loadTable);
</script>
</body>
</html>
