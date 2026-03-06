-- =====================================================
-- 경험치 DDL (MySQL 8.x)
-- 스키마: utopsoft
--
-- [경험치 ⭐ — 성장 지표]
--   활동(학습·챌린지·출석)으로 누적되어 레벨업에 사용.
--   차감 없이 오직 증가만 하며, 일정 수치 도달 시 레벨 상승.
--   exp_level_def : 레벨별 필요 경험치 + 달성 보상 정의
--   exp_bal       : 회원별 현재 누적 경험치 + 레벨 (member.exp_total/exp_level 캐시와 동기화)
--   exp_hist      : 경험치 획득 이력
-- =====================================================

USE `utopsoft`;


-- -----------------------------------------------------
-- 1. 레벨 정의 (exp_level_def)
--    각 레벨에 필요한 누적 경험치 기준 정의
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exp_level_def`;
CREATE TABLE `exp_level_def` (
    `level`         SMALLINT UNSIGNED NOT NULL              COMMENT '레벨 (PK)',
    `level_nm`      VARCHAR(50)       NOT NULL              COMMENT '레벨명 (예: 입문 / 초급 / 중급 / 고급 / 마스터)',
    `req_exp`       INT UNSIGNED      NOT NULL              COMMENT '해당 레벨 달성에 필요한 누적 경험치',
    `point_reward`  INT UNSIGNED      NOT NULL DEFAULT 0    COMMENT '레벨 달성 시 지급 포인트',
    `description`   VARCHAR(200)      DEFAULT NULL          COMMENT '레벨 설명',
    `created_at`    DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',

    PRIMARY KEY (`level`),
    KEY `idx_exp_level_def_req_exp` (`req_exp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='경험치 레벨 정의';


-- -----------------------------------------------------
-- 2. 경험치 잔액 (exp_bal)
--    회원당 1행 — 누적 경험치 + 현재 레벨의 단일 진실 공급원
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exp_bal`;
CREATE TABLE `exp_bal` (
    `member_no`      BIGINT UNSIGNED   NOT NULL                COMMENT '회원번호 (PK, FK → member)',
    `exp_total`      INT UNSIGNED      NOT NULL DEFAULT 0      COMMENT '누적 경험치 합계',
    `exp_level`      SMALLINT UNSIGNED NOT NULL DEFAULT 1      COMMENT '현재 레벨',
    `next_level_exp` INT UNSIGNED      DEFAULT NULL            COMMENT '다음 레벨까지 필요 경험치 (NULL이면 최고 레벨)',
    `updated_at`     DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 변경일시',

    PRIMARY KEY (`member_no`),
    KEY `idx_exp_bal_level`   (`exp_level`),
    KEY `idx_exp_bal_total`   (`exp_total` DESC),
    CONSTRAINT `fk_exp_bal_member`    FOREIGN KEY (`member_no`) REFERENCES `member`        (`member_no`) ON DELETE CASCADE,
    CONSTRAINT `fk_exp_bal_level_def` FOREIGN KEY (`exp_level`) REFERENCES `exp_level_def` (`level`)     ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='경험치 잔액';


-- -----------------------------------------------------
-- 3. 경험치 이력 (exp_hist)
--    경험치는 차감 없이 오직 획득(EARN)만 기록
--    레벨업 시 level_before / level_after 에 변경 내역 기록
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exp_hist`;
CREATE TABLE `exp_hist` (
    `exp_seq`         BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT COMMENT '경험치 이력 순번 (PK)',
    `member_no`       BIGINT UNSIGNED   NOT NULL                COMMENT '회원번호 (FK → member)',

    -- 경험치 획득
    `exp_amt`         INT UNSIGNED      NOT NULL                COMMENT '획득 경험치',
    `exp_total_after` INT UNSIGNED      NOT NULL                COMMENT '획득 후 누적 경험치',

    -- 레벨 변동 (레벨업이 없으면 before = after)
    `level_before`    SMALLINT UNSIGNED NOT NULL                COMMENT '획득 전 레벨',
    `level_after`     SMALLINT UNSIGNED NOT NULL                COMMENT '획득 후 레벨 (레벨업 시 변경)',
    `is_level_up`     CHAR(1)           NOT NULL DEFAULT 'N'    COMMENT '레벨업 여부 (Y/N)',

    -- 발생 원인
    `earn_type`       VARCHAR(30)       NOT NULL                COMMENT '획득 원인 (LESSON:학습완료 / CHALLENGE:챌린지 / ATTEND:출석 / QUIZ:퀴즈 / REVIEW:복습 / ADMIN:관리자조정)',
    `ref_id`          VARCHAR(100)      DEFAULT NULL            COMMENT '발생 원인 ID (강좌ID, 챌린지ID 등)',

    `remark`          VARCHAR(500)      DEFAULT NULL            COMMENT '비고',
    `created_at`      DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    `created_by`      VARCHAR(50)       DEFAULT NULL            COMMENT '생성자 (시스템 or 관리자ID)',

    PRIMARY KEY (`exp_seq`),
    KEY `idx_exp_hist_member_no` (`member_no`),
    KEY `idx_exp_hist_earn_type` (`earn_type`),
    KEY `idx_exp_hist_level_up`  (`member_no`, `is_level_up`),
    KEY `idx_exp_hist_created`   (`created_at`),
    CONSTRAINT `fk_exp_hist_member` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='경험치 이력';


-- -----------------------------------------------------
-- 샘플 데이터
-- -----------------------------------------------------

-- =====================================================
-- 공통코드 INSERT
-- =====================================================

-- 경험치 획득원인 유형 (EXP_EARN_TYPE_CD)
INSERT INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES ('EXP_EARN_TYPE_CD', '경험치 획득원인', 'exp_hist.earn_type — 경험치 획득 원인 구분', 'Y', 63, 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('EXP_EARN_TYPE_CD', 'LESSON',    '학습완료', '강좌·레슨 완료로 인한 경험치 획득',    'Y', 1, 'system'),
('EXP_EARN_TYPE_CD', 'CHALLENGE', '챌린지',   '챌린지 달성으로 인한 경험치 획득',     'Y', 2, 'system'),
('EXP_EARN_TYPE_CD', 'ATTEND',    '출석',     '출석 보상 경험치 획득',                'Y', 3, 'system'),
('EXP_EARN_TYPE_CD', 'QUIZ',      '퀴즈',     '퀴즈 완료로 인한 경험치 획득',         'Y', 4, 'system'),
('EXP_EARN_TYPE_CD', 'REVIEW',    '복습',     '복습 활동으로 인한 경험치 획득',       'Y', 5, 'system'),
('EXP_EARN_TYPE_CD', 'ADMIN',     '관리자조정','관리자가 직접 조정한 경험치',          'Y', 6, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);


-- exp_level_def: 레벨 정의
INSERT INTO `exp_level_def` (`level`, `level_nm`, `req_exp`, `point_reward`, `description`) VALUES
( 1, '입문',    0,       0,   '학습을 시작한 단계'),
( 2, '초급1',   300,    50,   '기초 학습 완료'),
( 3, '초급2',   700,    50,   '초급 과정 진행 중'),
( 4, '초급3',   1200,  100,   '초급 과정 완료'),
( 5, '중급1',   2000,  100,   '중급 과정 시작'),
(10, '중급2',   4000,  200,   '중급 과정 진행 중'),
(15, '고급1',   8000,  300,   '고급 과정 시작'),
(20, '고급2',  14000,  500,   '고급 과정 진행 중'),
(25, '최고급', 22000,  500,   '최고급 과정 시작'),
(30, '마스터', 35000, 1000,   '모든 과정 마스터');

-- exp_bal: 회원별 경험치 잔액
INSERT INTO `exp_bal` (`member_no`, `exp_total`, `exp_level`, `next_level_exp`) VALUES
(1,   750,  5,  1250),
(2,  3200, 12,   800),
(3, 18000, 30,  NULL),
(4,   200,  2,   500),
(5,     0,  1,   300);

-- exp_hist: 경험치 이력 샘플
INSERT INTO `exp_hist` (`member_no`, `exp_amt`, `exp_total_after`, `level_before`, `level_after`, `is_level_up`, `earn_type`, `ref_id`, `remark`, `created_by`) VALUES
(1,   50,   50, 1, 1, 'N', 'ATTEND',    NULL,   '출석 경험치',            'system'),
(1,  200,  250, 1, 1, 'N', 'LESSON',    'L001', '강좌 완료 경험치',       'system'),
(1,  100,  350, 1, 2, 'Y', 'QUIZ',      'Q001', '퀴즈 완료 + 레벨업',     'system'),
(1,  200,  550, 2, 2, 'N', 'LESSON',    'L002', '강좌 완료 경험치',       'system'),
(1,  200,  750, 2, 5, 'Y', 'CHALLENGE', 'C001', '챌린지 달성 + 레벨업',   'system'),
(2,  500,  500, 1, 2, 'Y', 'LESSON',    'L003', '강좌 완료 + 레벨업',     'system'),
(2, 1000, 1500, 2, 5, 'Y', 'CHALLENGE', 'C002', '챌린지 달성 + 레벨업',   'system');
