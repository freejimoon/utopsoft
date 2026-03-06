-- =====================================================
-- 포인트(재화) DDL (MySQL 8.x)
-- 스키마: utopsoft
--
-- [포인트 💰 — 재화]
--   학습 완료, 챌린지, 출석 등으로 적립되는 가상 화폐.
--   강좌 구매, 아이템 교환 등에 차감 사용.
--   tb_point_bal  : 회원별 현재 잔액 (tb_member.tb_point_bal 캐시와 동기화)
--   tb_point_hist : 적립/사용 전체 이력
-- =====================================================

USE `utopsoft`;


-- -----------------------------------------------------
-- 1. 포인트 잔액 (tb_point_bal)
--    회원당 1행 — 현재 잔액의 단일 진실 공급원
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tb_point_bal`;
CREATE TABLE `tb_point_bal` (
    `member_no`     BIGINT UNSIGNED  NOT NULL                COMMENT '회원번호 (PK, FK → tb_member)',
    `bal_amt`       INT UNSIGNED     NOT NULL DEFAULT 0      COMMENT '현재 포인트 잔액',
    `total_earn`    INT UNSIGNED     NOT NULL DEFAULT 0      COMMENT '누적 적립 합계',
    `total_use`     INT UNSIGNED     NOT NULL DEFAULT 0      COMMENT '누적 사용 합계',
    `updated_at`    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종 변경일시',

    PRIMARY KEY (`member_no`),
    CONSTRAINT `fk_point_bal_member` FOREIGN KEY (`member_no`) REFERENCES `tb_member` (`member_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='포인트 잔액';


-- -----------------------------------------------------
-- 2. 포인트 이력 (tb_point_hist)
--    적립(EARN) / 사용(USE) / 만료(EXPIRE) / 취소(CANCEL) 전체 기록
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tb_point_hist`;
CREATE TABLE `tb_point_hist` (
    `point_seq`     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT COMMENT '포인트 이력 순번 (PK)',
    `member_no`     BIGINT UNSIGNED  NOT NULL                COMMENT '회원번호 (FK → tb_member)',

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
    CONSTRAINT `fk_point_hist_member` FOREIGN KEY (`member_no`) REFERENCES `tb_member` (`member_no`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='포인트 이력';


-- -----------------------------------------------------
-- 샘플 데이터
-- -----------------------------------------------------

-- tb_point_bal: 회원별 포인트 잔액
INSERT INTO `tb_point_bal` (`member_no`, `bal_amt`, `total_earn`, `total_use`) VALUES
(1,  320,  500,  180),
(2, 1200, 2000,  800),
(3, 5500, 8000, 2500),
(4,   50,  200,  150),
(5,    0,  100,  100);

-- =====================================================
-- 공통코드 INSERT
-- =====================================================

-- 포인트 거래 유형 (POINT_TRAN_TYPE_CD)
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES ('POINT_TRAN_TYPE_CD', '포인트 거래유형', 'tb_point_hist.tran_type — 포인트 적립/사용/만료/취소 유형', 'Y', 61, 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('POINT_TRAN_TYPE_CD', 'EARN',   '적립', '포인트 적립 (양수)',               'Y', 1, 'system'),
('POINT_TRAN_TYPE_CD', 'USE',    '사용', '포인트 사용 (음수)',               'Y', 2, 'system'),
('POINT_TRAN_TYPE_CD', 'EXPIRE', '만료', '포인트 만료 처리 (음수)',          'Y', 3, 'system'),
('POINT_TRAN_TYPE_CD', 'CANCEL', '취소', '적립/사용 취소 (역부호)',          'Y', 4, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);


-- 포인트 발생원인 유형 (POINT_REF_TYPE_CD)
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES ('POINT_REF_TYPE_CD', '포인트 발생원인', 'tb_point_hist.ref_type — 포인트 발생 원인 구분', 'Y', 62, 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('POINT_REF_TYPE_CD', 'LESSON',    '학습완료',    '강좌·레슨 완료로 인한 적립',      'Y', 1, 'system'),
('POINT_REF_TYPE_CD', 'CHALLENGE', '챌린지',      '챌린지 달성으로 인한 적립',       'Y', 2, 'system'),
('POINT_REF_TYPE_CD', 'ATTEND',    '출석',        '출석 보상 적립',                  'Y', 3, 'system'),
('POINT_REF_TYPE_CD', 'PURCHASE',  '구매사용',    '강좌·아이템 구매 사용',           'Y', 4, 'system'),
('POINT_REF_TYPE_CD', 'ADMIN',     '관리자조정',  '관리자가 직접 조정한 포인트',     'Y', 5, 'system'),
('POINT_REF_TYPE_CD', 'EXPIRE',    '기간만료',    '보유 기간 초과로 인한 자동 만료', 'Y', 6, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);


-- tb_point_hist: 포인트 이력 샘플
INSERT INTO `tb_point_hist` (`member_no`, `tran_type`, `point_amt`, `bal_after`, `ref_type`, `ref_id`, `expire_dt`, `remark`, `created_by`) VALUES
(1, 'EARN',   100,  100, 'ATTEND',    NULL,   DATE_ADD(CURDATE(), INTERVAL 90 DAY), '출석 보상',          'system'),
(1, 'EARN',   200,  300, 'LESSON',    'L001', DATE_ADD(CURDATE(), INTERVAL 90 DAY), '강좌 완료 보상',     'system'),
(1, 'EARN',   200,  500, 'CHALLENGE', 'C001', DATE_ADD(CURDATE(), INTERVAL 90 DAY), '챌린지 달성 보상',   'system'),
(1, 'USE',   -100,  400, 'PURCHASE',  'P001', NULL,                                 '강좌 구매 사용',     'system'),
(1, 'USE',    -80,  320, 'PURCHASE',  'P002', NULL,                                 '아이템 교환',        'system'),
(2, 'EARN',  2000, 2000, 'LESSON',    'L002', DATE_ADD(CURDATE(), INTERVAL 90 DAY), '프리미엄 강좌 완료', 'system'),
(2, 'USE',   -800, 1200, 'PURCHASE',  'P003', NULL,                                 '강좌 패키지 구매',   'system');
