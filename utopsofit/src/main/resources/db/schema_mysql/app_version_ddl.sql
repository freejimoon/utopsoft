-- =====================================================
-- 앱 버전 관리 DDL (MySQL 8.x)
-- 스키마: utopsoft
--
-- [테이블]
--   tb_app_version : 앱 버전 마스터
--
-- [앱 구분]
--   ANDROID : 안드로이드 앱
--   IOS     : iOS 앱
--
-- [스토어 구분]
--   GOOGLE_PLAY : 구글 플레이 스토어
--   APP_STORE   : 애플 앱 스토어
--   ONE_STORE   : 원스토어
-- =====================================================

USE `utopsoft`;


-- =====================================================
-- 앱 버전 (tb_app_version)
-- =====================================================
DROP TABLE IF EXISTS `tb_app_version`;
CREATE TABLE `tb_app_version` (
    `version_no`       BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT         COMMENT '버전번호 (PK)',

    -- 앱 구분 / 스토어
    `app_cd`         VARCHAR(20)      NOT NULL                        COMMENT '앱 구분 (ANDROID:안드로이드 / IOS:iOS)',
    `store_cd`       VARCHAR(20)      NOT NULL                        COMMENT '스토어 (GOOGLE_PLAY:구글플레이 / APP_STORE:앱스토어 / ONE_STORE:원스토어)',

    -- 버전 정보
    `version`          VARCHAR(30)      NOT NULL                        COMMENT '버전명 (예: 1.0.0 / 1.0.0a)',
    `app_code`         VARCHAR(100)     DEFAULT NULL                    COMMENT '앱 코드 (스토어 내부 빌드번호)',

    -- 공개 / 강제 업데이트
    `release_dt`       DATE             NOT NULL                        COMMENT '공개일',
    `force_update_yn`  CHAR(1)          NOT NULL DEFAULT 'N'            COMMENT '필수 업데이트 여부 (Y:필수 / N:선택)',

    -- 상태
    `use_yn`           CHAR(1)          NOT NULL DEFAULT 'Y'            COMMENT '사용여부 (Y/N)',

    -- 비고
    `note`             VARCHAR(500)     DEFAULT NULL                    COMMENT '비고',

    -- 감사 컬럼
    `created_at`       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP                             COMMENT '생성일시',
    `created_by`       VARCHAR(50)      DEFAULT NULL                                                   COMMENT '생성자',
    `updated_at`       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`       VARCHAR(50)      DEFAULT NULL                                                   COMMENT '수정자',

    PRIMARY KEY (`version_no`),
    UNIQUE KEY `uq_app_version`              (`app_cd`, `store_cd`, `version`),
    KEY `idx_app_version_app_cd`           (`app_cd`),
    KEY `idx_app_version_store_cd`         (`store_cd`),
    KEY `idx_app_version_release_dt`         (`release_dt`),
    KEY `idx_app_version_force_update_yn`    (`force_update_yn`),
    KEY `idx_app_version_use_yn`             (`use_yn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='앱 버전 관리';



-- =====================================================
-- 공통코드 추가 (common_code_ddl.sql에도 추가 권장)
-- sort_ord 32번부터 이어서 추가
-- =====================================================

INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`) VALUES
('APP_TYPE_CD',   '앱 구분',   'tb_app_version.app_cd   — 안드로이드/iOS 구분',       'Y', 32),
('STORE_TYPE_CD', '스토어 구분', 'tb_app_version.store_cd — 앱 배포 스토어 구분',     'Y', 33);

-- APP_TYPE
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('APP_TYPE_CD', 'ANDROID', '안드로이드', '안드로이드 앱 (Google Play / ONE Store)', 'Y', 1),
('APP_TYPE_CD', 'IOS',     'iOS',        'Apple App Store 앱',                       'Y', 2);

-- STORE_TYPE
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('STORE_TYPE_CD', 'GOOGLE_PLAY', '구글 플레이', 'Google Play Store',   'Y', 1),
('STORE_TYPE_CD', 'APP_STORE',   '앱 스토어',   'Apple App Store',      'Y', 2),
('STORE_TYPE_CD', 'ONE_STORE',   '원스토어',    '원스토어 (국내)',       'Y', 3);


-- =====================================================
-- 샘플 데이터
-- =====================================================

INSERT INTO `tb_app_version`
    (`app_cd`, `store_cd`, `version`, `app_code`, `release_dt`, `force_update_yn`, `use_yn`, `note`, `created_by`)
VALUES
-- 안드로이드 - 구글 플레이
('ANDROID', 'GOOGLE_PLAY', '1.0.0',  '100', '2025-01-01', 'N', 'Y', '최초 출시',           'admin'),
('ANDROID', 'GOOGLE_PLAY', '1.0.1',  '101', '2025-02-01', 'N', 'Y', '버그 수정',           'admin'),
('ANDROID', 'GOOGLE_PLAY', '1.1.0',  '110', '2025-05-01', 'Y', 'Y', '보안 패치 필수 업데이트', 'admin'),

-- 안드로이드 - 원스토어
('ANDROID', 'ONE_STORE',   '1.0.0',  '100', '2025-01-01', 'N', 'Y', '원스토어 최초 출시',  'admin'),
('ANDROID', 'ONE_STORE',   '1.1.0',  '110', '2025-05-01', 'Y', 'Y', '보안 패치 필수 업데이트', 'admin'),

-- iOS - 앱 스토어
('IOS',     'APP_STORE',   '1.0.0',  '100', '2025-01-01', 'N', 'Y', '최초 출시',           'admin'),
('IOS',     'APP_STORE',   '1.0.1',  '101', '2025-02-10', 'N', 'Y', '버그 수정',           'admin'),
('IOS',     'APP_STORE',   '1.1.0',  '110', '2025-05-10', 'Y', 'Y', '보안 패치 필수 업데이트', 'admin');
