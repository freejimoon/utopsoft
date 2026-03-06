<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>탈퇴 회원</title>
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
      <h1>탈퇴 회원</h1>
      <p class="page-desc">탈퇴한 회원 목록을 조회합니다.</p>
    </div>
  </div>

  <div class="search-box">
    <div class="search-item">
      <span class="search-label">회원 유형</span>
      <select id="searchMembershipCd" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${membershipCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-item">
      <span class="search-label">소셜 계정</span>
      <select id="searchSocialCd" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${socialCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-item">
      <span class="search-label">가입 일시</span>
      <input type="date" id="searchJoinFrom" class="search-input" style="width:140px;">
      <span style="margin:0 4px;">~</span>
      <input type="date" id="searchJoinTo" class="search-input" style="width:140px;">
    </div>
    <div class="search-item">
      <span class="search-label">닉네임</span>
      <input type="text" id="searchMemberNm" class="search-input" placeholder="닉네임 입력">
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="withdrawTable">
    <thead>
      <tr>
        <th style="width:60px;">No</th>
        <th style="width:120px;">회원 ID</th>
        <th style="width:110px;">닉네임</th>
        <th>이메일</th>
        <th style="width:110px;">소셜 계정</th>
        <th style="width:90px;">회원 유형</th>
        <th style="width:110px;">소속 단체</th>
        <th style="width:110px;">가입일시</th>
        <th style="width:110px;">탈퇴일시</th>
      </tr>
    </thead>
  </table>

</div>
<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<script>
var ctx = '${ctx}';
var table;
var BADGE_CLS = {
  ACTIVE:'badge-success', PAID:'badge-success',
  GROUP:'badge-indigo',
  EXPIRED:'badge-danger', CANCELED:'badge-danger', WITHDRAWN:'badge-danger',
  PAUSED:'badge-warning',
  FREE:'badge-default', NONE:'badge-default'
};
function badgeHtml(code, nm) {
  var cls = BADGE_CLS[code] || 'badge-default';
  return nm ? '<span class="badge ' + cls + '">' + nm + '</span>' : (code || '-');
}
var rowNum = 0;

function loadTable() {
  if (table) { table.destroy(); $('#withdrawTable tbody').empty(); }
  rowNum = 0;
  $.get(ctx + '/member/withdraw/list/json', {
    searchMemberNm:     $('#searchMemberNm').val(),
    searchMembershipCd: $('#searchMembershipCd').val(),
    searchSocialCd:     $('#searchSocialCd').val(),
    searchJoinFrom:     $('#searchJoinFrom').val(),
    searchJoinTo:       $('#searchJoinTo').val()
  }).done(function(data) {
    table = $('#withdrawTable').DataTable({
      data: data,
      autoWidth: false,
      pageLength: 10,
      columns: [
        { data: null, className: 'dt-center', render: function() { return ++rowNum; } },
        { data: 'memberId',      className: 'dt-center', defaultContent: '-' },
        { data: 'memberNm',      className: 'dt-center', defaultContent: '-' },
        { data: 'email',         defaultContent: '-' },
        { data: 'socialCd',     className: 'dt-center', render: function(d, t, row) { return row.socialNm || d || '-'; } },
        { data: 'membershipCd', className: 'dt-center', render: function(d, t, row) { return badgeHtml(d, row.membershipNm); } },
        { data: 'groupNm',       className: 'dt-center', defaultContent: '-' },
        { data: 'joinDt',        className: 'dt-center', render: function(d) { return d ? d.replace('T',' ').substring(0,10) : '-'; } },
        { data: 'withdrawDt',    className: 'dt-center', render: function(d) { return d ? d.replace('T',' ').substring(0,10) : '-'; } }
      ],
      order: [[8, 'desc']],
      language: {
        emptyTable: '조회된 데이터가 없습니다.',
        info: '전체 _TOTAL_ 건 중 _START_ ~ _END_',
        infoEmpty: '데이터 없음',
        lengthMenu: '_MENU_ 건씩 보기',
        paginate: { first:'«', previous:'‹', next:'›', last:'»' }
      }
    });
  }).fail(function(xhr) { console.error('[탈퇴회원 오류]', xhr.status); });
}

$('#btnSearch').on('click', loadTable);
$('#searchMemberNm').on('keydown', function(e) { if (e.key === 'Enter') loadTable(); });
$('#btnReset').on('click', function() {
  $('#searchMemberNm, #searchJoinFrom, #searchJoinTo').val('');
  $('#searchMembershipCd, #searchSocialCd').val('');
  loadTable();
});
$(document).ready(loadTable);
</script>
</body>
</html>
