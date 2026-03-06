<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>문의 관리</title>
<%@ include file="/WEB-INF/views/cmm/layout/head.jsp" %>
</head>
<body>
<%@ include file="/WEB-INF/views/cmm/layout/header.jsp" %>
<div class="page-content">

  <div class="page-header">
    <div>
      <h1>문의 관리</h1>
      <p class="page-desc">회원이 등록한 문의를 조회하고 답변을 관리합니다.</p>
    </div>
  </div>

  <div class="search-box">
    <div class="search-item">
      <span class="search-label">유형</span>
      <select id="filterCategory" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${categoryCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-divider"></div>
    <div class="search-item">
      <span class="search-label">상태</span>
      <select id="filterStatus" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${statusCodes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-divider"></div>
    <div class="search-item">
      <span class="search-label">검색</span>
      <input type="text" id="filterKeyword" class="search-input" placeholder="제목, 계정, 닉네임 검색" style="min-width:220px;">
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="inquiryTable">
    <thead>
      <tr>
        <th style="width:60px;">No</th>
        <th>제목</th>
        <th style="width:90px;">유형</th>
        <th style="width:180px;">등록계정</th>
        <th style="width:130px;">닉네임</th>
        <th style="width:150px;">등록일시</th>
        <th style="width:90px;">상태</th>
        <th style="width:150px;">변경일시</th>
      </tr>
    </thead>
  </table>

</div>

<div class="modal-overlay" id="modalOverlay">
  <div class="modal-box modal-sm">
    <div class="modal-header">
      <span>문의 상세</span>
      <button type="button" class="modal-close" id="btnModalClose">&times;</button>
    </div>
    <div class="modal-body">
      <table class="form-table">
        <tr>
          <th>제목</th>
          <td id="dTitle"></td>
          <th>상태</th>
          <td id="dStatus"></td>
        </tr>
        <tr>
          <th>등록 계정</th>
          <td id="dEmail"></td>
          <th>닉네임</th>
          <td id="dNickname"></td>
        </tr>
        <tr>
          <th>등록일시</th>
          <td id="dCreatedAt" colspan="3"></td>
        </tr>
      </table>
      <hr style="border:none;border-top:1px solid #e9ecef;margin:14px 0;">
      <p style="font-size:.82rem;font-weight:600;color:#6c757d;margin-bottom:6px;">문의 내용</p>
      <div id="dContent" style="background:#f8f9fa;border:1px solid #e9ecef;border-radius:8px;padding:12px;min-height:80px;font-size:.9rem;line-height:1.6;white-space:pre-wrap;"></div>
      <hr style="border:none;border-top:1px solid #e9ecef;margin:14px 0;">
      <p style="font-size:.82rem;font-weight:600;color:#6c757d;margin-bottom:6px;">답변 내용</p>
      <textarea id="dReplyContent" class="form-control" rows="5" placeholder="답변 내용을 입력하세요..."></textarea>
      <input type="hidden" id="dInqNo">
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-outline" id="btnClose">닫기</button>
      <button type="button" class="btn btn-primary" id="btnReply">답변 등록</button>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<script>
var ctx = '${ctx}';
var table;

function loadTable() {
  if (table) { table.destroy(); $('#inquiryTable tbody').empty(); }
  $.get(ctx + '/board/inquiry/list/json', {
    searchCategory: $('#filterCategory').val(),
    searchStatus:   $('#filterStatus').val(),
    searchKeyword:  $('#filterKeyword').val()
  })
  .done(function(data) {
    table = $('#inquiryTable').DataTable({
      data: data,
      columns: [
        { data: 'inqNo',       className: 'dt-center' },
        { data: 'title',
          render: function(d, t, row) {
            return '<a href="javascript:void(0)" class="link-title" data-no="' + row.inqNo + '">' + d + '</a>';
          }
        },
        { data: 'inqCategoryNm', className: 'dt-center', defaultContent: '-',
          render: function(d) { return d ? '<span class="badge badge-default">' + d + '</span>' : '-'; }
        },
        { data: 'memberEmail', className: 'dt-center', defaultContent: '-' },
        { data: 'memberNm',    className: 'dt-center', defaultContent: '-' },
        { data: 'createdAt',   className: 'dt-center',
          render: function(d) { return fmtDt(d, 16); }
        },
        { data: 'inqStatusNm', className: 'dt-center', defaultContent: '-',
          render: function(d, t, row) { return badgeHtml(row.inqStatusCd, d); }
        },
        { data: 'updatedAt',   className: 'dt-center',
          render: function(d) { return fmtDt(d, 16); }
        }
      ],
      order: [[0, 'desc']]
    });
  })
  .fail(function(xhr) {
    console.error('[문의 목록 조회 실패]', xhr.status, xhr.responseText);
    alert('데이터 조회 중 오류가 발생했습니다.');
  });
}

$('#btnSearch').on('click', loadTable);
$('#filterKeyword').on('keydown', function(e) { if (e.key === 'Enter') loadTable(); });
$('#btnReset').on('click', function() {
  $('#filterCategory, #filterStatus').val(''); $('#filterKeyword').val(''); loadTable();
});

$(document).on('click', '.link-title', function() {
  var inqNo = $(this).data('no');
  $.get(ctx + '/board/inquiry/one', { inqNo: inqNo }, function(data) {
    $('#dInqNo').val(data.inqNo);
    $('#dTitle').text(data.title);
    $('#dStatus').html(badgeHtml(data.inqStatusCd, data.inqStatusNm));
    $('#dEmail').text(data.memberEmail || '-');
    $('#dNickname').text(data.memberNm || '-');
    $('#dCreatedAt').text(fmtDt(data.createdAt, 16));
    $('#dContent').text(data.content || '');
    $('#dReplyContent').val(data.replyContent || '');
    if (data.inqStatusCd === 'DONE') {
      $('#dReplyContent').prop('readonly', true);
      $('#btnReply').hide();
    } else {
      $('#dReplyContent').prop('readonly', false);
      $('#btnReply').show();
    }
    openModal();
  });
});

$('#btnReply').on('click', function() {
  var replyContent = $('#dReplyContent').val().trim();
  if (!replyContent) { alert('답변 내용을 입력하세요.'); return; }
  $.ajax({
    url: ctx + '/board/inquiry/reply', method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({ inqNo: $('#dInqNo').val(), replyContent: replyContent }),
    success: function(res) {
      if (res.result === 'success') { closeModal(); loadTable(); }
      else { alert('처리 중 오류가 발생했습니다.'); }
    }
  });
});

$('#btnClose, #btnModalClose').on('click', closeModal);
$('#modalOverlay').on('click', function(e) { if ($(e.target).is('#modalOverlay')) closeModal(); });

$(document).ready(loadTable);
</script>
</body>
</html>
