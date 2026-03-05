-- =====================================================
-- 포인트(재화) DDL (MySQL 8.x)
-- 스키마: utopsoft
--
-- [포인트 💰 — 재화]
--   학습 완료, 챌린지, 출석 등으로 적립되는 가상 화폐.
--   강좌 구매, 아이템 교환 등에 차감 사용.
--   point_bal  : 회원별 현재 잔액 (member.point_bal 캐시와 동기화)
--   point_hist : 적립/사용 전체 이력
-- =====================================================

USE `utopsoft`;


-- -----------------------------------------------------
-- 1. 포인트 잔액 (point_bal)
--    회원당 1행 — 현재 잔액의 단일 진실 공급원
-- -----------------------------------------------------
DROP TABLE IF EXISTS `point_bal`;
CREATE TABLE `point_bal` (
    `member_no`     BIGINT UNSIGNED  NOT NULL                COMMENT '회원번호 (PK, FK → member)',
    `bal_amt`       INT UNSIGNED     NOT NULL DEFAULT 0      COMMENT '현재 포인트 잔액',
    `total_earn`    INT UNSIGNED     NOT NULL DEFAULT 0      COMMENT '누적 적립 합계',
    `total_use`     INT UNSIGNED     NOT NULL DEFAULT 0      COMMENT '누적 사용 합계',
    `updated_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 변경일시',

    PRIMARY KEY (`member_no`),
    CONSTRAINT `fk_point_bal_member` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='포인트 잔액';


-- -----------------------------------------------------
-- 2. 포인트 이력 (point_hist)
--    적립(EARN) / 사용(USE) / 만료(EXPIRE) / 취소(CANCEL) 전체 기록
-- -----------------------------------------------------
DROP TABLE IF EXISTS `point_hist`;
CREATE TABLE `point_hist` (
    `point_seq`     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT COMMENT '포인트 이력 순번 (PK)',
    `member_no`     BIGINT UNSIGNED  NOT NULL                COMMENT '회원번호 (FK → member)',

    -- 거래 유형
    `tran_type`     VARCHAR(10)      NOT NULL                COMMENT '거래유형 (EARN:적립 / USE:사용 / EXPIRE:만료 / CANCEL:취소)',
    `point_amt`     INT              NOT NULL                COMMENT '변동 포인트 (적립:양수, 사용·만료:음수)',
    `bal_after`     INT UNSIGNED     NOT NULL                COMMENT '거래 후 잔액',

    -- 발생 원인
    `ref_type`      VARCHAR(30)      DEFAULT NULL            COMMENT '발생 원인 유형 (LESSON:학습완료 / CHALLENGE:챌린지 / ATTEND:출석 / PURCHASE:구매사용 / ADMIN:관리자조정 / EXPIRE:기간만료)',
    `ref_id`        VARCHAR(100)     DEFAULT NULL            COMMENT '발생 원인 ID (강좌ID, 챌린지ID 등)',

    -- 만료
    `expire_dt`     DATE             DEFAULT NULL            COMMENT '포인트 만료 예정일 (NULL이면 무기한)',
    `is_expired`    CHAR(1)          NOT NULL DEFAULT 'N'    COMMENT '만료 처리 여부 (Y/N)',

    `remark`        VARCHAR(500)     DEFAULT NULL            COMMENT '비고',
    `created_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    `created_by`    VARCHAR(50)      DEFAULT NULL            COMMENT '생성자 (시스템 or 관리자ID)',

    PRIMARY KEY (`point_seq`),
    KEY `idx_point_hist_member_no`  (`member_no`),
    KEY `idx_point_hist_tran_type`  (`tran_type`),
    KEY `idx_point_hist_ref`        (`ref_type`, `ref_id`),
    KEY `idx_point_hist_expire_dt`  (`expire_dt`, `is_expired`),
    KEY `idx_point_hist_created`    (`created_at`),
    CONSTRAINT `fk_point_hist_member` FOREIGN KEY (`member_no`) REFERENCES `member` (`member_no`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='포인트 이력';


-- -----------------------------------------------------
-- 샘플 데이터
-- -----------------------------------------------------

-- point_bal: 회원별 포인트 잔액
INSERT INTO `point_bal` (`member_no`, `bal_amt`, `total_earn`, `total_use`) VALUES
(1,  320,  500,  180),
(2, 1200, 2000,  800),
(3, 5500, 8000, 2500),
(4,   50,  200,  150),
(5,    0,  100,  100);

-- point_hist: 포인트 이력 샘플
INSERT INTO `point_hist` (`member_no`, `tran_type`, `point_amt`, `bal_after`, `ref_type`, `ref_id`, `expire_dt`, `remark`, `created_by`) VALUES
(1, 'EARN',   100,  100, 'ATTEND',    NULL,   DATE_ADD(CURDATE(), INTERVAL 90 DAY), '출석 보상',          'system'),
(1, 'EARN',   200,  300, 'LESSON',    'L001', DATE_ADD(CURDATE(), INTERVAL 90 DAY), '강좌 완료 보상',     'system'),
(1, 'EARN',   200,  500, 'CHALLENGE', 'C001', DATE_ADD(CURDATE(), INTERVAL 90 DAY), '챌린지 달성 보상',   'system'),
(1, 'USE',   -100,  400, 'PURCHASE',  'P001', NULL,                                 '강좌 구매 사용',     'system'),
(1, 'USE',    -80,  320, 'PURCHASE',  'P002', NULL,                                 '아이템 교환',        'system'),
(2, 'EARN',  2000, 2000, 'LESSON',    'L002', DATE_ADD(CURDATE(), INTERVAL 90 DAY), '프리미엄 강좌 완료', 'system'),
(2, 'USE',   -800, 1200, 'PURCHASE',  'P003', NULL,                                 '강좌 패키지 구매',   'system');
