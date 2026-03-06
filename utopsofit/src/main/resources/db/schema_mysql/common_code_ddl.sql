-- =====================================================
-- 공통코드 DDL (MySQL 8.x)
-- 스키마: utopsoft
-- =====================================================

USE `utopsoft`;

-- -----------------------------------------------------
-- 1. 공통코드 그룹 (코드 유형 마스터)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tb_com_code_grp`;
CREATE TABLE `tb_com_code_grp` (
    `grp_cd`        VARCHAR(50)  NOT NULL COMMENT '그룹코드 (PK)',
    `grp_nm`        VARCHAR(100) NOT NULL COMMENT '그룹명',
    `grp_desc`      VARCHAR(500) DEFAULT NULL COMMENT '그룹 설명',
    `use_yn`        CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '사용여부 (Y/N)',
    `sort_ord`      INT         NOT NULL DEFAULT 0 COMMENT '정렬순서',
    `created_at`    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    `created_by`    VARCHAR(50) DEFAULT NULL COMMENT '등록자',
    `updated_at`    DATETIME    DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`    VARCHAR(50) DEFAULT NULL COMMENT '수정자',
    PRIMARY KEY (`grp_cd`),
    KEY `idx_com_code_grp_use_yn` (`use_yn`),
    KEY `idx_com_code_grp_sort_ord` (`sort_ord`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공통코드 그룹';


-- -----------------------------------------------------
-- 2. 공통코드 (코드 상세)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tb_com_code`;
CREATE TABLE `tb_com_code` (
    `grp_cd`        VARCHAR(50)  NOT NULL COMMENT '그룹코드 (FK)',
    `code`          VARCHAR(50)  NOT NULL COMMENT '코드 (PK)',
    `code_nm`       VARCHAR(200) NOT NULL COMMENT '코드명',
    `code_desc`     VARCHAR(500) DEFAULT NULL COMMENT '코드 설명',
    `use_yn`        CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '사용여부 (Y/N)',
    `sort_ord`      INT         NOT NULL DEFAULT 0 COMMENT '정렬순서',
    `attr1`         VARCHAR(200) DEFAULT NULL COMMENT '속성1 (확장)',
    `attr2`         VARCHAR(200) DEFAULT NULL COMMENT '속성2 (확장)',
    `attr3`         VARCHAR(200) DEFAULT NULL COMMENT '속성3 (확장)',
    `created_at`    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    `created_by`    VARCHAR(50) DEFAULT NULL COMMENT '등록자',
    `updated_at`    DATETIME    DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    `updated_by`    VARCHAR(50) DEFAULT NULL COMMENT '수정자',
    PRIMARY KEY (`grp_cd`, `code`),
    KEY `idx_com_code_grp_cd` (`grp_cd`),
    KEY `idx_com_code_use_yn` (`use_yn`),
    KEY `idx_com_code_sort_ord` (`grp_cd`, `sort_ord`),
    CONSTRAINT `fk_com_code_grp` FOREIGN KEY (`grp_cd`) REFERENCES `tb_com_code_grp` (`grp_cd`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공통코드';


-- -----------------------------------------------------
-- 기본 공통코드
-- -----------------------------------------------------
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`) VALUES
('GENDER_CD',   '성별',   'tb_member.gender_cd — 회원 성별',            'Y', 1),
('PAY_TYPE_CD', '결제수단', 'tb_member.pay_method_cd — 결제 유형 구분', 'Y', 4);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `use_yn`, `sort_ord`) VALUES
('GENDER_CD',   'M', '남', 'Y', 1),
('GENDER_CD',   'F', '여', 'Y', 2);

INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('PAY_TYPE_CD', 'CARD',       '카드',       '신용/체크카드 결제',      'Y', 1),
('PAY_TYPE_CD', 'BANK',       '계좌이체',   '실시간 계좌이체',         'Y', 2),
('PAY_TYPE_CD', 'CASH',       '현금',       '현금 결제',               'Y', 3),
('PAY_TYPE_CD', 'KAKAO_PAY',  '카카오페이', '카카오페이 간편결제',     'Y', 4),
('PAY_TYPE_CD', 'NAVER_PAY',  '네이버페이', '네이버페이 간편결제',     'Y', 5),
('PAY_TYPE_CD', 'APPLE_PAY',  '애플페이',   'Apple Pay 간편결제',      'Y', 6);


-- =====================================================
-- 회원 관련 공통코드 (member_ddl 연관)
-- sort_ord 21번부터 이어서 추가
-- =====================================================

-- -----------------------------------------------------
-- 그룹 추가
-- -----------------------------------------------------
INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`) VALUES
('SOCIAL_TYPE_CD',     '소셜로그인유형', 'tb_member.social_cd — 소셜 로그인 플랫폼 구분',                   'Y', 21),
('MEMBERSHIP_TYPE_CD', '회원유형',       'tb_member.membership_cd — 무료/유료개인/단체유료 구분',            'Y', 22),
('SUB_STATUS_CD',      '구독상태',       'tb_member.sub_status_cd — 구독 진행 상태 구분',                    'Y', 23),
('SUB_PLAN_CD',        '구독플랜',       'tb_member.sub_plan_cd — 구독 플랜(주기/유형) 구분',                'Y', 24),
('GROUP_TYPE_CD',      '단체유형',       'tb_member_group.group_cd — 소속 단체 종류 구분',                   'Y', 25),
('CONTRACT_STATUS_CD', '계약상태',       'tb_member_group.contract_status_cd — 단체 계약 진행 상태 구분',    'Y', 26),
('GROUP_ROLE_CD',      '단체역할',       'tb_member.group_role_cd — 단체 내 구성원 역할 구분',               'Y', 27),
('MEMBER_STATUS_CD',   '계정상태',       'tb_member.status_cd — 회원 계정 활성 상태 구분',                   'Y', 28),
('MEMBER_GRADE_CD',    '회원등급',       'tb_member.grade_cd — 회원 등급 구분',                              'Y', 29);


-- -----------------------------------------------------
-- SOCIAL_TYPE : 소셜 로그인 유형
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('SOCIAL_TYPE_CD', 'NONE',   '일반',     '소셜 연동 없이 자체 ID/PW로 가입한 회원', 'Y', 1),
('SOCIAL_TYPE_CD', 'GOOGLE', '구글',     'Google 소셜 로그인',                       'Y', 2),
('SOCIAL_TYPE_CD', 'APPLE',  '애플',     'Apple 소셜 로그인',                        'Y', 3),
('SOCIAL_TYPE_CD', 'KAKAO',  '카카오',   'Kakao 소셜 로그인',                        'Y', 4),
('SOCIAL_TYPE_CD', 'NAVER',  '네이버',   'Naver 소셜 로그인',                        'Y', 5);


-- -----------------------------------------------------
-- MEMBERSHIP_TYPE : 회원 유형
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('MEMBERSHIP_TYPE_CD', 'FREE',  '무료회원',     '기본 콘텐츠 이용 가능, 구독 없음',             'Y', 1),
('MEMBERSHIP_TYPE_CD', 'PAID',  '유료개인회원', '개인 구독 플랜 결제 회원',                     'Y', 2),
('MEMBERSHIP_TYPE_CD', 'GROUP', '단체유료회원', '단체(tb_member_group) 소속, 단체에서 일괄 결제',  'Y', 3);


-- -----------------------------------------------------
-- SUB_STATUS : 구독 상태
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('SUB_STATUS_CD', 'NONE',     '미구독',   '구독 이력 없음 (FREE 회원)',                     'Y', 1),
('SUB_STATUS_CD', 'ACTIVE',   '구독중',   '정상 구독 진행 중',                             'Y', 2),
('SUB_STATUS_CD', 'EXPIRED',  '만료',     '구독 기간 종료 후 갱신하지 않은 상태',          'Y', 3),
('SUB_STATUS_CD', 'CANCELED', '해지',     '구독 기간 중 사용자가 직접 해지한 상태',        'Y', 4),
('SUB_STATUS_CD', 'PAUSED',   '일시정지', '구독을 일시적으로 멈춘 상태 (결제 유예 등)',    'Y', 5);


-- -----------------------------------------------------
-- SUB_PLAN : 구독 플랜
--   attr1 = 월 단위 금액(원, 참고용)
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `attr1`) VALUES
('SUB_PLAN_CD', 'MONTHLY',       '월간 개인',   '개인 회원 월간 구독 플랜',           'Y', 1, '9900'),
('SUB_PLAN_CD', 'ANNUAL',        '연간 개인',   '개인 회원 연간 구독 플랜 (할인)',    'Y', 2, '99000'),
('SUB_PLAN_CD', 'TRIAL',         '체험',        '신규 가입자 무료 체험 플랜',         'Y', 3, '0'),
('SUB_PLAN_CD', 'GROUP_MONTHLY', '월간 단체',   '단체 월간 구독 플랜',                'Y', 4, NULL),
('SUB_PLAN_CD', 'GROUP_ANNUAL',  '연간 단체',   '단체 연간 구독 플랜 (할인)',         'Y', 5, NULL);


-- -----------------------------------------------------
-- PAY_TYPE_CD 코드는 기본 공통코드 섹션에서 통합 관리


-- -----------------------------------------------------
-- GROUP_TYPE : 단체 유형
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('GROUP_TYPE_CD', 'SCHOOL',    '학교',   '초·중·고·대학교 등 교육기관',      'Y', 1),
('GROUP_TYPE_CD', 'COMPANY',   '기업',   '일반 기업체',                       'Y', 2),
('GROUP_TYPE_CD', 'INSTITUTE', '학원',   '학원·교습소 등 사설 교육기관',      'Y', 3),
('GROUP_TYPE_CD', 'ORG',       '기관',   '공공기관·비영리단체 등',            'Y', 4);


-- -----------------------------------------------------
-- CONTRACT_STATUS : 단체 계약 상태
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('CONTRACT_STATUS_CD', 'ACTIVE',   '계약중', '현재 유효한 계약이 진행 중인 상태',     'Y', 1),
('CONTRACT_STATUS_CD', 'EXPIRED',  '만료',   '계약 기간이 종료된 상태',               'Y', 2),
('CONTRACT_STATUS_CD', 'CANCELED', '해지',   '계약 기간 중 해지된 상태',              'Y', 3);


-- -----------------------------------------------------
-- GROUP_ROLE : 단체 내 역할
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('GROUP_ROLE_CD', 'ADMIN',  '단체관리자', '단체 구성원 관리 및 계약 대표 권한',   'Y', 1),
('GROUP_ROLE_CD', 'MEMBER', '일반구성원', '단체 소속 일반 회원',                  'Y', 2);


-- -----------------------------------------------------
-- MEMBER_STATUS : 회원 계정 상태 (tb_member.status_cd)
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('MEMBER_STATUS_CD', 'ACTIVE',    '정상',   '정상적으로 서비스를 이용할 수 있는 계정',                     'Y', 1),
('MEMBER_STATUS_CD', 'INACTIVE',  '비활성', '이메일 미인증 등으로 아직 활성화되지 않은 계정',              'Y', 2),
('MEMBER_STATUS_CD', 'DORMANT',   '휴면',   '장기 미접속(1년 이상)으로 휴면 전환된 계정',                  'Y', 3),
('MEMBER_STATUS_CD', 'WITHDRAWN', '탈퇴',   '회원이 탈퇴 처리한 계정 (데이터 보존 기간 내 soft delete)',  'Y', 4);


-- -----------------------------------------------------
-- MEMBER_GRADE : 회원 등급 (tb_member.grade_cd)
-- -----------------------------------------------------
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('MEMBER_GRADE_CD', 'NORMAL', '일반',     '기본 등급',                        'Y', 1),
('MEMBER_GRADE_CD', 'SILVER', '실버',     '중간 등급',                        'Y', 2),
('MEMBER_GRADE_CD', 'GOLD',   '골드',     '높은 등급',                        'Y', 3),
('MEMBER_GRADE_CD', 'VIP',    'VIP',      '최상위 등급',                      'Y', 4);


-- =====================================================
-- 포인트 / 경험치 공통코드는 point_ddl.sql, exp_ddl.sql 생성 시 추가 예정
-- =====================================================



-- =====================================================
-- 공통코드 추가 (common_code_ddl.sql에도 추가 권장)
-- sort_ord 32번부터 이어서 추가
-- =====================================================

INSERT INTO `tb_com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`) VALUES
('APP_TYPE_CD',   '앱 구분',     'tb_app_version.app_cd   — 안드로이드/iOS 구분',       'Y', 33),
('STORE_TYPE_CD', '스토어 구분', 'tb_app_version.store_cd — 앱 배포 스토어 구분',       'Y', 34);

-- APP_TYPE
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('APP_TYPE_CD', 'ANDROID', '안드로이드', '안드로이드 앱 (Google Play / ONE Store)', 'Y', 1),
('APP_TYPE_CD', 'IOS',     'iOS',        'Apple App Store 앱',                       'Y', 2);

-- STORE_TYPE
INSERT INTO `tb_com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('STORE_TYPE_CD', 'GOOGLE_PLAY', '구글 플레이', 'Google Play Store',   'Y', 1),
('STORE_TYPE_CD', 'APP_STORE',   '앱 스토어',   'Apple App Store',      'Y', 2),
('STORE_TYPE_CD', 'ONE_STORE',   '원스토어',    '원스토어 (국내)',       'Y', 3);




