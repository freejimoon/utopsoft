<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <footer class="site-footer">
      <div class="footer-inner">
        <p>주소: 서울특별시 강남구 남부순환로 2621 12층 1232호 &nbsp;|&nbsp; 전화번호: 02-2135-3096</p>
        <p class="footer-copy">&copy; UTOPSOFT. All rights reserved.</p>
      </div>
    </footer>

  </div><!-- /.layout-main -->
</div><!-- /.layout-wrapper -->

<script>
(function () {
  'use strict';

  var STORAGE_KEY = 'utop_sidebar_collapsed';
  var sidebar     = document.getElementById('sidebar');
  var layoutMain  = document.getElementById('layoutMain');
  var toggleBtn   = document.getElementById('sidebarToggle');

  /* ── 사이드바 상태 초기화 (페이지 로드 시 깜빡임 방지) ── */
  if (localStorage.getItem(STORAGE_KEY) === '1') {
    sidebar.classList.add('collapsed');
    layoutMain.classList.add('collapsed');
  }

  /* ── 토글 ── */
  function toggle() {
    var isCollapsed = sidebar.classList.toggle('collapsed');
    layoutMain.classList.toggle('collapsed', isCollapsed);
    localStorage.setItem(STORAGE_KEY, isCollapsed ? '1' : '0');
  }

  if (toggleBtn) toggleBtn.addEventListener('click', toggle);

  /* ── 그룹 open 상태 저장/복원 (localStorage) ── */
  var GROUPS_KEY = 'utop_groups_open';

  function saveGroupStates() {
    var states = {};
    document.querySelectorAll('.nav-group').forEach(function (g, i) {
      states[i] = g.classList.contains('open') ? 1 : 0;
    });
    localStorage.setItem(GROUPS_KEY, JSON.stringify(states));
  }

  function restoreGroupStates() {
    try {
      var saved = JSON.parse(localStorage.getItem(GROUPS_KEY) || 'null');
      if (!saved) return;
      /* JSTL이 이미 열어둔 그룹은 유지하고, 저장된 상태에서 열려있던 그룹도 추가로 열기 */
      document.querySelectorAll('.nav-group').forEach(function (g, i) {
        if (saved[i] === 1) g.classList.add('open');
      });
    } catch (e) {}
  }

  /* 페이지 로드 시 그룹 상태 복원 (JSTL 기본 open 이후 추가 적용) */
  restoreGroupStates();

  /* ── 서브메뉴 아코디언 ── */
  document.querySelectorAll('.nav-group-header').forEach(function (header) {
    header.addEventListener('click', function () {
      this.closest('.nav-group').classList.toggle('open');
      saveGroupStates(); /* 헤더 클릭 시 현재 상태 저장 */
    });
  });

  /* ── 사이드바 활성 메뉴 관리 (localStorage) ── */
  var NAV_KEY = 'utop_active_nav';

  function applyActiveNav(key) {
    document.querySelectorAll('.nav-sub-link.active').forEach(function (el) {
      el.classList.remove('active');
    });
    if (!key) return;
    var target = document.querySelector('[data-nav-key="' + key + '"]');
    if (!target) return;
    target.classList.add('active');
    /* 부모 그룹 자동 열기 */
    var group = target.closest('.nav-group');
    if (group) group.classList.add('open');
  }

  /* 페이지 로드 시 활성 메뉴 복원 */
  applyActiveNav(localStorage.getItem(NAV_KEY));

  /* 서브링크 클릭 시: 활성키 저장 → 그룹 상태 저장 → 이동 */
  document.querySelectorAll('[data-nav-key]').forEach(function (link) {
    link.addEventListener('click', function () {
      var key = this.getAttribute('data-nav-key');
      localStorage.setItem(NAV_KEY, key);
      applyActiveNav(key);    /* 부모 그룹 open 적용 후 */
      saveGroupStates();      /* 현재 열린 그룹 상태 저장 (페이지 이동 전) */
    });
  });

  /* ── CSRF 자동 주입 ── */
  var csrfParamMeta = document.querySelector('meta[name="_csrf_param"]');
  var csrfMeta      = document.querySelector('meta[name="_csrf"]');
  if (csrfParamMeta && csrfMeta) {
    var csrfParam = csrfParamMeta.getAttribute('content');
    var csrfToken = csrfMeta.getAttribute('content');
    document.querySelectorAll('form[method="post"]').forEach(function (form) {
      var input   = document.createElement('input');
      input.type  = 'hidden';
      input.name  = csrfParam;
      input.value = csrfToken;
      form.appendChild(input);
    });
  }
})();
</script>
