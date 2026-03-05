-- =====================================================
-- 메뉴 & 사용자별 메뉴 권한 DDL (MySQL 8.x)
-- 스키마: utopsoft
--
-- [테이블 구조]
--   menu          : 메뉴 마스터 (계층형, 자기참조)
--   usr_menu_auth : 사용자별 메뉴 접근 권한
--
-- [실행 순서]
--   1. menu
--   2. usr_menu_auth  (FK → menu, usr)
-- =====================================================

USE `utopsoft`;


-- =====================================================
-- 1. 메뉴 마스터 (menu)
-- =====================================================
DROP TABLE IF EXISTS `usr_menu_auth`;
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
    `menu_no`        BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT        COMMENT '메뉴번호 (PK)',
    `parent_menu_no` BIGINT UNSIGNED  DEFAULT NULL                   COMMENT '상위 메뉴번호 (NULL = 최상위 메뉴)',
    `menu_nm`        VARCHAR(100)     NOT NULL                       COMMENT '메뉴명',
    `menu_url`       VARCHAR(300)     DEFAULT NULL                   COMMENT 'URL (그룹메뉴는 NULL)',
    `menu_icon`      VARCHAR(1000)    DEFAULT NULL                   COMMENT 'SVG path 데이터',
    `menu_type`      VARCHAR(10)      NOT NULL DEFAULT 'LINK'        COMMENT '메뉴유형 (GROUP:그룹메뉴 / LINK:링크메뉴)',
    `sort_ord`       INT              NOT NULL DEFAULT 0             COMMENT '정렬순서',
    `use_yn`         CHAR(1)          NOT NULL DEFAULT 'Y'           COMMENT '사용여부 (Y/N)',

    `created_at`     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP                            COMMENT '생성일시',
    `created_by`     VARCHAR(50)      DEFAULT NULL                                                  COMMENT '생성자',
    `updated_at`     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`     VARCHAR(50)      DEFAULT NULL                                                  COMMENT '수정자',

    PRIMARY KEY (`menu_no`),
    KEY `idx_menu_parent_menu_no` (`parent_menu_no`),
    KEY `idx_menu_type`           (`menu_type`),
    KEY `idx_menu_sort_ord`       (`sort_ord`),
    KEY `idx_menu_use_yn`         (`use_yn`),
    CONSTRAINT `fk_menu_parent` FOREIGN KEY (`parent_menu_no`) REFERENCES `menu` (`menu_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='메뉴 마스터';


-- =====================================================
-- 2. 사용자별 메뉴 접근 권한 (usr_menu_auth)
-- =====================================================
CREATE TABLE `usr_menu_auth` (
    `usr_id`     VARCHAR(50)      NOT NULL COMMENT '관리자 ID (FK → usr)',
    `menu_no`    BIGINT UNSIGNED  NOT NULL COMMENT '메뉴번호 (FK → menu)',
    `access_yn`  CHAR(1)          NOT NULL DEFAULT 'N' COMMENT '접근 허용 여부 (Y/N)',

    `created_at` DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP                            COMMENT '생성일시',
    `created_by` VARCHAR(50)      DEFAULT NULL                                                  COMMENT '생성자',
    `updated_at` DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by` VARCHAR(50)      DEFAULT NULL                                                  COMMENT '수정자',

    PRIMARY KEY (`usr_id`, `menu_no`),
    KEY `idx_usr_menu_auth_usr_id`  (`usr_id`),
    KEY `idx_usr_menu_auth_menu_no` (`menu_no`),
    CONSTRAINT `fk_usr_menu_auth_usr`  FOREIGN KEY (`usr_id`)  REFERENCES `usr`  (`usr_id`)  ON DELETE CASCADE,
    CONSTRAINT `fk_usr_menu_auth_menu` FOREIGN KEY (`menu_no`) REFERENCES `menu` (`menu_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자별 메뉴 접근 권한';


-- =====================================================
-- 샘플 데이터 — 현재 sidebar 메뉴 기준
-- =====================================================

-- 1depth: 최상위 메뉴 (GROUP 또는 단독 LINK)
INSERT INTO `menu` (`menu_no`, `parent_menu_no`, `menu_nm`, `menu_url`, `menu_type`, `sort_ord`, `use_yn`, `created_by`) VALUES
(1, NULL, '대시보드(홈)',  '/',    'LINK',  1, 'Y', 'admin'),
(2, NULL, '공통코드 관리', NULL,  'GROUP', 2, 'Y', 'admin'),
(3, NULL, '사용자 관리',   NULL,  'GROUP', 3, 'Y', 'admin'),
(4, NULL, '시스템 설정',   NULL,  'GROUP', 4, 'Y', 'admin'),
(5, NULL, '게시판 관리',   NULL,  'GROUP', 5, 'Y', 'admin');

-- 2depth: 공통코드 관리 하위
INSERT INTO `menu` (`menu_no`, `parent_menu_no`, `menu_nm`, `menu_url`, `menu_type`, `sort_ord`, `use_yn`, `created_by`) VALUES
(10, 2, '코드 그룹 관리', '/code/grp/list', 'LINK', 1, 'Y', 'admin');

-- 2depth: 사용자 관리 하위
INSERT INTO `menu` (`menu_no`, `parent_menu_no`, `menu_nm`, `menu_url`, `menu_type`, `sort_ord`, `use_yn`, `created_by`) VALUES
(20, 3, '사용자 목록', '/user/list', 'LINK', 1, 'Y', 'admin'),
(21, 3, '사용자 등록', '/user/form', 'LINK', 2, 'Y', 'admin');

-- 2depth: 시스템 설정 하위
INSERT INTO `menu` (`menu_no`, `parent_menu_no`, `menu_nm`, `menu_url`, `menu_type`, `sort_ord`, `use_yn`, `created_by`) VALUES
(30, 4, '관리자 권한 관리', '/system/auth/list',    'LINK', 1, 'Y', 'admin'),
(31, 4, '앱 버전 관리',     '/system/version/list', 'LINK', 2, 'Y', 'admin');

-- 2depth: 게시판 관리 하위
INSERT INTO `menu` (`menu_no`, `parent_menu_no`, `menu_nm`, `menu_url`, `menu_type`, `sort_ord`, `use_yn`, `created_by`) VALUES
(40, 5, '문의 관리', '/board/inquiry/list', 'LINK', 1, 'Y', 'admin'),
(41, 5, 'FAQ 관리',  '/board/faq/list',     'LINK', 2, 'Y', 'admin'),
(42, 5, '약관 관리', '/board/terms/list',   'LINK', 3, 'Y', 'admin');
