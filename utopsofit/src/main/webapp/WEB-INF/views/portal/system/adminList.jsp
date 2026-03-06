<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>관리자 계정 관리</title>
<%@ include file="/WEB-INF/views/cmm/layout/head.jsp" %>
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">

  <div class="page-header">
    <div>
      <h1>관리자 계정 관리</h1>
      <p class="page-desc">포털 로그인 관리자 계정을 등록하고 관리합니다.</p>
    </div>
    <div class="page-header-actions">
      <button type="button" class="btn btn-indigo" id="btnAdd">+ 추가</button>
    </div>
  </div>

  <div class="search-box">
    <div class="search-item">
      <span class="search-label">역할</span>
      <select id="filterRoleCd" class="search-select">
        <option value="">전체</option>
        <c:forEach var="role" items="${roles}">
          <option value="${role.code}">${role.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-divider"></div>
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
      <input type="text" id="filterKeyword" class="search-input" placeholder="ID, 이름, 이메일 검색" style="min-width:200px;">
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="adminTable">
    <thead>
      <tr>
        <th style="width:120px;">사용자ID</th>
        <th style="width:120px;">사용자명</th>
        <th style="width:140px;">그룹(역할)</th>
        <th style="width:80px;">사용</th>
        <th style="width:120px;">등록일</th>
        <th style="width:100px;">PW변경</th>
        <th style="width:120px;">수정일</th>
        <th style="width:160px;">관리</th>
      </tr>
    </thead>
  </table>

</div>

<!-- 등록/수정 모달 -->
<div class="modal-overlay" id="adminModal">
  <div class="modal-box modal-sm">
    <div class="modal-header">
      <span id="modalTitle">새 관리자 등록</span>
      <button type="button" class="modal-close" id="btnModalClose">&times;</button>
    </div>
    <div class="modal-body">
      <table class="form-table">
        <tr>
          <th>사용자 ID <span class="req">*</span></th>
          <td>
            <div style="display:flex;gap:8px;align-items:center;">
              <input type="text" id="fUsrId" class="form-control" placeholder="영문/숫자 4~20자" style="flex:1;">
              <button type="button" class="btn btn-outline btn-sm" id="btnCheckId" style="white-space:nowrap;">중복확인</button>
            </div>
            <span id="idCheckMsg" style="font-size:.78rem;margin-top:4px;display:block;"></span>
          </td>
        </tr>
        <tr>
          <th>사용자명 <span class="req">*</span></th>
          <td><input type="text" id="fUsrNm" class="form-control" placeholder="이름"></td>
        </tr>
        <tr>
          <th>초기 비밀번호 <span class="req">*</span></th>
          <td>
            <input type="password" id="fUsrPw" class="form-control" placeholder="••••••">
            <span style="font-size:.75rem;color:#94a3b8;margin-top:3px;display:block;">미입력 시 Admin1234! 로 설정</span>
          </td>
        </tr>
        <tr>
          <th>이메일</th>
          <td><input type="text" id="fEmail" class="form-control" placeholder="example@email.com"></td>
        </tr>
        <tr>
          <th>관리자 역할 <span class="req">*</span></th>
          <td>
            <select id="fRoleCd" class="form-control">
              <option value="">-- 선택 --</option>
              <c:forEach var="role" items="${roles}">
                <option value="${role.code}">${role.codeNm}</option>
              </c:forEach>
            </select>
          </td>
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
      </table>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-outline" id="btnClose">취소</button>
      <button type="button" class="btn btn-indigo"  id="btnSave">저장</button>
    </div>
  </div>
</div>

<!-- PW 초기화 모달 -->
<div class="modal-overlay" id="pwModal">
  <div class="modal-box" style="max-width:420px;">
    <div class="modal-header">
      <span>비밀번호 초기화</span>
      <button type="button" class="modal-close" id="btnPwModalClose">&times;</button>
    </div>
    <div class="modal-body">
      <p style="font-size:.9rem;color:#64748b;margin-bottom:12px;"><strong id="pwTargetId"></strong> 계정의 비밀번호를 초기화합니다.</p>
      <table class="form-table">
        <tr>
          <th>새 비밀번호</th>
          <td>
            <input type="password" id="fNewPw" class="form-control" placeholder="미입력 시 Admin1234!">
          </td>
        </tr>
      </table>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-outline" id="btnPwClose">취소</button>
      <button type="button" class="btn btn-primary"  id="btnPwSave">초기화</button>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<script>
var ctx = '${ctx}';
var isNew = true;
var idChecked = false;
var table;

function loadTable() {
  if (table) { table.destroy(); $('#adminTable tbody').empty(); }
  $.get(ctx + '/system/admin/list/json', {
    searchKeyword: $('#filterKeyword').val(),
    searchRoleCd:  $('#filterRoleCd').val(),
    searchUseYn:   $('#filterUseYn').val()
  })
  .done(function(data) {
    table = $('#adminTable').DataTable({
      data: data,
      columns: [
        { data: 'usrId',     className: 'dt-center' },
        { data: 'usrNm',     className: 'dt-center', defaultContent: '-' },
        { data: 'roleNm',    className: 'dt-center', defaultContent: '-',
          render: function(d) { return d ? '<span class="badge badge-primary">' + d + '</span>' : '-'; }
        },
        { data: 'useYn',     className: 'dt-center',
          render: function(d) {
            return d === 'Y'
              ? '<span class="badge badge-success">사용</span>'
              : '<span class="badge badge-danger">미사용</span>';
          }
        },
        { data: 'createdAt', className: 'dt-center',
          render: function(d) { return fmtDt(d, 10); }
        },
        { data: 'pwdChgDt',  className: 'dt-center',
          render: function(d) { return d ? d : '<span style="color:#94a3b8;">미변경</span>'; }
        },
        { data: 'updatedAt', className: 'dt-center',
          render: function(d) { return fmtDt(d, 10); }
        },
        { data: null, className: 'dt-center', orderable: false,
          render: function(d, t, row) {
            return '<button class="btn btn-sm btn-outline btn-edit" data-id="' + row.usrId + '">수정</button>'
                 + ' <button class="btn btn-sm btn-danger btn-delete" data-id="' + row.usrId + '">삭제</button>';
          }
        }
      ],
      order: [[4, 'desc']]
    });
  })
  .fail(function(xhr) { console.error('[관리자 목록 조회 실패]', xhr.status); });
}

$('#btnSearch').on('click', loadTable);
$('#filterKeyword').on('keydown', function(e) { if (e.key === 'Enter') loadTable(); });
$('#btnReset').on('click', function() {
  $('#filterRoleCd').val(''); $('#filterUseYn').val(''); $('#filterKeyword').val('');
  loadTable();
});

$('#btnAdd').on('click', function() {
  isNew = true; idChecked = false; clearForm();
  $('#fUsrId').prop('readonly', false);
  $('#btnCheckId').show();
  $('#idCheckMsg').text('').css('color', '');
  $('#modalTitle').text('새 관리자 등록');
  openModal('#adminModal');
});

$(document).on('click', '.btn-edit', function() {
  var usrId = $(this).data('id');
  $.get(ctx + '/system/admin/one', { usrId: usrId }, function(data) {
    isNew = false; idChecked = true;
    $('#fUsrId').val(data.usrId).prop('readonly', true);
    $('#btnCheckId').hide();
    $('#idCheckMsg').text('');
    $('#fUsrNm').val(data.usrNm);
    $('#fUsrPw').val('');
    $('#fEmail').val(data.email || '');
    $('#fRoleCd').val(data.roleCd);
    $('#fUseYn').val(data.useYn);
    $('#modalTitle').text('관리자 계정 수정');
    openModal('#adminModal');
  });
});

$(document).on('click', '.btn-delete', function() {
  var usrId = $(this).data('id');
  if (!confirm('[' + usrId + '] 계정을 삭제하시겠습니까?')) return;
  $.ajax({
    url: ctx + '/system/admin/delete', method: 'POST',
    data: { usrId: usrId },
    success: function() { loadTable(); }
  });
});

$('#btnCheckId').on('click', function() {
  var usrId = $('#fUsrId').val().trim();
  if (!usrId) { alert('사용자 ID를 입력하세요.'); return; }
  $.get(ctx + '/system/admin/check-id', { usrId: usrId }, function(res) {
    if (res.duplicate) {
      idChecked = false;
      $('#idCheckMsg').text('이미 사용 중인 ID입니다.').css('color', '#ef4444');
    } else {
      idChecked = true;
      $('#idCheckMsg').text('사용 가능한 ID입니다.').css('color', '#22c55e');
    }
  });
});

$('#btnSave').on('click', function() {
  var usrId  = $('#fUsrId').val().trim();
  var usrNm  = $('#fUsrNm').val().trim();
  var roleCd = $('#fRoleCd').val();
  if (!usrId)              { alert('사용자 ID를 입력하세요.'); return; }
  if (isNew && !idChecked) { alert('ID 중복 확인을 해주세요.'); return; }
  if (!usrNm)              { alert('사용자명을 입력하세요.'); return; }
  if (!roleCd)             { alert('관리자 역할을 선택하세요.'); return; }
  $.ajax({
    url: ctx + '/system/admin/save', method: 'POST',
    data: { usrId: usrId, usrNm: usrNm, usrPw: $('#fUsrPw').val(),
            email: $('#fEmail').val().trim(), roleCd: roleCd, useYn: $('#fUseYn').val() },
    success: function() { closeModal('#adminModal'); loadTable(); }
  });
});

$('#btnPwSave').on('click', function() {
  var usrId = $('#pwTargetId').text();
  $.ajax({
    url: ctx + '/system/admin/reset-password', method: 'POST',
    data: { usrId: usrId, newPassword: $('#fNewPw').val() },
    success: function(msg) { alert(msg); closeModal('#pwModal'); }
  });
});

$('#btnPwClose, #btnPwModalClose').on('click', function() { closeModal('#pwModal'); });
$('#pwModal').on('click',    function(e) { if ($(e.target).is('#pwModal'))    closeModal('#pwModal'); });
$('#btnClose, #btnModalClose').on('click', function() { closeModal('#adminModal'); });
$('#adminModal').on('click', function(e) { if ($(e.target).is('#adminModal')) closeModal('#adminModal'); });

function clearForm() {
  $('#fUsrId').val(''); $('#fUsrNm').val(''); $('#fUsrPw').val('');
  $('#fEmail').val(''); $('#fRoleCd').val(''); $('#fUseYn').val('Y');
  $('#idCheckMsg').text('');
}

$(document).ready(loadTable);
</script>
</body>
</html>
