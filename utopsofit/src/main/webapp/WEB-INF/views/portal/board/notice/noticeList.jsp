<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>공지사항 관리</title>
<%@ include file="/WEB-INF/views/cmm/layout/head.jsp" %>
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">

  <div class="page-header">
    <div>
      <h1>공지사항 관리</h1>
      <p class="page-desc">앱 공지사항을 등록하고 관리합니다.</p>
    </div>
    <div class="page-header-actions">
      <button type="button" class="btn btn-outline" id="btnDelete">삭제</button>
      <button type="button" class="btn btn-indigo"  id="btnAdd">추가</button>
    </div>
  </div>

  <div class="search-box">
    <div class="search-item">
      <span class="search-label">분류</span>
      <select id="filterType" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${noticeTypeCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-divider"></div>
    <div class="search-item">
      <span class="search-label">검색</span>
      <input type="text" id="filterKeyword" class="search-input" placeholder="제목 검색" style="min-width:220px;">
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="noticeTable">
    <thead>
      <tr>
        <th style="width:40px;"><input type="checkbox" id="chkAll"></th>
        <th style="width:60px;">No</th>
        <th style="width:80px;">분류</th>
        <th>제목</th>
        <th style="width:60px;">고정</th>
        <th style="width:100px;">등록자</th>
        <th style="width:150px;">등록일시</th>
      </tr>
    </thead>
  </table>

</div>

<div class="modal-overlay" id="modalOverlay">
  <div class="modal-box modal-sm">
    <div class="modal-header">
      <span id="modalTitle">공지사항 등록</span>
      <button type="button" class="modal-close" id="btnModalClose">&times;</button>
    </div>
    <div class="modal-body">
      <table class="form-table">
        <tr>
          <th>순번</th>
          <td><input type="text" id="fNoticeNo" class="form-control" readonly style="width:80px;"></td>
          <th>상단고정</th>
          <td>
            <label class="auth-child-item">
              <input type="checkbox" id="fPinYn"> 상단에 고정
            </label>
          </td>
        </tr>
        <tr>
          <th>분류 <span class="req">*</span></th>
          <td colspan="3">
            <select id="fNoticeType" class="form-control" style="width:150px;">
              <c:forEach var="code" items="${noticeTypeCodes}">
                <option value="${code.code}">${code.codeNm}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <th>제목 <span class="req">*</span></th>
          <td colspan="3"><input type="text" id="fTitle" class="form-control" placeholder="제목을 입력하세요"></td>
        </tr>
        <tr>
          <th>내용 <span class="req">*</span></th>
          <td colspan="3">
            <textarea id="fContent" class="form-control" rows="8" placeholder="내용을 입력하세요..."></textarea>
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

<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<script>
var ctx = '${ctx}';
var table;

function loadTable() {
  if (table) { table.destroy(); $('#noticeTable tbody').empty(); }
  $.get(ctx + '/board/notice/list/json', {
    type:    $('#filterType').val(),
    keyword: $('#filterKeyword').val()
  })
  .done(function(data) {
    table = $('#noticeTable').DataTable({
      data: data,
      columns: [
        { data: null, className: 'dt-center', orderable: false,
          render: function(d, t, row) {
            return '<input type="checkbox" class="chk-row" data-no="' + row.noticeNo + '">';
          }
        },
        { data: 'noticeNo', className: 'dt-center' },
        { data: 'noticeTypeNm', className: 'dt-center', defaultContent: '-',
          render: function(d, t, row) { return badgeHtml(row.noticeCd, d); }
        },
        { data: 'title',
          render: function(d, t, row) {
            var pin = row.pinYn === 'Y'
              ? '<span class="badge badge-warning" style="margin-right:4px;">고정</span>' : '';
            return pin + '<a href="javascript:void(0)" class="link-title" data-no="'
              + row.noticeNo + '">' + d + '</a>';
          }
        },
        { data: 'pinYn', className: 'dt-center',
          render: function(d) { return d === 'Y' ? '✔' : '-'; }
        },
        { data: 'createdBy', className: 'dt-center', defaultContent: '-' },
        { data: 'createdAt', className: 'dt-center',
          render: function(d) { return fmtDt(d, 16); }
        }
      ],
      order: [[1, 'desc']]
    });
  })
  .fail(function(xhr) { console.error('[공지사항 목록 조회 실패]', xhr.status, xhr.responseText); });
}

$('#chkAll').on('change', function() {
  $('.chk-row').prop('checked', $(this).is(':checked'));
});
$('#btnSearch').on('click', loadTable);
$('#filterKeyword').on('keydown', function(e) { if (e.key === 'Enter') loadTable(); });
$('#btnReset').on('click', function() {
  $('#filterType').val(''); $('#filterKeyword').val(''); loadTable();
});

$('#btnAdd').on('click', function() {
  clearForm(); $('#modalTitle').text('공지사항 등록'); openModal();
});

$(document).on('click', '.link-title', function() {
  var noticeNo = $(this).data('no');
  $.get(ctx + '/board/notice/one', { noticeNo: noticeNo }, function(data) {
    $('#fNoticeNo').val(data.noticeNo);
    $('#fNoticeType').val(data.noticeCd);
    $('#fTitle').val(data.title);
    $('#fContent').val(data.content);
    $('#fPinYn').prop('checked', data.pinYn === 'Y');
    $('#modalTitle').text('공지사항 수정');
    openModal();
  });
});

$('#btnDelete').on('click', function() {
  var checked = $('.chk-row:checked');
  if (checked.length === 0) { alert('삭제할 항목을 선택하세요.'); return; }
  if (!confirm(checked.length + '건을 삭제하시겠습니까?')) return;
  var promises = [];
  checked.each(function() {
    var no = $(this).data('no');
    promises.push($.ajax({ url: ctx + '/board/notice/delete', method: 'POST', data: { noticeNo: no } }));
  });
  $.when.apply($, promises).done(function() { loadTable(); });
});

$('#btnSave').on('click', function() {
  var title   = $('#fTitle').val().trim();
  var content = $('#fContent').val().trim();
  if (!title)   { alert('제목을 입력하세요.'); return; }
  if (!content) { alert('내용을 입력하세요.'); return; }
  var noticeNo = $('#fNoticeNo').val();
  var payload  = {
    noticeNo: noticeNo ? Number(noticeNo) : null,
    noticeCd: $('#fNoticeType').val(),
    title:    title,
    content:  content,
    pinYn:    $('#fPinYn').is(':checked') ? 'Y' : 'N'
  };
  $.ajax({
    url: ctx + '/board/notice/save', method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(payload),
    success: function(res) {
      if (res.result === 'success') { closeModal(); loadTable(); }
      else { alert('처리 중 오류가 발생했습니다.'); }
    }
  });
});

function clearForm() {
  $('#fNoticeNo').val('');
  $('#fNoticeType').val($('#fNoticeType option:first').val());
  $('#fTitle').val(''); $('#fContent').val(''); $('#fPinYn').prop('checked', false);
}

$('#btnClose, #btnModalClose').on('click', closeModal);
$('#modalOverlay').on('click', function(e) { if ($(e.target).is('#modalOverlay')) closeModal(); });

$(document).ready(loadTable);
</script>
</body>
</html>
