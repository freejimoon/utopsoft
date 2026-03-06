<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>FAQ 관리</title>
<%@ include file="/WEB-INF/views/cmm/layout/head.jsp" %>
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">

  <div class="page-header">
    <div>
      <h1>FAQ 관리</h1>
      <p class="page-desc">자주 묻는 질문(FAQ)을 등록하고 관리합니다.</p>
    </div>
    <div class="page-header-actions">
      <button type="button" class="btn btn-outline" id="btnDelete">삭제</button>
      <button type="button" class="btn btn-indigo"  id="btnAdd">추가</button>
    </div>
  </div>

  <div class="search-box">
    <div class="search-item">
      <span class="search-label">분류</span>
      <select id="filterCategory" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${categoryCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-divider"></div>
    <div class="search-item">
      <span class="search-label">검색</span>
      <input type="text" id="filterKeyword" class="search-input" placeholder="질문 검색" style="min-width:220px;">
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="faqTable">
    <thead>
      <tr>
        <th style="width:40px;"><input type="checkbox" id="chkAll"></th>
        <th style="width:60px;">순번</th>
        <th style="width:90px;">분류</th>
        <th>질문</th>
        <th style="width:60px;">첨부</th>
        <th style="width:100px;">등록자</th>
        <th style="width:150px;">등록일시</th>
      </tr>
    </thead>
  </table>

</div>

<!-- ── FAQ 등록/수정 모달 ──────────────────────────── -->
<div class="modal-overlay" id="modalOverlay">
  <div class="modal-box modal-sm">
    <div class="modal-header">
      <span id="modalTitle">FAQ 등록</span>
      <button type="button" class="modal-close" id="btnModalClose">&times;</button>
    </div>
    <div class="modal-body">
      <table class="form-table">
        <tr>
          <th>순번</th>
          <td colspan="3">
            <input type="text" id="fFaqNo" class="form-control" readonly style="background:#f3f4f6;width:80px;">
          </td>
        </tr>
        <tr>
          <th>분류 <span class="req">*</span></th>
          <td colspan="3">
            <select id="fCategory" class="form-control" style="width:160px;">
              <c:forEach var="code" items="${categoryCodes}">
                <option value="${code.code}">${code.codeNm}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <th>질문 <span class="req">*</span></th>
          <td colspan="3">
            <input type="text" id="fQuestion" class="form-control" placeholder="질문을 입력하세요">
          </td>
        </tr>
        <tr>
          <th>답변 <span class="req">*</span></th>
          <td colspan="3">
            <textarea id="fAnswer" class="form-control" rows="8" placeholder="답변을 입력하세요..."></textarea>
          </td>
        </tr>
        <tr>
          <th>첨부파일</th>
          <td colspan="3">
            <!-- 기존 첨부파일 목록 -->
            <div id="attachList" style="margin-bottom:8px;"></div>
            <!-- 파일 선택 -->
            <div id="newFileArea">
              <input type="file" id="fFileInput" multiple style="display:none;">
              <button type="button" class="btn btn-outline btn-sm" id="btnFileAdd"
                      style="font-size:12px;padding:4px 12px;">파일 추가</button>
              <span style="font-size:11px;color:#94a3b8;margin-left:8px;">최대 10MB / 파일당</span>
              <!-- 선택된 새 파일 미리보기 -->
              <div id="newFileList" style="margin-top:6px;"></div>
            </div>
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
var selectedFiles = []; // 저장 전 선택된 새 파일 목록

/* ── 목록 로드 ─────────────────────────────────────── */
function loadTable() {
  if (table) { table.destroy(); $('#faqTable tbody').empty(); }
  $.get(ctx + '/board/faq/list/json', {
    category: $('#filterCategory').val(),
    keyword:  $('#filterKeyword').val()
  })
  .done(function(data) {
    table = $('#faqTable').DataTable({
      data: data,
      columns: [
        { data: null, className: 'dt-center', orderable: false,
          render: function(d, t, row) {
            return '<input type="checkbox" class="chk-row" data-no="' + row.faqNo + '">';
          }
        },
        { data: 'faqNo',      className: 'dt-center' },
        { data: 'categoryNm', className: 'dt-center', defaultContent: '-',
          render: function(d) {
            return '<span class="badge badge-default">' + (d || '-') + '</span>';
          }
        },
        { data: 'question',
          render: function(d, t, row) {
            return '<a href="javascript:void(0)" class="link-row" data-no="' + row.faqNo + '">' + d + '</a>';
          }
        },
        { data: 'attachCount', className: 'dt-center',
          render: function(d) {
            return d > 0 ? '<span class="badge badge-default">📎 ' + d + '</span>' : '-';
          }
        },
        { data: 'createdBy', className: 'dt-center', defaultContent: '-' },
        { data: 'createdAt', className: 'dt-center',
          render: function(d) { return fmtDt(d, 16); }
        }
      ],
      order: [[1, 'asc']]
    });
  })
  .fail(function(xhr) { console.error('[FAQ 목록 조회 실패]', xhr.status, xhr.responseText); });
}

/* ── 검색 ─────────────────────────────────────────── */
$('#chkAll').on('change', function() {
  $('.chk-row').prop('checked', $(this).is(':checked'));
});
$('#btnSearch').on('click', loadTable);
$('#filterKeyword').on('keydown', function(e) { if (e.key === 'Enter') loadTable(); });
$('#btnReset').on('click', function() {
  $('#filterCategory').val(''); $('#filterKeyword').val(''); loadTable();
});

/* ── 추가 버튼 ─────────────────────────────────────── */
$('#btnAdd').on('click', function() {
  clearForm(); $('#modalTitle').text('FAQ 등록'); openModal();
});

/* ── 행 클릭 (수정) ────────────────────────────────── */
$(document).on('click', '.link-row', function() {
  var faqNo = $(this).data('no');
  $.get(ctx + '/board/faq/one', { faqNo: faqNo }, function(data) {
    $('#fFaqNo').val(data.faqNo);
    $('#fCategory').val(data.categoryCd);
    $('#fQuestion').val(data.question);
    $('#fAnswer').val(data.answer);
    $('#modalTitle').text('FAQ 수정');
    renderAttachList(data.attachList || []);
    openModal();
  });
});

/* ── 삭제 버튼 ─────────────────────────────────────── */
$('#btnDelete').on('click', function() {
  var checked = $('.chk-row:checked');
  if (checked.length === 0) { alert('삭제할 항목을 선택하세요.'); return; }
  if (!confirm(checked.length + '건을 삭제하시겠습니까?')) return;
  var promises = [];
  checked.each(function() {
    var no = $(this).data('no');
    promises.push($.ajax({ url: ctx + '/board/faq/delete', method: 'POST', data: { faqNo: no } }));
  });
  $.when.apply($, promises).done(function() { loadTable(); });
});

/* ── 저장 버튼 ─────────────────────────────────────── */
$('#btnSave').on('click', function() {
  var question = $('#fQuestion').val().trim();
  var answer   = $('#fAnswer').val().trim();
  if (!question) { alert('질문을 입력하세요.'); return; }
  if (!answer)   { alert('답변을 입력하세요.'); return; }

  var faqNo   = $('#fFaqNo').val();
  var payload = {
    faqNo:      faqNo ? Number(faqNo) : null,
    categoryCd: $('#fCategory').val(),
    question:   question,
    answer:     answer
  };

  $.ajax({
    url: ctx + '/board/faq/save', method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(payload),
    success: function(res) {
      if (res.result === 'success') {
        var savedFaqNo = res.faqNo;
        if (selectedFiles.length > 0) {
          uploadFiles(savedFaqNo, function() {
            closeModal(); loadTable();
          });
        } else {
          closeModal(); loadTable();
        }
      } else {
        alert('처리 중 오류가 발생했습니다.');
      }
    }
  });
});

/* ── 파일 추가 버튼 ────────────────────────────────── */
$('#btnFileAdd').on('click', function() { $('#fFileInput').click(); });
$('#fFileInput').on('change', function() {
  $.each(this.files, function(i, f) {
    if (f.size > 10 * 1024 * 1024) { alert(f.name + ' 파일이 10MB를 초과합니다.'); return; }
    selectedFiles.push(f);
  });
  this.value = '';
  renderNewFileList();
});

/* ── 선택된 새 파일 목록 렌더링 ───────────────────── */
function renderNewFileList() {
  var html = '';
  $.each(selectedFiles, function(i, f) {
    html += '<div class="attach-item" style="display:flex;align-items:center;gap:6px;margin-bottom:4px;">' +
            '<span style="font-size:12px;color:#374151;flex:1;">📄 ' + escapeHtml(f.name) +
            ' <span style="color:#94a3b8;">(' + formatSize(f.size) + ')</span></span>' +
            '<button type="button" class="btn-attach-del-new" data-idx="' + i + '" ' +
            'style="background:none;border:none;color:#ef4444;cursor:pointer;font-size:14px;padding:0 4px;">&times;</button>' +
            '</div>';
  });
  $('#newFileList').html(html);
}

/* ── 기존 첨부파일 목록 렌더링 ─────────────────────── */
function renderAttachList(list) {
  var html = '';
  $.each(list, function(i, a) {
    html += '<div class="attach-item" style="display:flex;align-items:center;gap:6px;margin-bottom:4px;">' +
            '<a href="' + ctx + '/attach/download?attachNo=' + a.attachNo + '" ' +
            'style="font-size:12px;color:#3b82f6;flex:1;text-decoration:none;" download>' +
            '📎 ' + escapeHtml(a.origNm) +
            ' <span style="color:#94a3b8;">(' + formatSize(a.fileSize) + ')</span>' +
            '</a>' +
            '<button type="button" class="btn-attach-del" data-no="' + a.attachNo + '" ' +
            'style="background:none;border:none;color:#ef4444;cursor:pointer;font-size:14px;padding:0 4px;">&times;</button>' +
            '</div>';
  });
  $('#attachList').html(html);
}

/* ── 새 파일 제거 ──────────────────────────────────── */
$(document).on('click', '.btn-attach-del-new', function() {
  var idx = $(this).data('idx');
  selectedFiles.splice(idx, 1);
  renderNewFileList();
});

/* ── 기존 파일 삭제 ────────────────────────────────── */
$(document).on('click', '.btn-attach-del', function() {
  var no  = $(this).data('no');
  var $el = $(this).closest('.attach-item');
  if (!confirm('첨부파일을 삭제하시겠습니까?')) return;
  $.post(ctx + '/attach/delete', { attachNo: no }, function(res) {
    if (res.result === 'success') $el.remove();
    else alert('파일 삭제에 실패했습니다.');
  });
});

/* ── 파일 업로드 (순차) ────────────────────────────── */
function uploadFiles(faqNo, callback) {
  var queue = selectedFiles.slice();
  function next() {
    if (queue.length === 0) { selectedFiles = []; renderNewFileList(); callback(); return; }
    var f  = queue.shift();
    var fd = new FormData();
    fd.append('refType', 'FAQ');
    fd.append('refNo',   faqNo);
    fd.append('file',    f);
    $.ajax({
      url: ctx + '/attach/upload', method: 'POST',
      data: fd, processData: false, contentType: false,
      success: function() { next(); },
      error: function() { alert(f.name + ' 업로드에 실패했습니다.'); next(); }
    });
  }
  next();
}

/* ── 폼 초기화 ─────────────────────────────────────── */
function clearForm() {
  $('#fFaqNo').val('');
  $('#fCategory').val($('#fCategory option:first').val());
  $('#fQuestion').val('');
  $('#fAnswer').val('');
  $('#attachList').empty();
  $('#newFileList').empty();
  selectedFiles = [];
}

/* ── 유틸 ──────────────────────────────────────────── */
function escapeHtml(s) {
  return s ? s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;') : '';
}
function formatSize(bytes) {
  if (bytes < 1024) return bytes + 'B';
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + 'KB';
  return (bytes / 1024 / 1024).toFixed(1) + 'MB';
}

/* ── 모달 닫기 ─────────────────────────────────────── */
$('#btnClose, #btnModalClose').on('click', closeModal);
$('#modalOverlay').on('click', function(e) { if ($(e.target).is('#modalOverlay')) closeModal(); });

$(document).ready(loadTable);
</script>
</body>
</html>
