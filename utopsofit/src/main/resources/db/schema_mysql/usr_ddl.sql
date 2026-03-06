-- =====================================================
-- 사용자 DDL (MySQL 8.x)
-- 스키마: utopsoft
-- =====================================================

USE `utopsoft`;

-- -----------------------------------------------------
-- 사용자 (tb_usr)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tb_usr`;
CREATE TABLE `tb_usr` (
    `usr_id`        VARCHAR(50)   NOT NULL                COMMENT '사용자 ID (PK)',
    `usr_nm`        VARCHAR(100)  NOT NULL                COMMENT '사용자명',
    `usr_pw`        VARCHAR(255)  NOT NULL                COMMENT '비밀번호 (암호화)',
    `email`         VARCHAR(200)  DEFAULT NULL            COMMENT '이메일',
    `phone`         VARCHAR(20)   DEFAULT NULL            COMMENT '전화번호',
    `dept_nm`       VARCHAR(100)  DEFAULT NULL            COMMENT '부서명',
    `role_cd`       VARCHAR(50)   NOT NULL DEFAULT 'USER' COMMENT '권한코드 (ADMIN/USER 등)',
    `use_yn`        CHAR(1)       NOT NULL DEFAULT 'Y'    COMMENT '사용여부 (Y/N)',
    `pwd_chg_dt`    DATE          DEFAULT NULL            COMMENT '비밀번호 변경일',
    `last_login_dt` DATETIME      DEFAULT NULL            COMMENT '최종 로그인 일시',
    `login_fail_cnt` TINYINT      NOT NULL DEFAULT 0      COMMENT '로그인 실패 횟수',
    `lock_yn`       CHAR(1)       NOT NULL DEFAULT 'N'    COMMENT '계정 잠금 여부 (Y/N)',
    `created_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    `created_by`    VARCHAR(50)   DEFAULT NULL            COMMENT '생성자',
    `updated_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`    VARCHAR(50)   DEFAULT NULL            COMMENT '수정자',
    PRIMARY KEY (`usr_id`),
    UNIQUE KEY `uq_usr_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자';

-- -----------------------------------------------------
-- 샘플 데이터
-- -----------------------------------------------------
-- 기본 비밀번호: 1234  (BCrypt 해시)
INSERT INTO `tb_usr` (`usr_id`, `usr_nm`, `usr_pw`, `email`, `phone`, `dept_nm`, `role_cd`, `use_yn`, `created_by`) VALUES
('admin',  '관리자', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'admin@utopsoft.com',  '010-1111-0001', '시스템팀', 'ADMIN', 'Y', 'system'),
('user01', '홍길동', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'hong@utopsoft.com',   '010-1111-0002', '개발팀',   'USER',  'Y', 'admin'),
('user02', '김철수', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'kim@utopsoft.com',    '010-1111-0003', '개발팀',   'USER',  'Y', 'admin'),
('user03', '이영희', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'lee@utopsoft.com',    '010-1111-0004', '기획팀',   'USER',  'Y', 'admin'),
('user04', '박민준', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'park@utopsoft.com',   '010-1111-0005', '디자인팀', 'USER',  'Y', 'admin'),
('user05', '최지수', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'choi@utopsoft.com',   '010-1111-0006', '운영팀',   'USER',  'N', 'admin');

-- =====================================================
-- 공통코드 INSERT (USR_ROLE_CD)
-- admin_role_ddl.sql 과 grp_cd 통일: USR_ROLE_CD
-- =====================================================
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES ('USR_ROLE_CD', '관리자 역할', 'tb_usr.role_cd — 포털 관리자 역할 구분', 'Y', 40, 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`), `grp_desc` = VALUES(`grp_desc`);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('USR_ROLE_CD', 'SUPER_ADMIN', '최고 관리자',  '모든 기능 접근 가능',    'Y', 1, 'system'),
('USR_ROLE_CD', 'ADMIN',       '관리자',       '시스템 전체 관리 권한',  'Y', 2, 'system'),
('USR_ROLE_CD', 'MANAGER',     '매니저',       '제한적 관리 권한',       'Y', 3, 'system'),
('USR_ROLE_CD', 'TEACHER',     '교사',         '교사 역할',              'Y', 4, 'system'),
('USR_ROLE_CD', 'USER',        '일반사용자',   '포털 로그인 전용',       'Y', 5, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`), `code_desc` = VALUES(`code_desc`);