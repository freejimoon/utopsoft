-- =====================================================
-- 관리자 역할 공통코드 (usr.role_cd 매핑)
-- grp_cd 표준: USR_ROLE_CD (usr_ddl.sql 과 통일)
-- 이미 실행했다면 ON DUPLICATE KEY UPDATE 로 안전하게 처리됨
-- =====================================================
INSERT INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES ('USR_ROLE_CD', '관리자 역할', 'usr.role_cd — 포털 관리자 역할 구분', 'Y', 40, 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`), `grp_desc` = VALUES(`grp_desc`);

INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('USR_ROLE_CD', 'SUPER_ADMIN', '최고 관리자',  '모든 기능 접근 가능',    'Y', 1, 'system'),
('USR_ROLE_CD', 'ADMIN',       '관리자',       '시스템 전체 관리 권한',  'Y', 2, 'system'),
('USR_ROLE_CD', 'MANAGER',     '매니저',       '제한적 관리 권한',       'Y', 3, 'system'),
('USR_ROLE_CD', 'TEACHER',     '교사',         '교사 역할',              'Y', 4, 'system'),
('USR_ROLE_CD', 'USER',        '일반사용자',   '포털 로그인 전용',       'Y', 5, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`), `code_desc` = VALUES(`code_desc`);
