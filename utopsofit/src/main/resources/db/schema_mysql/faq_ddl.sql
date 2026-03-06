-- =====================================================
-- FAQ DDL (MySQL 8.x)
-- =====================================================

USE `utopsoft`;

DROP TABLE IF EXISTS `faq`;
CREATE TABLE `faq` (
    `faq_no`        BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT        COMMENT 'FAQ 번호 (PK)',
    `category_cd`   VARCHAR(20)      NOT NULL DEFAULT 'GENERAL'     COMMENT 'FAQ 분류 (공통코드 FAQ_CATEGORY)',
    `question`      VARCHAR(500)     NOT NULL                       COMMENT '질문',
    `answer`        TEXT             NOT NULL                       COMMENT '답변',
    `sort_ord`      INT UNSIGNED     NOT NULL DEFAULT 0             COMMENT '정렬 순서',
    `use_yn`        CHAR(1)          NOT NULL DEFAULT 'Y'           COMMENT '사용 여부 (Y/N)',
    `created_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP                          COMMENT '등록일시',
    `created_by`    VARCHAR(50)      DEFAULT NULL                   COMMENT '등록자',
    `updated_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`    VARCHAR(50)      DEFAULT NULL                   COMMENT '수정자',

    PRIMARY KEY (`faq_no`),
    KEY `idx_faq_category_cd` (`category_cd`),
    KEY `idx_faq_use_yn`      (`use_yn`),
    KEY `idx_faq_sort_ord`    (`sort_ord`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='FAQ';

-- =====================================================
-- 공통코드 INSERT (FAQ_CATEGORY)
-- =====================================================
INSERT INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `created_by`)
VALUES ('FAQ_CATEGORY_CD', 'FAQ 분류', 'FAQ 카테고리 구분', 'Y', 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('FAQ_CATEGORY_CD', 'GENERAL',  '일반',      '일반 FAQ',      'Y', 1, 'system'),
('FAQ_CATEGORY_CD', 'PAYMENT',  '결제/환불', '결제/환불 FAQ', 'Y', 2, 'system'),
('FAQ_CATEGORY_CD', 'ACCOUNT',  '계정',      '계정 관련 FAQ', 'Y', 3, 'system'),
('FAQ_CATEGORY_CD', 'SERVICE',  '서비스',    '서비스 이용 FAQ','Y', 4, 'system'),
('FAQ_CATEGORY_CD', 'ETC',      '기타',      '기타 FAQ',      'Y', 5, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);

-- =====================================================
-- 샘플 데이터
-- =====================================================
INSERT INTO `faq` (`category_cd`, `question`, `answer`, `sort_ord`, `created_by`)
VALUES
('ACCOUNT',  '비밀번호를 잊어버렸습니다.',
 '로그인 화면 하단의 [비밀번호 찾기]를 클릭하여 이메일로 재설정 링크를 받으실 수 있습니다.',
 1, 'admin01'),
('PAYMENT',  '결제 취소는 어떻게 하나요?',
 '결제 후 7일 이내에 고객센터 또는 앱 내 [나의 결제내역]에서 취소 신청이 가능합니다.',
 2, 'manager'),
('SERVICE',  '앱 최신 버전은 어떻게 확인하나요?',
 '앱스토어 또는 플레이스토어에서 [업데이트] 버튼을 통해 최신 버전으로 업데이트하실 수 있습니다.',
 3, 'admin01'),
('GENERAL',  '앱 알림 설정은 어디서 하나요?',
 '스마트폰 설정 > 앱 > 해당 앱 > 알림에서 설정하실 수 있습니다.',
 4, 'manager');
