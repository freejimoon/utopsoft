-- =====================================================
-- 관리자 역할 공통코드 추가 (usr.role_cd 매핑)
-- 이미 실행했다면 skip
-- =====================================================
INSERT IGNORE INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`)
VALUES ('USR_ROLE', '관리자 역할', 'usr.role_cd — 포털 관리자 역할 구분', 'Y', 40);

INSERT IGNORE INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('USR_ROLE', 'SUPER_ADMIN', '최고 관리자',   '모든 기능 접근 가능', 'Y', 1),
('USR_ROLE', 'ADMIN',       '관리자',        '일반 관리 권한',       'Y', 2),
('USR_ROLE', 'MANAGER',     '매니저',        '제한적 관리 권한',     'Y', 3),
('USR_ROLE', 'TEACHER',     '교사',          '교사 역할',            'Y', 4),
('USR_ROLE', 'USER',        '일반 사용자',   '포털 로그인 전용',     'Y', 5);


