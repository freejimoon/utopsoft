-- =============================================================
--  문의 관리 DDL  (MySQL 8.x / InnoDB)
--  스키마: utopsoft
-- =============================================================

USE `utopsoft`;

-- -----------------------------------------------------
--  문의 (tb_inquiry)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tb_inquiry`;
CREATE TABLE `tb_inquiry` (
    `inq_no`           BIGINT        NOT NULL AUTO_INCREMENT  COMMENT '문의 번호 (PK)',
    `member_no`        BIGINT        NOT NULL                 COMMENT '회원 번호 (FK → tb_member.member_no)',
    `title`            VARCHAR(200)  NOT NULL                 COMMENT '문의 제목',
    `content`          TEXT          NOT NULL                 COMMENT '문의 내용',
    `inq_category_cd`  VARCHAR(20)   NOT NULL DEFAULT 'GENERAL' COMMENT '문의 유형 → tb_com_code INQ_CATEGORY_CD (GENERAL/PAYMENT/ACCOUNT/SERVICE/ETC)',
    `inq_status_cd`    VARCHAR(20)   NOT NULL DEFAULT 'WAIT'  COMMENT '상태 (WAIT:대기중 / DONE:답변완료)',
    `reply_content` TEXT                                   COMMENT '답변 내용',
    `reply_dt`      DATETIME                               COMMENT '답변 등록 일시',
    `reply_by`      VARCHAR(50)                            COMMENT '답변 등록자 (관리자 usr_id)',
    `created_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP                       COMMENT '등록일시',
    `updated_at`    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (`inq_no`),
    KEY `idx_inquiry_member`   (`member_no`),
    KEY `idx_inquiry_category` (`inq_category_cd`),
    KEY `idx_inquiry_status`   (`inq_status_cd`),
    KEY `idx_inquiry_created`  (`created_at` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='문의';

-- -----------------------------------------------------
--  공통 코드 추가 — 문의 유형 (INQ_CATEGORY)
-- -----------------------------------------------------
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES ('INQ_CATEGORY_CD', '문의 유형', '문의 카테고리 구분', 'Y', 51, 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
('INQ_CATEGORY_CD', 'GENERAL',  '일반',      '일반 문의',                'Y', 1, 'system'),
('INQ_CATEGORY_CD', 'PAYMENT',  '결제/환불', '결제·환불 관련 문의',      'Y', 2, 'system'),
('INQ_CATEGORY_CD', 'ACCOUNT',  '계정',      '계정·로그인 관련 문의',    'Y', 3, 'system'),
('INQ_CATEGORY_CD', 'SERVICE',  '서비스',    '서비스 이용 관련 문의',    'Y', 4, 'system'),
('INQ_CATEGORY_CD', 'ETC',      '기타',      '기타 문의',                'Y', 5, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);


-- -----------------------------------------------------
--  공통 코드 추가 — 문의 상태 (INQ_STATUS)
-- -----------------------------------------------------
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES ('INQ_STATUS_CD', '문의 상태', '문의 처리 상태 코드', 'Y', 50, 'system')
ON DUPLICATE KEY UPDATE `grp_nm` = VALUES(`grp_nm`);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `created_by`)
VALUES
    ('INQ_STATUS_CD', 'WAIT', '대기중',   '답변 대기 중인 문의', 'Y', 1, 'system'),
    ('INQ_STATUS_CD', 'DONE', '답변완료', '답변이 완료된 문의',  'Y', 2, 'system')
ON DUPLICATE KEY UPDATE `code_nm` = VALUES(`code_nm`);

-- -----------------------------------------------------
--  샘플 데이터 (member_no 1~5 가 존재한다고 가정)
-- -----------------------------------------------------
INSERT INTO `tb_inquiry` (`member_no`, `title`, `content`, `inq_status_cd`, `reply_content`, `reply_dt`, `reply_by`, `created_at`) VALUES
(1, '앱 실행이 안돼요',                '앱을 실행하면 바로 종료됩니다. 아이폰 13 사용중입니다.',               'WAIT', NULL,                                  NULL,                '관리자', '2024-05-25 14:30:00'),
(2, '결제 취소 요청합니다',            '잘못 결제했습니다. 취소 부탁드립니다.',                               'DONE', '결제 취소 처리 완료되었습니다.',           '2024-05-24 10:15:00','admin',  '2024-05-23 21:05:00'),
(3, '배송 리스트 선택 문의',           '앱 내 배송지 선택 화면이 보이지 않습니다.',                           'WAIT', NULL,                                  NULL,                'admin',  '2024-05-23 18:20:00'),
(4, '번티 사랑합니다 0',               '서비스가 너무 좋습니다. 계속 이용할게요.',                            'DONE', '감사합니다. 더 좋은 서비스로 보답하겠습니다.','2024-05-20 16:36:00','admin', '2024-05-20 12:20:00'),
(1, '문의 사항입니다 1',               '첫 번째 추가 문의입니다.',                                            'WAIT', NULL,                                  NULL,                'admin',  '2024-05-16 10:00:00'),
(2, '문의 사항입니다 2',               '두 번째 추가 문의입니다.',                                            'WAIT', NULL,                                  NULL,                'admin',  '2024-05-16 10:00:00'),
(3, '문의 사항입니다 3',               '세 번째 추가 문의입니다.',                                            'DONE', '답변 드립니다.',                        '2024-06-17 14:03:00','admin', '2024-05-17 10:00:00'),
(4, '문의 사항입니다 4',               '네 번째 추가 문의입니다.',                                            'WAIT', NULL,                                  NULL,                'admin',  '2024-05-16 10:00:00'),
(5, '문의 사항입니다 5',               '다섯 번째 추가 문의입니다.',                                          'WAIT', NULL,                                  NULL,                'admin',  '2024-05-16 10:00:00'),
(1, '문의 사항입니다 6',               '여섯 번째 추가 문의입니다.',                                          'DONE', '확인 후 처리 완료하였습니다.',          '2024-05-14 10:00:00','admin', '2024-05-14 10:00:00');
