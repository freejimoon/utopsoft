-- =====================================================
-- 약관 DDL (MySQL 8.x)
-- =====================================================

USE `utopsoft`;

DROP TABLE IF EXISTS `tb_terms`;
CREATE TABLE `tb_terms` (
    `terms_no`      BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT        COMMENT '약관번호 (PK)',
    `app_type_cd`   VARCHAR(20)      NOT NULL DEFAULT 'MAIN'        COMMENT '앱 구분 (공통코드 TERMS_APP_TYPE)',
    `terms_type_cd` VARCHAR(20)      NOT NULL                       COMMENT '약관 유형 (공통코드 TERMS_TYPE)',
    `required_yn`   CHAR(1)          NOT NULL DEFAULT 'Y'           COMMENT '필수 동의 여부 (Y/N)',
    `version`       INT UNSIGNED     NOT NULL DEFAULT 1             COMMENT '버전',
    `content`       TEXT             NOT NULL                       COMMENT '약관 내용',
    `use_yn`        CHAR(1)          NOT NULL DEFAULT 'Y'           COMMENT '사용 여부 (Y/N)',
    `created_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP                          COMMENT '생성일시',
    `created_by`    VARCHAR(50)      DEFAULT NULL                   COMMENT '등록자',
    `updated_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`    VARCHAR(50)      DEFAULT NULL                   COMMENT '수정자',

    PRIMARY KEY (`terms_no`),
    KEY `idx_terms_app_type_cd`   (`app_type_cd`),
    KEY `idx_terms_terms_type_cd` (`terms_type_cd`),
    KEY `idx_terms_use_yn`        (`use_yn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='약관';

-- =====================================================
-- 공통코드 INSERT
-- =====================================================
-- 앱 구분 (TERMS_APP_TYPE)
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `created_by`)
VALUES ('TERMS_APP_TYPE_CD', '약관 앱 구분', '약관이 적용되는 앱 구분', 'Y', 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('TERMS_APP_TYPE_CD', 'MAIN', '메인 앱', 'Y', 1, 'system'),
('TERMS_APP_TYPE_CD', 'CP',   'CP',      'Y', 2, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);

-- 약관 유형 (TERMS_TYPE)
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `created_by`)
VALUES ('TERMS_TYPE_CD', '약관 유형', '약관 종류 구분', 'Y', 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('TERMS_TYPE_CD', 'USE',       '이용약관',               'Y', 1, 'system'),
('TERMS_TYPE_CD', 'PRIVACY',   '개인정보 수집·이용동의', 'Y', 2, 'system'),
('TERMS_TYPE_CD', 'MARKETING', '마케팅 수신동의',        'Y', 3, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);

-- =====================================================
-- 샘플 데이터
-- =====================================================
INSERT INTO `tb_terms` (`app_type_cd`, `terms_type_cd`, `required_yn`, `version`, `content`, `created_by`)
VALUES
('MAIN', 'USE',       'Y', 8, '제1조(목적)\n이 약관은 서비스 이용에 관한 조건 및 절차를 규정합니다.', 'admin'),
('MAIN', 'PRIVACY',   'Y', 7, '개인정보 수집 및 이용에 관한 동의입니다.\n수집항목: 이메일, 닉네임 등', 'admin'),
('MAIN', 'MARKETING', 'N', 5, '마케팅 정보 수신 동의 약관입니다.', 'admin'),
('CP',   'USE',       'Y', 2, 'CP 서비스 이용약관입니다.', 'admin'),
('CP',   'PRIVACY',   'Y', 1, 'CP 개인정보 수집·이용 동의입니다.', 'admin');
