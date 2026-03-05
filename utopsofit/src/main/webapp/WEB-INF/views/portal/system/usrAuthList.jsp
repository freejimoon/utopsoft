<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<title>관리자 권한 관리</title>
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
      <h1>관리자 권한 관리</h1>
      <p class="page-desc">관리자별로 접근 가능한 메뉴를 설정합니다.</p>
    </div>
  </div>

  <table class="code-table" id="usrTable">
    <thead>
      <tr>
        <th>No</th>
        <th>관리자 ID</th>
        <th>관리자명</th>
        <th>그룹(부서)</th>
        <th>사용여부</th>
        <th>권한 설정</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="usr" items="${usrList}" varStatus="vs">
      <tr>
        <td>${vs.count}</td>
        <td>${usr.usrId}</td>
        <td>${usr.usrNm}</td>
        <td>${not empty usr.deptNm ? usr.deptNm : '-'}</td>
        <td>
          <c:choose>
            <c:when test="${usr.useYn eq 'Y'}"><span class="badge badge-active">사용</span></c:when>
            <c:otherwise><span class="badge badge-inactive">미사용</span></c:otherwise>
          </c:choose>
        </td>
        <td>
          <button type="button" class="btn btn-sm btn-outline btn-auth-open"
                  data-usr-id="${usr.usrId}"
                  data-usr-nm="${usr.usrNm}">
            ✓ 권한 관리
          </button>
        </td>
      </tr>
      </c:forEach>
    </tbody>
  </table>

</div>
<%@ include file="/WEB-INF/views/cmm/layout/footer.jsp" %>

<!-- 권한 설정 모달 -->
<div class="modal-overlay" id="authModal">
  <div class="modal-box modal-lg">

    <div class="modal-header">
      <div>
        <h2>권한 설정</h2>
        <div class="modal-sub">관리자 | <span id="modalUsrNm"></span></div>
      </div>
      <button class="modal-close" id="modalClose">✕</button>
    </div>

    <div class="modal-body">
      <div class="auth-section-label">✓ 접속 허용 메뉴</div>
      <label class="auth-check-row all-row">
        <input type="checkbox" id="chkAll"> 전체 메뉴 접근 허용
      </label>
      <div id="menuTree"></div>
    </div>

    <div class="modal-footer">
      <button class="btn btn-outline" id="modalCancel">취소</button>
      <button class="btn btn-indigo"  id="modalSave">변경사항 저장</button>
    </div>
  </div>
</div>

<script>
(function () {
  var ctx       = '${ctx}';
  var csrfParam = $('meta[name="_csrf_param"]').attr('content');
  var csrfToken = $('meta[name="_csrf"]').attr('content');
  var currentUsrId = '';

  var DT_LANG = {
    processing:   '처리중...',
    search:       '검색:',
    lengthMenu:   '_MENU_ 건씩 보기',
    info:         '전체 _TOTAL_건 중 _START_ - _END_',
    infoEmpty:    '데이터 없음',
    infoFiltered: '(전체 _MAX_건 중 필터링)',
    zeroRecords:  '등록된 관리자가 없습니다.',
    paginate:     { first:'처음', previous:'이전', next:'다음', last:'마지막' }
  };

  /* ── DataTable 초기화 ── */
  $('#usrTable').DataTable({
    order: [[0, 'asc']],
    columnDefs: [{ orderable: false, targets: 5 }],
    language: DT_LANG
  });

  /* ── 권한 관리 버튼 → 모달 ── */
  $(document).on('click', '.btn-auth-open', function () {
    currentUsrId = $(this).data('usr-id');
    $('#modalUsrNm').text($(this).data('usr-nm'));
    loadMenuTree(currentUsrId);
  });

  function loadMenuTree(usrId) {
    $.ajax({
      url: ctx + '/system/auth/menus',
      data: { usrId: usrId },
      success: function (data) {
        renderMenuTree(data);
        syncAllCheck();
        $('#authModal').addClass('open');
      },
      error: function () { alert('메뉴 정보를 불러오지 못했습니다.'); }
    });
  }

  function renderMenuTree(tree) {
    var html = '';
    tree.forEach(function (menu) {
      var checked = menu.accessYn === 'Y' ? 'checked' : '';
      if (menu.menuType === 'LINK') {
        html += '<label class="auth-check-row">' +
                  '<input type="checkbox" class="chk-menu" data-menu-no="' + menu.menuNo + '" ' + checked + '>' +
                  menu.menuNm +
                '</label>';
      } else {
        var allChild = menu.children && menu.children.length > 0 &&
                       menu.children.every(function (c) { return c.accessYn === 'Y'; });
        html += '<div class="auth-group-card">' +
                  '<label class="auth-group-header">' +
                    '<input type="checkbox" class="chk-group" data-group-idx="' + menu.menuNo + '" ' + (allChild ? 'checked' : '') + '>' +
                    menu.menuNm +
                  '</label>';
        if (menu.children && menu.children.length > 0) {
          html += '<div class="auth-children">';
          menu.children.forEach(function (child) {
            var cc = child.accessYn === 'Y' ? 'checked' : '';
            html += '<label class="auth-child-item">' +
                      '<input type="checkbox" class="chk-menu chk-child"' +
                             ' data-menu-no="' + child.menuNo + '"' +
                             ' data-parent="'  + menu.menuNo  + '" ' + cc + '>' +
                      child.menuNm +
                    '</label>';
          });
          html += '</div>';
        }
        html += '</div>';
      }
    });
    $('#menuTree').html(html);
  }

  $(document).on('change', '.chk-group', function () {
    var gIdx    = $(this).data('group-idx');
    var checked = $(this).is(':checked');
    $('.chk-child[data-parent="' + gIdx + '"]').prop('checked', checked);
    syncAllCheck();
  });

  $(document).on('change', '.chk-child', function () {
    var pIdx       = $(this).data('parent');
    var allChecked = $('.chk-child[data-parent="' + pIdx + '"]').toArray()
                       .every(function (el) { return $(el).is(':checked'); });
    $('.chk-group[data-group-idx="' + pIdx + '"]').prop('checked', allChecked);
    syncAllCheck();
  });

  $(document).on('change', '.chk-menu', function () { syncAllCheck(); });

  $('#chkAll').on('change', function () {
    var checked = $(this).is(':checked');
    $('.chk-menu, .chk-group').prop('checked', checked);
  });

  function syncAllCheck() {
    var total   = $('.chk-menu').length;
    var checked = $('.chk-menu:checked').length;
    $('#chkAll').prop('checked', total > 0 && total === checked);
  }

  /* ── 저장 ── */
  $('#modalSave').on('click', function () {
    var menuNos = [];
    $('.chk-menu:checked').each(function () { menuNos.push($(this).data('menu-no')); });
    $.ajax({
      url: ctx + '/system/auth/save',
      method: 'POST',
      data: { usrId: currentUsrId, menuNos: menuNos, [csrfParam]: csrfToken },
      traditional: true,
      success: function () { closeModal(); alert('저장되었습니다.'); },
      error:   function () { alert('저장 중 오류가 발생했습니다.'); }
    });
  });

  /* ── 모달 닫기 ── */
  function closeModal() {
    $('#authModal').removeClass('open');
    $('#menuTree').empty();
    currentUsrId = '';
  }
  $('#modalClose, #modalCancel').on('click', closeModal);
  $('#authModal').on('click', function (e) {
    if ($(e.target).is('#authModal')) closeModal();
  });

})();
</script>
</body>
</html>
