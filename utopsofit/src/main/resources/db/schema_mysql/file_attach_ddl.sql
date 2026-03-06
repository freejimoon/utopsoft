-- =====================================================
-- 공통 첨부파일 DDL (MySQL 8.x)
-- ref_type + ref_no 조합으로 모든 엔티티 첨부파일 관리
-- =====================================================

USE `utopsoft`;

CREATE TABLE IF NOT EXISTS `tb_file_attach` (
    `attach_no`  BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT        COMMENT '첨부파일 번호 (PK)',
    `ref_type`   VARCHAR(20)      NOT NULL                       COMMENT '참조 엔티티 유형 (FAQ / NOTICE / ...)',
    `ref_no`     BIGINT UNSIGNED  NOT NULL                       COMMENT '참조 엔티티 PK',
    `orig_nm`    VARCHAR(255)     NOT NULL                       COMMENT '원본 파일명',
    `save_nm`    VARCHAR(255)     NOT NULL                       COMMENT '저장 파일명 (UUID + 확장자)',
    `file_path`  VARCHAR(500)     NOT NULL                       COMMENT '파일 저장 경로',
    `file_size`  BIGINT UNSIGNED  NOT NULL DEFAULT 0             COMMENT '파일 크기 (bytes)',
    `file_ext`   VARCHAR(20)      DEFAULT NULL                   COMMENT '파일 확장자 (소문자)',
    `created_at` DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    `created_by` VARCHAR(50)      DEFAULT NULL                   COMMENT '등록자',

    PRIMARY KEY (`attach_no`),
    KEY `idx_file_attach_ref` (`ref_type`, `ref_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공통 첨부파일';
