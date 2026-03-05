<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <footer class="site-footer">
      <div class="footer-inner">
        <p>주소: 서울특별시 강남구 남부순환로 2621 12층 1232호 &nbsp;|&nbsp; 전화번호: 02-2135-3096</p>
        <p class="footer-copy">&copy; UTOPSOFT. All rights reserved.</p>
      </div>
    </footer>

  </div><!-- /.layout-main -->
</div><!-- /.layout-wrapper -->

<script src="${ctx}/js/jquery-3.7.0.min.js"></script>
<script src="${ctx}/js/jquery.dataTables.min.js"></script>
<script>
$(function () {

  var STORAGE_KEY = 'utop_sidebar_collapsed';
  var $sidebar    = $('#sidebar');
  var $main       = $('#layoutMain');

  /* ── 사이드바 상태 초기화 ── */
  if (localStorage.getItem(STORAGE_KEY) === '1') {
    $sidebar.addClass('collapsed');
    $main.addClass('collapsed');
  }

  /* ── 토글 ── */
  $('#sidebarToggle').on('click', function () {
    var isCollapsed = $sidebar.toggleClass('collapsed').hasClass('collapsed');
    $main.toggleClass('collapsed', isCollapsed);
    localStorage.setItem(STORAGE_KEY, isCollapsed ? '1' : '0');
  });

  /* ── 그룹 open 상태 저장/복원 ── */
  var GROUPS_KEY = 'utop_groups_open';

  function saveGroupStates() {
    var states = {};
    $('.nav-group').each(function (i) {
      states[i] = $(this).hasClass('open') ? 1 : 0;
    });
    localStorage.setItem(GROUPS_KEY, JSON.stringify(states));
  }

  function restoreGroupStates() {
    try {
      var saved = JSON.parse(localStorage.getItem(GROUPS_KEY) || 'null');
      if (!saved) return;
      $('.nav-group').each(function (i) {
        if (saved[i] === 1) $(this).addClass('open');
      });
    } catch (e) {}
  }

  restoreGroupStates();

  /* ── 서브메뉴 아코디언 ── */
  $(document).on('click', '.nav-group-header', function () {
    $(this).closest('.nav-group').toggleClass('open');
    saveGroupStates();
  });

  /* ── 사이드바 활성 메뉴 관리 ── */
  var NAV_KEY = 'utop_active_nav';

  function applyActiveNav(key) {
    $('.nav-sub-link.active').removeClass('active');
    if (!key) return;
    var $target = $('[data-nav-key="' + key + '"]');
    if (!$target.length) return;
    $target.addClass('active');
    $target.closest('.nav-group').addClass('open');
  }

  applyActiveNav(localStorage.getItem(NAV_KEY));

  $(document).on('click', '[data-nav-key]', function () {
    var key = $(this).attr('data-nav-key');
    localStorage.setItem(NAV_KEY, key);
    applyActiveNav(key);
    saveGroupStates();
  });

  /* ── CSRF 자동 주입 (form[method=post]) ── */
  var csrfParam = $('meta[name="_csrf_param"]').attr('content');
  var csrfToken = $('meta[name="_csrf"]').attr('content');
  if (csrfParam && csrfToken) {
    $('form[method="post"]').append(
      $('<input>').attr({ type: 'hidden', name: csrfParam, value: csrfToken })
    );
  }

});
</script>
