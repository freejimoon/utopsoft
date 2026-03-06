<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>FAQ 관리</title>
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

  <!-- 페이지 헤더 -->
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

  <!-- 검색 박스 -->
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

  <!-- 목록 테이블 -->
  <table class="code-table" id="faqTable">
    <thead>
      <tr>
        <th style="width:40px;"><input type="checkbox" id="chkAll"></th>
        <th style="width:60px;">순번</th>
        <th style="width:90px;">분류</th>
        <th>질문</th>
        <th style="width:100px;">등록자</th>
        <th style="width:150px;">등록일시</th>
      </tr>
    </thead>
  </table>

</div><!-- /page-content -->

<!-- ===================== FAQ 등록/수정 모달 ===================== -->
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
            <input type="text" id="fFaqNo" class="form-control" readonly
                   style="background:#f3f4f6;width:80px;">
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
            <textarea id="fAnswer" class="form-control" rows="8"
                      placeholder="답변을 입력하세요..."></textarea>
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
var ctx  = '${ctx}';
var csrf = {
  header: $('meta[name="_csrf_header"]').attr('content'),
  token:  $('meta[name="_csrf"]').attr('content')
};

/* ── DataTables 초기화 ─────────────────────────────── */
var table;

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
        { data: 'faqNo',     className: 'dt-center' },
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
        { data: 'createdBy',  className: 'dt-center', defaultContent: '-' },
        { data: 'createdAt',  className: 'dt-center',
          render: function(d) { return d ? d.replace('T', ' ').substring(0, 16) : '-'; }
        }
      ],
      autoWidth: false,
      order: [[1, 'asc']],
      pageLength: 10,
      language: {
        emptyTable: '조회된 데이터가 없습니다.',
        info: '전체 _TOTAL_ 건 중 _START_ ~ _END_',
        infoEmpty: '데이터 없음',
        lengthMenu: '_MENU_ 건씩 보기',
        paginate: { first:'«', previous:'‹', next:'›', last:'»' }
      }
    });
  })
  .fail(function(xhr) {
    console.error('[FAQ 목록 조회 실패]', xhr.status, xhr.responseText);
  });
}

/* ── 전체선택 ─────────────────────────────────────── */
$('#chkAll').on('change', function() {
  $('.chk-row').prop('checked', $(this).is(':checked'));
});

/* ── 검색 ─────────────────────────────────────────── */
$('#btnSearch').on('click', loadTable);
$('#filterKeyword').on('keydown', function(e) { if (e.key === 'Enter') loadTable(); });
$('#btnReset').on('click', function() {
  $('#filterCategory').val('');
  $('#filterKeyword').val('');
  loadTable();
});

/* ── 추가 버튼 ────────────────────────────────────── */
$('#btnAdd').on('click', function() {
  clearForm();
  $('#modalTitle').text('FAQ 등록');
  openModal();
});

/* ── 질문 클릭 → 수정 모달 ────────────────────────── */
$(document).on('click', '.link-row', function() {
  var faqNo = $(this).data('no');
  $.get(ctx + '/board/faq/one', { faqNo: faqNo }, function(data) {
    $('#fFaqNo').val(data.faqNo);
    $('#fCategory').val(data.categoryCd);
    $('#fQuestion').val(data.question);
    $('#fAnswer').val(data.answer);
    $('#modalTitle').text('FAQ 수정');
    openModal();
  });
});

/* ── 삭제 버튼 ────────────────────────────────────── */
$('#btnDelete').on('click', function() {
  var checked = $('.chk-row:checked');
  if (checked.length === 0) { alert('삭제할 항목을 선택하세요.'); return; }
  if (!confirm(checked.length + '건을 삭제하시겠습니까?')) return;

  var promises = [];
  checked.each(function() {
    var no = $(this).data('no');
    promises.push(
      $.ajax({
        url:    ctx + '/board/faq/delete',
        method: 'POST',
        beforeSend: function(xhr) { xhr.setRequestHeader(csrf.header, csrf.token); },
        data:   { faqNo: no }
      })
    );
  });
  $.when.apply($, promises).done(function() { loadTable(); });
});

/* ── 저장 버튼 ────────────────────────────────────── */
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
    url:         ctx + '/board/faq/save',
    method:      'POST',
    contentType: 'application/json',
    beforeSend:  function(xhr) { xhr.setRequestHeader(csrf.header, csrf.token); },
    data:        JSON.stringify(payload),
    success: function(res) {
      if (res.result === 'success') { closeModal(); loadTable(); }
      else { alert('처리 중 오류가 발생했습니다.'); }
    }
  });
});

/* ── 모달 열기/닫기 ──────────────────────────────── */
function openModal()  { $('#modalOverlay').addClass('open'); }
function closeModal() { $('#modalOverlay').removeClass('open'); }

function clearForm() {
  $('#fFaqNo').val('');
  $('#fCategory').val($('#fCategory option:first').val());
  $('#fQuestion').val('');
  $('#fAnswer').val('');
}

$('#btnClose, #btnModalClose').on('click', closeModal);
$('#modalOverlay').on('click', function(e) {
  if ($(e.target).is('#modalOverlay')) closeModal();
});

/* ── 초기 로드 ───────────────────────────────────── */
$(document).ready(loadTable);
</script>
</body>
</html>
