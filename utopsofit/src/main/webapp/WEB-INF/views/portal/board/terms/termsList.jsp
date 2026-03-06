<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>약관 관리</title>
<%@ include file="/WEB-INF/views/cmm/layout/head.jsp" %>
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">

  <div class="page-header">
    <div>
      <h1>약관 관리</h1>
      <p class="page-desc">서비스 약관을 등록하고 버전별로 관리합니다.</p>
    </div>
    <div class="page-header-actions">
      <button type="button" class="btn btn-indigo" id="btnAdd">+ 추가</button>
    </div>
  </div>

  <div class="search-box">
    <div class="search-item">
      <span class="search-label">구분</span>
      <select id="filterAppType" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${appTypeCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-divider"></div>
    <div class="search-item">
      <span class="search-label">형태</span>
      <select id="filterTermsType" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${termsTypeCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="termsTable">
    <thead>
      <tr>
        <th style="width:120px;">구분</th>
        <th>형태</th>
        <th style="width:90px;">필수 동의</th>
        <th style="width:70px;">버전</th>
        <th style="width:120px;">생성일</th>
        <th style="width:80px;">관리</th>
      </tr>
    </thead>
  </table>

</div>

<div class="modal-overlay" id="modalOverlay">
  <div class="modal-box modal-lg">
    <div class="modal-header">
      <span id="modalTitle">약관 등록</span>
      <button type="button" class="modal-close" id="btnModalClose">&times;</button>
    </div>
    <div class="modal-body">
      <table class="form-table">
        <tr>
          <th>구분</th>
          <td>
            <select id="fAppType" class="form-control" style="width:160px;">
              <c:forEach var="code" items="${appTypeCodes}">
                <option value="${code.code}">${code.codeNm}</option>
              </c:forEach>
            </select>
          </td>
          <th>형태</th>
          <td>
            <select id="fTermsType" class="form-control" style="width:200px;">
              <c:forEach var="code" items="${termsTypeCodes}">
                <option value="${code.code}">${code.codeNm}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <th>필수 동의</th>
          <td>
            <select id="fRequiredYn" class="form-control" style="width:100px;">
              <option value="Y">Y</option>
              <option value="N">N</option>
            </select>
          </td>
          <th>버전 <span class="req">*</span></th>
          <td>
            <input type="number" id="fVersion" class="form-control" min="1" value="1" style="width:100px;">
          </td>
        </tr>
        <tr>
          <th>내용 <span class="req">*</span></th>
          <td colspan="3">
            <textarea id="fContent" class="form-control" rows="14" placeholder="약관 내용을 입력하세요..."></textarea>
          </td>
        </tr>
      </table>
      <input type="hidden" id="fTermsNo">
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-outline" id="btnClose">닫기</button>
      <button type="button" class="btn btn-indigo"  id="btnSave">저장</button>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<script>
var ctx = '${ctx}';
var table;

function loadTable() {
  if (table) { table.destroy(); $('#termsTable tbody').empty(); }
  $.get(ctx + '/board/terms/list/json', {
    appType:   $('#filterAppType').val(),
    termsType: $('#filterTermsType').val()
  })
  .done(function(data) {
    table = $('#termsTable').DataTable({
      data: data,
      columns: [
        { data: 'appTypeNm',   className: 'dt-center', defaultContent: '-',
          render: function(d) {
            return '<span class="badge badge-default">' + (d || '-') + '</span>';
          }
        },
        { data: 'termsTypeNm', defaultContent: '-' },
        { data: 'requiredYn',  className: 'dt-center',
          render: function(d) {
            return d === 'Y'
              ? '<span class="badge badge-active">Y</span>'
              : '<span class="badge badge-inactive">N</span>';
          }
        },
        { data: 'version',     className: 'dt-center' },
        { data: 'createdAt',   className: 'dt-center',
          render: function(d) { return fmtDt(d, 10); }
        },
        { data: null, className: 'dt-center', orderable: false,
          render: function(d, t, row) {
            return '<button type="button" class="btn btn-outline btn-sm btn-edit" ' +
                   'data-no="' + row.termsNo + '">수정</button>';
          }
        }
      ],
      order: [[0, 'asc']]
    });
  })
  .fail(function(xhr) { console.error('[약관 목록 조회 실패]', xhr.status, xhr.responseText); });
}

$('#btnSearch').on('click', loadTable);
$('#btnReset').on('click', function() {
  $('#filterAppType').val(''); $('#filterTermsType').val(''); loadTable();
});

$('#btnAdd').on('click', function() {
  clearForm(); $('#modalTitle').text('약관 등록'); openModal();
});

$(document).on('click', '.btn-edit', function() {
  var termsNo = $(this).data('no');
  $.get(ctx + '/board/terms/one', { termsNo: termsNo }, function(data) {
    $('#fTermsNo').val(data.termsNo);
    $('#fAppType').val(data.appTypeCd);
    $('#fTermsType').val(data.termsTypeCd);
    $('#fRequiredYn').val(data.requiredYn);
    $('#fVersion').val(data.version);
    $('#fContent').val(data.content);
    $('#modalTitle').text('약관 수정');
    openModal();
  });
});

$('#btnSave').on('click', function() {
  var version = $('#fVersion').val();
  var content = $('#fContent').val().trim();
  if (!version || version < 1) { alert('버전을 입력하세요.'); return; }
  if (!content)                { alert('내용을 입력하세요.'); return; }
  var termsNo = $('#fTermsNo').val();
  var payload = {
    termsNo:     termsNo ? Number(termsNo) : null,
    appTypeCd:   $('#fAppType').val(),
    termsTypeCd: $('#fTermsType').val(),
    requiredYn:  $('#fRequiredYn').val(),
    version:     Number(version),
    content:     content
  };
  $.ajax({
    url: ctx + '/board/terms/save', method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(payload),
    success: function(res) {
      if (res.result === 'success') { closeModal(); loadTable(); }
      else { alert('처리 중 오류가 발생했습니다.'); }
    }
  });
});

function clearForm() {
  $('#fTermsNo').val('');
  $('#fAppType').val($('#fAppType option:first').val());
  $('#fTermsType').val($('#fTermsType option:first').val());
  $('#fRequiredYn').val('Y');
  $('#fVersion').val('1');
  $('#fContent').val('');
}

$('#btnClose, #btnModalClose').on('click', closeModal);
$('#modalOverlay').on('click', function(e) { if ($(e.target).is('#modalOverlay')) closeModal(); });

$(document).ready(loadTable);
</script>
</body>
</html>
