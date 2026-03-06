<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>앱 클라이언트 관리</title>
<%@ include file="/WEB-INF/views/cmm/layout/head.jsp" %>
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">

  <div class="page-header">
    <div>
      <h1>앱 클라이언트 관리</h1>
      <p class="page-desc">앱 REST API 호출에 사용되는 appId / appSecret 자격증명을 발급하고 관리합니다.</p>
    </div>
    <div class="page-header-actions">
      <button type="button" class="btn btn-indigo" id="btnAdd">+ 신규 발급</button>
    </div>
  </div>

  <div class="search-box">
    <div class="search-item">
      <span class="search-label">사용</span>
      <select id="filterUseYn" class="search-select">
        <option value="">전체</option>
        <option value="Y">사용</option>
        <option value="N">미사용</option>
      </select>
    </div>
    <div class="search-divider"></div>
    <div class="search-item">
      <span class="search-label">검색</span>
      <input type="text" id="filterKeyword" class="search-input search-input-wide" placeholder="앱 ID, 앱 이름 검색">
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="appClientTable">
    <thead>
      <tr>
        <th style="width:160px;">앱 ID</th>
        <th style="width:160px;">앱 이름</th>
        <th style="width:80px;">사용</th>
        <th>메모</th>
        <th style="width:120px;">등록일</th>
        <th style="width:120px;">수정일</th>
        <th style="width:180px;">관리</th>
      </tr>
    </thead>
  </table>

</div>

<!-- 신규 발급 모달 -->
<div class="modal-overlay" id="registerModal">
  <div class="modal-box modal-sm">
    <div class="modal-header">
      <span>앱 클라이언트 신규 발급</span>
      <button type="button" class="modal-close" id="btnRegModalClose">&times;</button>
    </div>
    <div class="modal-body">
      <table class="form-table">
        <tr>
          <th>앱 ID <span class="req">*</span></th>
          <td>
            <div class="input-with-btn">
              <input type="text" id="fAppId" class="form-control" placeholder="영문/숫자/하이픈 최대 50자">
              <button type="button" class="btn btn-outline btn-sm" id="btnCheckId">중복확인</button>
            </div>
            <span id="idCheckMsg"></span>
          </td>
        </tr>
        <tr>
          <th>앱 이름 <span class="req">*</span></th>
          <td><input type="text" id="fAppNm" class="form-control" placeholder="예: iOS 앱, Android 앱"></td>
        </tr>
        <tr>
          <th>사용 여부 <span class="req">*</span></th>
          <td>
            <select id="fUseYn" class="form-control">
              <option value="Y">사용 (Active)</option>
              <option value="N">미사용 (Inactive)</option>
            </select>
          </td>
        </tr>
        <tr>
          <th>메모</th>
          <td><textarea id="fMemo" class="form-control" rows="3" placeholder="용도 등 메모"></textarea></td>
        </tr>
      </table>
      <p class="warn-text">
        ⚠ 발급 후 <strong>appSecret 은 1회만 표시</strong>됩니다. 반드시 저장해 두세요.
      </p>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-outline" id="btnRegClose">취소</button>
      <button type="button" class="btn btn-indigo"  id="btnRegSave">발급</button>
    </div>
  </div>
</div>

<!-- 발급 완료 모달 (평문 secret 1회 표시) -->
<div class="modal-overlay" id="secretModal">
  <div class="modal-box modal-secret">
    <div class="modal-header">
      <span>자격증명 발급 완료</span>
      <button type="button" class="modal-close" id="btnSecretClose">&times;</button>
    </div>
    <div class="modal-body">
      <p class="warn-text-danger">
        ⚠ 아래 정보는 <strong>지금만 표시</strong>됩니다. 앱 개발팀에 안전하게 전달하고 별도 보관하세요.
      </p>
      <table class="form-table">
        <tr>
          <th style="width:100px;">앱 ID</th>
          <td><code id="secretAppId" class="code-box"></code></td>
        </tr>
        <tr>
          <th>앱 Secret</th>
          <td>
            <div class="input-with-btn">
              <code id="secretValue" class="code-box"></code>
              <button type="button" class="btn btn-sm btn-outline" id="btnCopySecret">복사</button>
            </div>
          </td>
        </tr>
      </table>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-primary" id="btnSecretConfirm">확인 (닫기)</button>
    </div>
  </div>
</div>

<!-- 수정 모달 -->
<div class="modal-overlay" id="editModal">
  <div class="modal-box modal-sm">
    <div class="modal-header">
      <span>앱 클라이언트 수정</span>
      <button type="button" class="modal-close" id="btnEditModalClose">&times;</button>
    </div>
    <div class="modal-body">
      <table class="form-table">
        <tr>
          <th>앱 ID</th>
          <td><input type="text" id="eAppId" class="form-control" readonly></td>
        </tr>
        <tr>
          <th>앱 이름 <span class="req">*</span></th>
          <td><input type="text" id="eAppNm" class="form-control"></td>
        </tr>
        <tr>
          <th>사용 여부</th>
          <td>
            <select id="eUseYn" class="form-control">
              <option value="Y">사용 (Active)</option>
              <option value="N">미사용 (Inactive)</option>
            </select>
          </td>
        </tr>
        <tr>
          <th>메모</th>
          <td><textarea id="eMemo" class="form-control" rows="3"></textarea></td>
        </tr>
      </table>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-outline" id="btnEditClose">취소</button>
      <button type="button" class="btn btn-indigo"  id="btnEditSave">저장</button>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<script>
var ctx = '${ctx}';
var table;
var idChecked = false;

function loadTable() {
  if (table) { table.destroy(); $('#appClientTable tbody').empty(); }
  $.get(ctx + '/system/app-client/list/json', {
    searchKeyword: $('#filterKeyword').val(),
    searchUseYn:   $('#filterUseYn').val()
  }).done(function(data) {
    table = $('#appClientTable').DataTable({
      data: data,
      columns: [
        { data: 'appId',     className: 'dt-center' },
        { data: 'appNm',     className: 'dt-center', defaultContent: '-' },
        { data: 'useYn',     className: 'dt-center',
          render: function(d) {
            return d === 'Y'
              ? '<span class="badge badge-success">사용</span>'
              : '<span class="badge badge-danger">미사용</span>';
          }
        },
        { data: 'memo',      defaultContent: '-' },
        { data: 'createdAt', className: 'dt-center',
          render: function(d) { return fmtDt(d, 10); }
        },
        { data: 'updatedAt', className: 'dt-center',
          render: function(d) { return fmtDt(d, 10); }
        },
        { data: null, className: 'dt-center', orderable: false,
          render: function(d, t, row) {
            return '<button class="btn btn-sm btn-outline btn-edit"    data-id="' + row.appId + '">수정</button>'
                 + ' <button class="btn btn-sm btn-warning btn-reissue" data-id="' + row.appId + '">재발급</button>'
                 + ' <button class="btn btn-sm btn-danger btn-delete"   data-id="' + row.appId + '">삭제</button>';
          }
        }
      ],
      order: [[4, 'desc']]
    });
  }).fail(function(xhr) { console.error('[앱 클라이언트 목록 오류]', xhr.status); });
}

$('#btnSearch').on('click', loadTable);
$('#filterKeyword').on('keydown', function(e) { if (e.key === 'Enter') loadTable(); });
$('#btnReset').on('click', function() {
  $('#filterUseYn').val(''); $('#filterKeyword').val(''); loadTable();
});

$('#btnAdd').on('click', function() {
  idChecked = false;
  $('#fAppId').val('').prop('readonly', false);
  $('#fAppNm').val(''); $('#fUseYn').val('Y'); $('#fMemo').val('');
  $('#idCheckMsg').text('').css('color', '');
  openModal('#registerModal');
});

$('#btnCheckId').on('click', function() {
  var appId = $('#fAppId').val().trim();
  if (!appId) { alert('앱 ID를 입력하세요.'); return; }
  $.get(ctx + '/system/app-client/check-id', { appId: appId }, function(res) {
    if (res.duplicate) {
      idChecked = false;
      $('#idCheckMsg').text('이미 사용 중인 ID입니다.').css('color', '#ef4444');
    } else {
      idChecked = true;
      $('#idCheckMsg').text('사용 가능한 ID입니다.').css('color', '#22c55e');
    }
  });
});

$('#btnRegSave').on('click', function() {
  var appId = $('#fAppId').val().trim();
  var appNm = $('#fAppNm').val().trim();
  if (!appId)     { alert('앱 ID를 입력하세요.'); return; }
  if (!idChecked) { alert('ID 중복 확인을 해주세요.'); return; }
  if (!appNm)     { alert('앱 이름을 입력하세요.'); return; }
  $.ajax({
    url: ctx + '/system/app-client/register', method: 'POST',
    data: { appId: appId, appNm: appNm, useYn: $('#fUseYn').val(), memo: $('#fMemo').val() },
    success: function(res) {
      closeModal('#registerModal');
      showSecret(res.appId, res.appSecret);
      loadTable();
    }
  });
});

function showSecret(appId, secret) {
  $('#secretAppId').text(appId);
  $('#secretValue').text(secret);
  openModal('#secretModal');
}

$('#btnCopySecret').on('click', function() {
  var secret = $('#secretValue').text();
  if (navigator.clipboard) {
    navigator.clipboard.writeText(secret).then(function() { alert('복사되었습니다.'); });
  } else {
    var tmp = $('<textarea>').val(secret).appendTo('body').select();
    document.execCommand('copy');
    tmp.remove();
    alert('복사되었습니다.');
  }
});

$('#btnSecretConfirm, #btnSecretClose').on('click', function() { closeModal('#secretModal'); });

$(document).on('click', '.btn-edit', function() {
  var appId = $(this).data('id');
  $.get(ctx + '/system/app-client/one', { appId: appId }, function(data) {
    $('#eAppId').val(data.appId);
    $('#eAppNm').val(data.appNm);
    $('#eUseYn').val(data.useYn);
    $('#eMemo').val(data.memo || '');
    openModal('#editModal');
  });
});

$('#btnEditSave').on('click', function() {
  if (!$('#eAppNm').val().trim()) { alert('앱 이름을 입력하세요.'); return; }
  $.ajax({
    url: ctx + '/system/app-client/modify', method: 'POST',
    data: { appId: $('#eAppId').val(), appNm: $('#eAppNm').val(),
            useYn: $('#eUseYn').val(), memo: $('#eMemo').val() },
    success: function() { closeModal('#editModal'); loadTable(); }
  });
});

$(document).on('click', '.btn-reissue', function() {
  var appId = $(this).data('id');
  if (!confirm('[' + appId + '] 의 Secret 을 재발급합니다.\n기존 Secret 은 즉시 무효화됩니다. 계속하시겠습니까?')) return;
  $.ajax({
    url: ctx + '/system/app-client/reissue', method: 'POST',
    data: { appId: appId },
    success: function(res) { showSecret(res.appId, res.appSecret); }
  });
});

$(document).on('click', '.btn-delete', function() {
  var appId = $(this).data('id');
  if (!confirm('[' + appId + '] 클라이언트를 삭제하시겠습니까?')) return;
  $.ajax({
    url: ctx + '/system/app-client/delete', method: 'POST',
    data: { appId: appId },
    success: function() { loadTable(); }
  });
});

$('#btnRegClose, #btnRegModalClose').on('click', function()   { closeModal('#registerModal'); });
$('#btnEditClose, #btnEditModalClose').on('click', function() { closeModal('#editModal'); });
$('#registerModal').on('click', function(e) { if ($(e.target).is('#registerModal')) closeModal('#registerModal'); });
$('#editModal').on('click',     function(e) { if ($(e.target).is('#editModal'))     closeModal('#editModal'); });

$(document).ready(loadTable);
</script>
</body>
</html>
