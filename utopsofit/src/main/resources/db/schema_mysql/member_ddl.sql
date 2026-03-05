-- =====================================================
-- 회원 DDL (MySQL 8.x)
-- 스키마: utopsoft
-- 설명: 앱 서비스 이용 회원 (관리자 usr 테이블과 별도)
--
-- [회원 유형]
--   FREE      : 무료 회원 — 기본 콘텐츠 이용 가능
--   PAID      : 유료 개인 회원 — 구독 플랜 결제
--   GROUP     : 단체 유료 회원 — 단체(member_group) 소속, 단체가 일괄 결제
--
-- [실행 순서]
--   1. member_group  (단체 — member 보다 먼저 생성)
--   2. member        (회원 — group_no FK → member_group)
-- =====================================================

USE `utopsoft`;


-- =====================================================
-- 1. 단체 (member_group)
--    유료 단체 회원의 소속 단체 정보
-- =====================================================
DROP TABLE IF EXISTS `member_group`;
CREATE TABLE `member_group` (
    `group_no`          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT        COMMENT '단체번호 (PK)',
    `group_nm`          VARCHAR(200)     NOT NULL                       COMMENT '단체명 (학교/기업/기관명)',
    `group_type`        VARCHAR(20)      NOT NULL DEFAULT 'COMPANY'     COMMENT '단체유형 (SCHOOL:학교 / COMPANY:기업 / INSTITUTE:학원 / ORG:기관)',

    -- 대표자 / 담당자
    `represent_nm`      VARCHAR(100)     DEFAULT NULL                   COMMENT '대표자명',
    `manager_nm`        VARCHAR(100)     DEFAULT NULL                   COMMENT '담당자명',
    `manager_phone`     VARCHAR(20)      DEFAULT NULL                   COMMENT '담당자 연락처',
    `manager_email`     VARCHAR(200)     DEFAULT NULL                   COMMENT '담당자 이메일',

    -- 사업자 정보
    `business_no`       VARCHAR(30)      DEFAULT NULL                   COMMENT '사업자등록번호',
    `address`           VARCHAR(500)     DEFAULT NULL                   COMMENT '주소',

    -- 계약 / 구독
    `contract_status`   VARCHAR(20)      NOT NULL DEFAULT 'ACTIVE'      COMMENT '계약상태 (ACTIVE:계약중 / EXPIRED:만료 / CANCELED:해지)',
    `contract_start_dt` DATE             DEFAULT NULL                   COMMENT '계약 시작일',
    `contract_end_dt`   DATE             DEFAULT NULL                   COMMENT '계약 만료일',
    `max_member_cnt`    INT UNSIGNED     NOT NULL DEFAULT 100             COMMENT '최대 구성원 수',
    `current_member_cnt` INT UNSIGNED    NOT NULL DEFAULT 0             COMMENT '현재 구성원 수',

    -- 결제
    `pay_method_cd`     VARCHAR(20)      DEFAULT NULL                   COMMENT '결제 수단 (CARD/BANK/TRANSFER)',
    `monthly_fee`       INT UNSIGNED     NOT NULL DEFAULT 0             COMMENT '월 구독료 (원)',
    `last_pay_dt`       DATETIME         DEFAULT NULL                   COMMENT '최종 결제 일시',

    -- 감사 컬럼
    `created_at`        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP                        COMMENT '생성일시',
    `created_by`        VARCHAR(50)      DEFAULT NULL                                              COMMENT '생성자',
    `updated_at`        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`        VARCHAR(50)      DEFAULT NULL                                              COMMENT '수정자',

    PRIMARY KEY (`group_no`),
    UNIQUE KEY `uq_member_group_business_no` (`business_no`),
    KEY `idx_member_group_type`              (`group_type`),
    KEY `idx_member_group_contract_status`   (`contract_status`),
    KEY `idx_member_group_contract_end_dt`   (`contract_end_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='단체 (단체 유료 회원 소속)';


-- =====================================================
-- 2. 회원 (member)
-- =====================================================
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
    `member_no`         BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT        COMMENT '회원번호 (PK)',
    `member_id`         VARCHAR(50)      NOT NULL                       COMMENT '회원 로그인 ID',
    `member_pw`         VARCHAR(255)     DEFAULT NULL                   COMMENT '비밀번호 (BCrypt, 소셜 로그인 시 NULL)',
    `member_nm`         VARCHAR(100)     NOT NULL                       COMMENT '회원명 (닉네임)',
    `real_nm`           VARCHAR(100)     DEFAULT NULL                   COMMENT '실명',
    `email`             VARCHAR(200)     NOT NULL                       COMMENT '이메일',
    `phone`             VARCHAR(20)      DEFAULT NULL                   COMMENT '휴대폰 번호',
    `gender_cd`         CHAR(1)          DEFAULT NULL                   COMMENT '성별 (M:남 / F:여)',
    `birth_dt`          DATE             DEFAULT NULL                   COMMENT '생년월일',
    `profile_img_url`   VARCHAR(500)     DEFAULT NULL                   COMMENT '프로필 이미지 URL',

    -- 소셜 로그인
    `social_type`       VARCHAR(20)      NOT NULL DEFAULT 'NONE'        COMMENT '소셜 로그인 유형 (NONE/GOOGLE/APPLE/KAKAO/NAVER)',
    `social_id`         VARCHAR(200)     DEFAULT NULL                   COMMENT '소셜 로그인 고유 ID',

    -- 회원 유형
    `membership_type`   VARCHAR(20)      NOT NULL DEFAULT 'FREE'        COMMENT '회원유형 (FREE:무료 / PAID:유료개인 / GROUP:단체유료)',

    -- 구독 정보 (FREE는 NONE, PAID·GROUP은 ACTIVE/EXPIRED 등)
    `sub_status`        VARCHAR(20)      NOT NULL DEFAULT 'NONE'        COMMENT '구독상태 (NONE:미구독 / ACTIVE:구독중 / EXPIRED:만료 / CANCELED:해지 / PAUSED:일시정지)',
    `sub_plan_cd`       VARCHAR(30)      DEFAULT NULL                   COMMENT '구독 플랜 (MONTHLY:월간 / ANNUAL:연간 / TRIAL:체험 / GROUP_MONTHLY:단체월간 / GROUP_ANNUAL:단체연간)',
    `sub_start_dt`      DATE             DEFAULT NULL                   COMMENT '구독 시작일',
    `sub_end_dt`        DATE             DEFAULT NULL                   COMMENT '구독 만료일',
    `sub_auto_yn`       CHAR(1)          NOT NULL DEFAULT 'N'           COMMENT '자동 갱신 여부 (Y/N, 개인 유료만 해당)',
    `sub_cancel_dt`     DATETIME         DEFAULT NULL                   COMMENT '구독 해지 일시',
    `sub_cancel_reason` VARCHAR(500)     DEFAULT NULL                   COMMENT '구독 해지 사유',

    -- 개인 결제 정보 (PAID 회원만 해당, GROUP은 단체에서 일괄 결제)
    `pay_method_cd`     VARCHAR(20)      DEFAULT NULL                   COMMENT '결제 수단 (CARD:카드 / KAKAO_PAY / NAVER_PAY / APPLE_PAY / BANK:계좌이체)',
    `last_pay_dt`       DATETIME         DEFAULT NULL                   COMMENT '최종 결제 일시',
    `last_pay_amt`      INT UNSIGNED     DEFAULT NULL                   COMMENT '최종 결제 금액 (원)',

    -- 단체 소속 정보 (GROUP 회원만 해당)
    `group_no`          BIGINT UNSIGNED  DEFAULT NULL                   COMMENT '소속 단체번호 (FK → member_group, GROUP 회원만 값 존재)',
    `group_role`        VARCHAR(20)      DEFAULT NULL                   COMMENT '단체 내 역할 (ADMIN:단체관리자 / MEMBER:일반구성원)',
    `group_join_dt`     DATETIME         DEFAULT NULL                   COMMENT '단체 가입 일시',

    -- 계정 상태 / 등급
    `status_cd`         VARCHAR(20)      NOT NULL DEFAULT 'ACTIVE'      COMMENT '계정상태 (ACTIVE:정상 / INACTIVE:비활성 / DORMANT:휴면 / WITHDRAWN:탈퇴)',
    `grade_cd`          VARCHAR(20)      NOT NULL DEFAULT 'NORMAL'      COMMENT '등급 (NORMAL/SILVER/GOLD/VIP)',

    -- 마케팅 동의
    `mkt_agree_yn`      CHAR(1)          NOT NULL DEFAULT 'N'           COMMENT '마케팅 수신 동의 (Y/N)',
    `mkt_agree_dt`      DATETIME         DEFAULT NULL                   COMMENT '마케팅 동의 일시',

    -- 보안
    `pwd_chg_dt`        DATE             DEFAULT NULL                   COMMENT '비밀번호 변경일',
    `login_fail_cnt`    TINYINT UNSIGNED NOT NULL DEFAULT 0             COMMENT '연속 로그인 실패 횟수',
    `lock_yn`           CHAR(1)          NOT NULL DEFAULT 'N'           COMMENT '계정 잠금 여부 (Y/N)',

    -- 가입 / 탈퇴
    `join_dt`           DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일시',
    `last_login_dt`     DATETIME         DEFAULT NULL                   COMMENT '최종 로그인 일시',
    `withdraw_dt`       DATETIME         DEFAULT NULL                   COMMENT '탈퇴 일시',
    `withdraw_reason`   VARCHAR(500)     DEFAULT NULL                   COMMENT '탈퇴 사유',

    -- 감사 컬럼
    `created_at`        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP                        COMMENT '생성일시',
    `created_by`        VARCHAR(50)      DEFAULT NULL                                              COMMENT '생성자',
    `updated_at`        DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`        VARCHAR(50)      DEFAULT NULL                                              COMMENT '수정자',

    PRIMARY KEY (`member_no`),
    UNIQUE KEY `uq_member_id`              (`member_id`),
    UNIQUE KEY `uq_member_email`           (`email`),
    UNIQUE KEY `uq_member_social`          (`social_type`, `social_id`),
    KEY `idx_member_membership_type`       (`membership_type`),
    KEY `idx_member_sub_status`            (`sub_status`),
    KEY `idx_member_sub_end_dt`            (`sub_end_dt`),
    KEY `idx_member_group_no`              (`group_no`),
    KEY `idx_member_status_cd`             (`status_cd`),
    KEY `idx_member_grade_cd`              (`grade_cd`),
    KEY `idx_member_join_dt`               (`join_dt`),
    KEY `idx_member_last_login`            (`last_login_dt`),
    CONSTRAINT `fk_member_group` FOREIGN KEY (`group_no`) REFERENCES `member_group` (`group_no`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='앱 서비스 회원';


-- =====================================================
-- 샘플 데이터
-- 기본 비밀번호: 1234  (BCrypt 해시)
-- =====================================================

-- member_group: 단체 샘플
INSERT INTO `member_group`
    (`group_nm`, `group_type`, `represent_nm`, `manager_nm`, `manager_phone`, `manager_email`,
     `business_no`, `contract_status`, `contract_start_dt`, `contract_end_dt`,
     `max_member_cnt`, `current_member_cnt`, `pay_method_cd`, `monthly_fee`, `created_by`)
VALUES
('서울한국어학원',   'INSTITUTE', '김원장', '이담당', '02-1234-0001', 'seoul@hakwon.com',  '123-45-67890', 'ACTIVE',   '2025-01-01', '2025-12-31', 30, 25, 'CARD',  500000, 'admin'),
('한국대학교',       'SCHOOL',    '박총장', '최담당', '02-1234-0002', 'korea@univ.com',    '234-56-78901', 'ACTIVE',   '2025-03-01', '2026-02-28', 50, 42, 'BANK',  800000, 'admin'),
('글로벌코퍼레이션', 'COMPANY',   '정대표', '홍담당', '02-1234-0003', 'global@corp.com',   '345-67-89012', 'CANCELED', '2024-06-01', '2024-12-31', 20,  0, 'CARD',  300000, 'admin');

-- member: 회원 샘플 (유형별)
INSERT INTO `member`
    (`member_id`, `member_pw`, `member_nm`, `real_nm`, `email`, `phone`,
     `gender_cd`, `birth_dt`, `social_type`,
     `membership_type`, `sub_status`, `sub_plan_cd`, `sub_start_dt`, `sub_end_dt`, `sub_auto_yn`,
     `pay_method_cd`, `last_pay_dt`, `last_pay_amt`,
     `group_no`, `group_role`, `group_join_dt`,
     `status_cd`, `grade_cd`, `mkt_agree_yn`, `created_by`)
VALUES
-- 무료 회원
('hong01', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 '언어왕홍길동', '홍길동', 'hong01@test.com', '010-2000-0001', 'M', '1990-05-15', 'NONE',
 'FREE', 'NONE', NULL, NULL, NULL, 'N',
 NULL, NULL, NULL,
 NULL, NULL, NULL,
 'ACTIVE', 'NORMAL', 'Y', 'system'),

-- 유료 개인 회원 (월간)
('kim01', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 '김철수', '김철수', 'kim01@test.com', '010-2000-0002', 'M', '1995-11-02', 'GOOGLE',
 'PAID', 'ACTIVE', 'MONTHLY', '2025-01-01', '2025-12-31', 'Y',
 'CARD', '2025-02-01 10:00:00', 9900,
 NULL, NULL, NULL,
 'ACTIVE', 'SILVER', 'Y', 'system'),

-- 유료 개인 회원 (연간)
('lee01', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 '이영희짱', '이영희', 'lee01@test.com', '010-2000-0003', 'F', '1998-03-22', 'APPLE',
 'PAID', 'ACTIVE', 'ANNUAL', '2025-01-01', '2025-12-31', 'Y',
 'APPLE_PAY', '2025-01-01 09:00:00', 99000,
 NULL, NULL, NULL,
 'ACTIVE', 'GOLD', 'N', 'system'),

-- 단체 유료 회원 (단체관리자)
('park01', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 '박민준', '박민준', 'park01@test.com', '010-2000-0004', 'M', '2000-07-30', 'KAKAO',
 'GROUP', 'ACTIVE', 'GROUP_ANNUAL', '2025-01-01', '2025-12-31', 'N',
 NULL, NULL, NULL,
 1, 'ADMIN', '2025-01-01 08:00:00',
 'ACTIVE', 'GOLD', 'N', 'system'),

-- 단체 유료 회원 (일반구성원)
('choi01', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 '최지수', '최지수', 'choi01@test.com', '010-2000-0005', 'F', '1993-09-18', 'NONE',
 'GROUP', 'ACTIVE', 'GROUP_ANNUAL', '2025-01-01', '2025-12-31', 'N',
 NULL, NULL, NULL,
 1, 'MEMBER', '2025-01-05 10:00:00',
 'ACTIVE', 'SILVER', 'Y', 'system'),

-- 구독 만료 회원
('jung01', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 '정민수', '정민수', 'jung01@test.com', '010-2000-0006', 'M', '1988-12-01', 'NONE',
 'PAID', 'EXPIRED', 'MONTHLY', '2024-12-01', '2024-12-31', 'N',
 'CARD', '2024-12-01 11:00:00', 9900,
 NULL, NULL, NULL,
 'ACTIVE', 'NORMAL', 'N', 'system');
