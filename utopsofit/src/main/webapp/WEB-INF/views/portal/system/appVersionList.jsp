<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>앱 버전 관리</title>
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
      <h1>앱 버전 관리</h1>
      <p class="page-desc">앱 스토어별 버전 및 필수 업데이트 여부를 관리합니다.</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-primary" id="btnAdd">+ 등록</button>
    </div>
  </div>

  <!-- 검색 박스 -->
  <div class="search-box">
    <div class="search-item">
      <span class="search-label">앱 구분</span>
      <select id="filterAppType" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${appTypes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-divider"></div>
    <div class="search-item">
      <span class="search-label">스토어</span>
      <select id="filterStoreType" class="search-select">
        <option value="">전체</option>
        <c:forEach var="code" items="${storeTypes}">
          <option value="${code.code}">${code.codeNm}</option>
        </c:forEach>
      </select>
    </div>
    <div class="search-btns">
      <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
      <button type="button" class="btn btn-outline" id="btnReset">초기화</button>
    </div>
  </div>

  <table class="code-table" id="versionTable">
    <thead>
      <tr>
        <th>구분</th>
        <th>스토어</th>
        <th>버전</th>
        <th>앱 코드</th>
        <th>필수 업데이트</th>
        <th>공개일</th>
        <th>관리</th>
      </tr>
    </thead>
  </table>

</div>
<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<!-- 등록/수정 모달 -->
<div class="modal-overlay" id="versionModal">
  <div class="modal-box modal-sm">

    <div class="modal-header">
      <div>
        <h2 id="modalTitle">앱 버전 등록</h2>
        <div class="modal-sub" id="modalSubTitle">새 버전을 등록합니다.</div>
      </div>
      <button class="modal-close" id="modalClose">✕</button>
    </div>

    <div class="modal-body">
      <input type="hidden" id="fVersionNo"/>

      <table class="form-table">
        <tr>
          <th>구분 <span class="req">*</span></th>
          <td>
            <select id="fAppType" class="form-control">
              <option value="">선택</option>
              <c:forEach var="code" items="${appTypes}">
                <option value="${code.code}">${code.codeNm}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <th>스토어 <span class="req">*</span></th>
          <td>
            <select id="fStoreType" class="form-control">
              <option value="">선택</option>
              <c:forEach var="code" items="${storeTypes}">
                <option value="${code.code}">${code.codeNm}</option>
              </c:forEach>
            </select>
          </td>
        </tr>
        <tr>
          <th>버전 <span class="req">*</span></th>
          <td><input type="text"  id="fVersion"   class="form-control" placeholder="예: 1.0.0 또는 1.0.0a"/></td>
        </tr>
        <tr>
          <th>앱 코드</th>
          <td><input type="text"  id="fAppCode"   class="form-control" placeholder="빌드 번호"/></td>
        </tr>
        <tr>
          <th>공개일 <span class="req">*</span></th>
          <td><input type="date"  id="fReleaseDt" class="form-control"/></td>
        </tr>
        <tr>
          <th>필수 업데이트</th>
          <td>
            <label class="auth-child-item">
              <input type="checkbox" id="fForceUpdate">
              필수 업데이트
            </label>
          </td>
        </tr>
        <tr>
          <th>비고</th>
          <td><input type="text"  id="fNote"      class="form-control" placeholder="비고 (선택)"/></td>
        </tr>
      </table>
    </div>

    <div class="modal-footer">
      <button class="btn btn-outline" id="modalCancel">취소</button>
      <button class="btn btn-indigo"  id="modalSave">저장</button>
    </div>
  </div>
</div>

<script>
(function () {
  var ctx       = '${ctx}';
  var csrfParam = $('meta[name="_csrf_param"]').attr('content');
  var csrfToken = $('meta[name="_csrf"]').attr('content');

  var DT_LANG = {
    processing:   '처리중...',
    search:       '',
    searchPlaceholder: '검색...',
    lengthMenu:   '_MENU_ 건씩 보기',
    info:         '_TOTAL_건 중 _START_ – _END_',
    infoEmpty:    '0건',
    infoFiltered: '(전체 _MAX_건 중 필터링)',
    zeroRecords:  '등록된 버전이 없습니다.',
    paginate:     { first: '«', previous: '‹', next: '›', last: '»' }
  };

  var table = $('#versionTable').DataTable({
    processing: true,
    ajax: {
      url:     ctx + '/system/version/list/json',
      dataSrc: '',
      data: function () {
        return {
          searchAppType:   $('#filterAppType').val(),
          searchStoreType: $('#filterStoreType').val()
        };
      }
    },
    order: [[0, 'asc'], [1, 'asc'], [5, 'desc']],
    language: DT_LANG,
    columns: [
      { data: 'appTypeNm',    defaultContent: '' },
      { data: 'storeTypeNm', defaultContent: '' },
      { data: 'version' },
      { data: 'appCode',     defaultContent: '-' },
      {
        data: 'forceUpdateYn',
        render: function (data) {
          return data === 'Y'
            ? '<span class="badge badge-warning">필수</span>'
            : '<span class="badge badge-default">선택</span>';
        }
      },
      { data: 'releaseDt', defaultContent: '' },
      {
        data: null, orderable: false, searchable: false,
        render: function (data, type, row) {
          return '<button type="button" class="btn btn-sm btn-outline btn-edit"' +
                 ' data-no="' + row.versionNo + '">수정</button> ' +
                 '<button type="button" class="btn btn-sm btn-danger btn-del"' +
                 ' data-no="' + row.versionNo + '">삭제</button>';
        }
      }
    ]
  });

  /* ── 조회 ── */
  $('#btnSearch').on('click', function () { table.ajax.reload(); });
  $('#btnReset').on('click', function () {
    $('#filterAppType, #filterStoreType').val('');
    table.ajax.reload();
  });

  /* ── 등록 버튼 ── */
  $('#btnAdd').on('click', function () {
    resetForm();
    $('#modalTitle').text('앱 버전 등록');
    $('#modalSubTitle').text('새 버전을 등록합니다.');
    openModal();
  });

  /* ── 수정 버튼 ── */
  $(document).on('click', '.btn-edit', function () {
    var no = $(this).data('no');
    $.get(ctx + '/system/version/one', { versionNo: no }, function (data) {
      $('#fVersionNo').val(data.versionNo);
      $('#fAppType').val(data.appType);
      $('#fStoreType').val(data.storeType);
      $('#fVersion').val(data.version);
      $('#fAppCode').val(data.appCode || '');
      $('#fReleaseDt').val(data.releaseDt || '');
      $('#fForceUpdate').prop('checked', data.forceUpdateYn === 'Y');
      $('#fNote').val(data.note || '');
      $('#modalTitle').text('앱 버전 수정');
      $('#modalSubTitle').text('버전 정보를 수정합니다.');
      openModal();
    });
  });

  /* ── 삭제 버튼 ── */
  $(document).on('click', '.btn-del', function () {
    if (!confirm('삭제하시겠습니까?')) return;
    var no = $(this).data('no');
    $.ajax({
      url: ctx + '/system/version/delete',
      method: 'POST',
      data: { versionNo: no, [csrfParam]: csrfToken },
      success: function () { table.ajax.reload(null, false); },
      error:   function () { alert('삭제 중 오류가 발생했습니다.'); }
    });
  });

  /* ── 저장 ── */
  $('#modalSave').on('click', function () {
    var appType   = $('#fAppType').val();
    var storeType = $('#fStoreType').val();
    var version   = $.trim($('#fVersion').val());
    var releaseDt = $('#fReleaseDt').val();

    if (!appType)   { alert('구분을 선택하세요.'); return; }
    if (!storeType) { alert('스토어를 선택하세요.'); return; }
    if (!version)   { alert('버전을 입력하세요.'); return; }
    if (!releaseDt) { alert('공개일을 선택하세요.'); return; }

    var data = {
      versionNo:     $('#fVersionNo').val() || null,
      appType:        appType,
      storeType:      storeType,
      version:        version,
      appCode:        $.trim($('#fAppCode').val()),
      releaseDt:      releaseDt,
      forceUpdateYn:  $('#fForceUpdate').is(':checked') ? 'Y' : 'N',
      useYn:          'Y',
      note:           $.trim($('#fNote').val()),
      [csrfParam]:    csrfToken
    };

    $.ajax({
      url:    ctx + '/system/version/save',
      method: 'POST',
      data:   data,
      success: function () {
        closeModal();
        table.ajax.reload(null, false);
      },
      error: function () { alert('저장 중 오류가 발생했습니다.'); }
    });
  });

  /* ── 모달 제어 ── */
  function openModal()  { $('#versionModal').addClass('open'); }
  function closeModal() { $('#versionModal').removeClass('open'); }
  function resetForm()  {
    $('#fVersionNo, #fVersion, #fAppCode, #fNote').val('');
    $('#fAppType, #fStoreType').val('');
    $('#fForceUpdate').prop('checked', false);
    $('#fReleaseDt').val(new Date().toISOString().slice(0, 10));
  }

  $('#modalClose, #modalCancel').on('click', closeModal);
  $('#versionModal').on('click', function (e) {
    if ($(e.target).is('#versionModal')) closeModal();
  });

  /* 등록 시 기본 공개일 = 오늘 */
  $('#fReleaseDt').val(new Date().toISOString().slice(0, 10));

})();
</script>

</body>
</html>
