-- =====================================================
-- 공지사항 DDL (MySQL 8.x)
-- =====================================================

USE `utopsoft`;

DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
    `notice_no`     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT         COMMENT '공지번호 (PK)',
    `title`         VARCHAR(300)     NOT NULL                        COMMENT '제목',
    `content`       TEXT             NOT NULL                        COMMENT '내용',
    `notice_cd`   VARCHAR(20)      NOT NULL DEFAULT 'GENERAL'      COMMENT '공지 유형 (GENERAL:일반 / URGENT:긴급 / EVENT:이벤트)',
    `pin_yn`        CHAR(1)          NOT NULL DEFAULT 'N'            COMMENT '상단 고정 여부',
    `use_yn`        CHAR(1)          NOT NULL DEFAULT 'Y'            COMMENT '사용 여부',
    `view_cnt`      INT UNSIGNED     NOT NULL DEFAULT 0              COMMENT '조회수',
    `created_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP                          COMMENT '등록일시',
    `created_by`    VARCHAR(50)      DEFAULT NULL                    COMMENT '등록자',
    `updated_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`    VARCHAR(50)      DEFAULT NULL                    COMMENT '수정자',

    PRIMARY KEY (`notice_no`),
    KEY `idx_notice_use_yn`      (`use_yn`),
    KEY `idx_notice_notice_cd` (`notice_cd`),
    KEY `idx_notice_pin_yn`      (`pin_yn`),
    KEY `idx_notice_created_at`  (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공지사항';

-- =====================================================
-- 공통코드 INSERT (NOTICE_TYPE)
-- =====================================================
INSERT INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `created_by`)
VALUES ('NOTICE_TYPE_CD', '공지 유형', '공지사항 유형 구분', 'Y', 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('NOTICE_TYPE_CD', 'GENERAL', '일반',   '일반 공지사항',  'Y', 1, 'system'),
('NOTICE_TYPE_CD', 'URGENT',  '긴급',   '긴급 공지사항',  'Y', 2, 'system'),
('NOTICE_TYPE_CD', 'EVENT',   '이벤트', '이벤트 안내',    'Y', 3, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);

-- =====================================================
-- 샘플 데이터
-- =====================================================
INSERT INTO `notice` (`title`, `content`, `notice_cd`, `pin_yn`, `use_yn`, `created_by`)
VALUES
('[긴급] 서버 점검 안내 (3/10 02:00~04:00)',  '원활한 서비스 제공을 위해 서버 점검을 진행합니다.\n점검 시간: 2026-03-10 02:00 ~ 04:00\n점검 중에는 앱 이용이 불가합니다.',                   'URGENT',  'Y', 'Y', 'admin'),
('앱 v2.5.0 업데이트 안내',                   '새로운 버전 2.5.0이 출시되었습니다.\n주요 변경 사항:\n- UI 개선\n- 성능 최적화\n- 버그 수정',                                          'GENERAL', 'Y', 'Y', 'admin'),
('이벤트] 봄맞이 포인트 2배 적립 이벤트',    '3월 한 달간 포인트 2배 적립 이벤트를 진행합니다.\n기간: 2026-03-01 ~ 2026-03-31\n해당 기간 모든 활동에 포인트가 2배 적립됩니다.',      'EVENT',   'N', 'Y', 'admin'),
('개인정보처리방침 개정 안내',                '개인정보처리방침이 아래와 같이 개정되었습니다.\n시행일: 2026-02-01\n주요 변경 내용: 수집 항목 추가 등.',                              'GENERAL', 'N', 'Y', 'admin'),
('서비스 이용약관 변경 안내',                 '서비스 이용약관이 변경되었습니다.\n시행일: 2026-01-15\n자세한 내용은 앱 내 약관 메뉴에서 확인하실 수 있습니다.',                     'GENERAL', 'N', 'Y', 'admin');
