-- =====================================================
-- 공통코드 DDL (MySQL 8.x)
-- 스키마: utopsoft
-- =====================================================

USE `utopsoft`;

-- -----------------------------------------------------
-- 1. 공통코드 그룹 (코드 유형 마스터)
-- -----------------------------------------------------
DROP TABLE IF EXISTS `com_code_grp`;
CREATE TABLE `com_code_grp` (
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
DROP TABLE IF EXISTS `com_code`;
CREATE TABLE `com_code` (
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
    CONSTRAINT `fk_com_code_grp` FOREIGN KEY (`grp_cd`) REFERENCES `com_code_grp` (`grp_cd`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공통코드';


-- -----------------------------------------------------
-- 샘플 데이터 (페이징 테스트용, 20개 그룹 + 그룹별 코드)
-- -----------------------------------------------------
INSERT INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`) VALUES
('GENDER', '성별', '회원 성별', 'Y', 1),
('YN', '예/아니오', '사용여부', 'Y', 2),
('STATUS', '상태', '일반 상태 코드', 'Y', 3),
('PAY_TYPE', '결제수단', '결제 유형', 'Y', 4),
('ORDER_STAT', '주문상태', '주문 진행 상태', 'Y', 5),
('BOARD_TYPE', '게시판유형', '게시판 종류', 'Y', 6),
('NOTI_TYPE', '알림유형', '알림 구분', 'Y', 7),
('USER_GRADE', '회원등급', '회원 등급', 'Y', 8),
('DELIVERY', '배송방식', '배송 방법', 'Y', 9),
('CATE_L', '대분류', '상품 대분류', 'Y', 10),
('CATE_M', '중분류', '상품 중분류', 'Y', 11),
('REGION', '지역', '지역 코드', 'Y', 12),
('CURRENCY', '통화', '통화 단위', 'Y', 13),
('LANG', '언어', '지원 언어', 'Y', 14),
('THEME', '테마', 'UI 테마', 'Y', 15),
('SIZE', '사이즈', '의류/신발 사이즈', 'Y', 16),
('COLOR', '색상', '색상 코드', 'Y', 17),
('BRAND', '브랜드', '브랜드 구분', 'Y', 18),
('CHANNEL', '채널', '유입 채널', 'Y', 19),
('FAQ_TYPE', 'FAQ유형', '자주묻는질문 유형', 'Y', 20);

INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `use_yn`, `sort_ord`) VALUES
('GENDER', 'M', '남', 'Y', 1),
('GENDER', 'F', '여', 'Y', 2),
('YN', 'Y', '예', 'Y', 1),
('YN', 'N', '아니오', 'Y', 2),
('STATUS', 'ACT', '활성', 'Y', 1),
('STATUS', 'INA', '비활성', 'Y', 2),
('STATUS', 'DEL', '삭제', 'Y', 3),
('PAY_TYPE', 'CARD', '카드', 'Y', 1),
('PAY_TYPE', 'BANK', '계좌이체', 'Y', 2),
('PAY_TYPE', 'CASH', '현금', 'Y', 3),
('ORDER_STAT', 'ORDER', '주문접수', 'Y', 1),
('ORDER_STAT', 'PAID', '결제완료', 'Y', 2),
('ORDER_STAT', 'SHIP', '배송중', 'Y', 3),
('ORDER_STAT', 'DONE', '완료', 'Y', 4),
('BOARD_TYPE', 'NOTICE', '공지', 'Y', 1),
('BOARD_TYPE', 'QNA', 'Q&A', 'Y', 2),
('BOARD_TYPE', 'FREE', '자유게시판', 'Y', 3),
('NOTI_TYPE', 'SMS', '문자', 'Y', 1),
('NOTI_TYPE', 'EMAIL', '이메일', 'Y', 2),
('NOTI_TYPE', 'PUSH', '푸시', 'Y', 3),
('USER_GRADE', 'NORMAL', '일반', 'Y', 1),
('USER_GRADE', 'SILVER', '실버', 'Y', 2),
('USER_GRADE', 'GOLD', '골드', 'Y', 3),
('USER_GRADE', 'VIP', 'VIP', 'Y', 4),
('DELIVERY', 'PARCEL', '택배', 'Y', 1),
('DELIVERY', 'DIRECT', '직접배송', 'Y', 2),
('DELIVERY', 'STORE', '매장수령', 'Y', 3),
('CATE_L', 'ELEC', '전자제품', 'Y', 1),
('CATE_L', 'FASHION', '패션', 'Y', 2),
('CATE_L', 'FOOD', '식품', 'Y', 3),
('CATE_M', 'PHONE', '휴대폰', 'Y', 1),
('CATE_M', 'NOTE', '노트북', 'Y', 2),
('REGION', 'SEOUL', '서울', 'Y', 1),
('REGION', 'GYEONG', '경기', 'Y', 2),
('REGION', 'INCHEON', '인천', 'Y', 3),
('CURRENCY', 'KRW', '원', 'Y', 1),
('CURRENCY', 'USD', '달러', 'Y', 2),
('LANG', 'KO', '한국어', 'Y', 1),
('LANG', 'EN', '영어', 'Y', 2),
('THEME', 'LIGHT', '라이트', 'Y', 1),
('THEME', 'DARK', '다크', 'Y', 2),
('SIZE', 'S', 'Small', 'Y', 1),
('SIZE', 'M', 'Medium', 'Y', 2),
('SIZE', 'L', 'Large', 'Y', 3),
('COLOR', 'BLK', '블랙', 'Y', 1),
('COLOR', 'WHT', '화이트', 'Y', 2),
('COLOR', 'RED', '레드', 'Y', 3),
('CHANNEL', 'WEB', '웹', 'Y', 1),
('CHANNEL', 'MOBILE', '모바일', 'Y', 2),
('CHANNEL', 'APP', '앱', 'Y', 3),
('FAQ_TYPE', 'ORDER', '주문/결제', 'Y', 1),
('FAQ_TYPE', 'DELIVERY', '배송', 'Y', 2),
('FAQ_TYPE', 'RETURN', '반품/교환', 'Y', 3);


-- =====================================================
-- 회원 관련 공통코드 (member_ddl 연관)
-- sort_ord 21번부터 이어서 추가
-- =====================================================

-- -----------------------------------------------------
-- 그룹 추가
-- -----------------------------------------------------
INSERT INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`) VALUES
('SOCIAL_TYPE',      '소셜로그인유형', 'member.social_type — 소셜 로그인 플랫폼 구분',                       'Y', 21),
('MEMBERSHIP_TYPE',  '회원유형',       'member.membership_type — 무료/유료개인/단체유료 구분',               'Y', 22),
('SUB_STATUS',       '구독상태',       'member.sub_status — 구독 진행 상태 구분',                            'Y', 23),
('SUB_PLAN',         '구독플랜',       'member.sub_plan_cd — 구독 플랜(주기/유형) 구분',                     'Y', 24),
('GROUP_TYPE',       '단체유형',       'member_group.group_type — 소속 단체 종류 구분',                      'Y', 25),
('CONTRACT_STATUS',  '계약상태',       'member_group.contract_status — 단체 계약 진행 상태 구분',            'Y', 26),
('GROUP_ROLE',       '단체역할',       'member.group_role — 단체 내 구성원 역할 구분',                       'Y', 27),
('MEMBER_STATUS',    '계정상태',       'member.status_cd — 회원 계정 활성 상태 구분',                        'Y', 28);


-- -----------------------------------------------------
-- SOCIAL_TYPE : 소셜 로그인 유형
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('SOCIAL_TYPE', 'NONE',   '일반',     '소셜 연동 없이 자체 ID/PW로 가입한 회원', 'Y', 1),
('SOCIAL_TYPE', 'GOOGLE', '구글',     'Google 소셜 로그인',                       'Y', 2),
('SOCIAL_TYPE', 'APPLE',  '애플',     'Apple 소셜 로그인',                        'Y', 3),
('SOCIAL_TYPE', 'KAKAO',  '카카오',   'Kakao 소셜 로그인',                        'Y', 4),
('SOCIAL_TYPE', 'NAVER',  '네이버',   'Naver 소셜 로그인',                        'Y', 5);


-- -----------------------------------------------------
-- MEMBERSHIP_TYPE : 회원 유형
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('MEMBERSHIP_TYPE', 'FREE',  '무료회원',     '기본 콘텐츠 이용 가능, 구독 없음',             'Y', 1),
('MEMBERSHIP_TYPE', 'PAID',  '유료개인회원', '개인 구독 플랜 결제 회원',                     'Y', 2),
('MEMBERSHIP_TYPE', 'GROUP', '단체유료회원', '단체(member_group) 소속, 단체에서 일괄 결제',  'Y', 3);


-- -----------------------------------------------------
-- SUB_STATUS : 구독 상태
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('SUB_STATUS', 'NONE',     '미구독',   '구독 이력 없음 (FREE 회원)',                     'Y', 1),
('SUB_STATUS', 'ACTIVE',   '구독중',   '정상 구독 진행 중',                             'Y', 2),
('SUB_STATUS', 'EXPIRED',  '만료',     '구독 기간 종료 후 갱신하지 않은 상태',          'Y', 3),
('SUB_STATUS', 'CANCELED', '해지',     '구독 기간 중 사용자가 직접 해지한 상태',        'Y', 4),
('SUB_STATUS', 'PAUSED',   '일시정지', '구독을 일시적으로 멈춘 상태 (결제 유예 등)',    'Y', 5);


-- -----------------------------------------------------
-- SUB_PLAN : 구독 플랜
--   attr1 = 월 단위 금액(원, 참고용)
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `attr1`) VALUES
('SUB_PLAN', 'MONTHLY',       '월간 개인',   '개인 회원 월간 구독 플랜',           'Y', 1, '9900'),
('SUB_PLAN', 'ANNUAL',        '연간 개인',   '개인 회원 연간 구독 플랜 (할인)',    'Y', 2, '99000'),
('SUB_PLAN', 'TRIAL',         '체험',        '신규 가입자 무료 체험 플랜',         'Y', 3, '0'),
('SUB_PLAN', 'GROUP_MONTHLY', '월간 단체',   '단체 월간 구독 플랜',                'Y', 4, NULL),
('SUB_PLAN', 'GROUP_ANNUAL',  '연간 단체',   '단체 연간 구독 플랜 (할인)',         'Y', 5, NULL);


-- -----------------------------------------------------
-- PAY_TYPE 추가 : 간편결제 수단
-- (기존 CARD, BANK, CASH 이후 이어서 추가)
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('PAY_TYPE', 'KAKAO_PAY',  '카카오페이', '카카오페이 간편결제',  'Y', 4),
('PAY_TYPE', 'NAVER_PAY',  '네이버페이', '네이버페이 간편결제',  'Y', 5),
('PAY_TYPE', 'APPLE_PAY',  '애플페이',   'Apple Pay 간편결제',   'Y', 6);


-- -----------------------------------------------------
-- GROUP_TYPE : 단체 유형
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('GROUP_TYPE', 'SCHOOL',    '학교',   '초·중·고·대학교 등 교육기관',      'Y', 1),
('GROUP_TYPE', 'COMPANY',   '기업',   '일반 기업체',                       'Y', 2),
('GROUP_TYPE', 'INSTITUTE', '학원',   '학원·교습소 등 사설 교육기관',      'Y', 3),
('GROUP_TYPE', 'ORG',       '기관',   '공공기관·비영리단체 등',            'Y', 4);


-- -----------------------------------------------------
-- CONTRACT_STATUS : 단체 계약 상태
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('CONTRACT_STATUS', 'ACTIVE',   '계약중', '현재 유효한 계약이 진행 중인 상태',     'Y', 1),
('CONTRACT_STATUS', 'EXPIRED',  '만료',   '계약 기간이 종료된 상태',               'Y', 2),
('CONTRACT_STATUS', 'CANCELED', '해지',   '계약 기간 중 해지된 상태',              'Y', 3);


-- -----------------------------------------------------
-- GROUP_ROLE : 단체 내 역할
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('GROUP_ROLE', 'ADMIN',  '단체관리자', '단체 구성원 관리 및 계약 대표 권한',   'Y', 1),
('GROUP_ROLE', 'MEMBER', '일반구성원', '단체 소속 일반 회원',                  'Y', 2);


-- -----------------------------------------------------
-- MEMBER_STATUS : 회원 계정 상태
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('MEMBER_STATUS', 'ACTIVE',    '정상',   '정상적으로 서비스를 이용할 수 있는 계정',                     'Y', 1),
('MEMBER_STATUS', 'INACTIVE',  '비활성', '이메일 미인증 등으로 아직 활성화되지 않은 계정',              'Y', 2),
('MEMBER_STATUS', 'DORMANT',   '휴면',   '장기 미접속(1년 이상)으로 휴면 전환된 계정',                  'Y', 3),
('MEMBER_STATUS', 'WITHDRAWN', '탈퇴',   '회원이 탈퇴 처리한 계정 (데이터 보존 기간 내 soft delete)', 'Y', 4);


-- =====================================================
-- 포인트 / 경험치 공통코드 (point_ddl, exp_ddl 연관)
-- sort_ord 29번부터 이어서 추가
-- =====================================================

-- -----------------------------------------------------
-- 그룹 추가
-- -----------------------------------------------------
INSERT INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`) VALUES
('POINT_TRAN_TYPE', '포인트 거래유형',  'point_hist.tran_type — 포인트 적립/사용/만료/취소 구분',   'Y', 29),
('POINT_REF_TYPE',  '포인트 발생원인',  'point_hist.ref_type  — 포인트 변동이 발생한 원인 유형',    'Y', 30),
('EXP_EARN_TYPE',   '경험치 획득원인',  'exp_hist.earn_type   — 경험치 획득이 발생한 원인 유형',    'Y', 31);


-- -----------------------------------------------------
-- POINT_TRAN_TYPE : 포인트 거래유형
--   attr1 = 부호 (+ 적립 / - 차감)
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `attr1`) VALUES
('POINT_TRAN_TYPE', 'EARN',   '적립', '학습·챌린지·출석 등 활동으로 포인트 획득',          'Y', 1, '+'),
('POINT_TRAN_TYPE', 'USE',    '사용', '강좌 구매, 아이템 교환 등에 포인트 차감',           'Y', 2, '-'),
('POINT_TRAN_TYPE', 'EXPIRE', '만료', '유효기간 초과로 포인트 자동 소멸',                  'Y', 3, '-'),
('POINT_TRAN_TYPE', 'CANCEL', '취소', '결제 취소·환불 등으로 거래 취소 처리',              'Y', 4, '+');


-- -----------------------------------------------------
-- POINT_REF_TYPE : 포인트 발생원인
--   attr1 = 기본 지급/차감 포인트(참고용, 실제 값은 point_hist에서 관리)
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `attr1`) VALUES
('POINT_REF_TYPE', 'LESSON',    '학습완료',    '강좌 또는 콘텐츠 학습을 완료했을 때 적립',    'Y', 1, '200'),
('POINT_REF_TYPE', 'CHALLENGE', '챌린지',      '챌린지 목표 달성 시 적립',                    'Y', 2, '300'),
('POINT_REF_TYPE', 'ATTEND',    '출석',        '일일 출석 체크 시 적립',                      'Y', 3, '100'),
('POINT_REF_TYPE', 'PURCHASE',  '구매사용',    '강좌·아이템 구매에 포인트 차감',              'Y', 4, NULL),
('POINT_REF_TYPE', 'ADMIN',     '관리자조정',  '관리자 수동 지급 또는 차감',                  'Y', 5, NULL),
('POINT_REF_TYPE', 'EXPIRE',    '기간만료',    '유효기간 경과로 자동 차감 처리',              'Y', 6, NULL);


-- -----------------------------------------------------
-- EXP_EARN_TYPE : 경험치 획득원인
--   attr1 = 기본 지급 경험치(참고용, 실제 값은 exp_hist에서 관리)
--   ※ 경험치는 차감 없음 — 획득(EARN)만 존재
-- -----------------------------------------------------
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`, `attr1`) VALUES
('EXP_EARN_TYPE', 'LESSON',    '학습완료',    '강좌 또는 콘텐츠 학습을 완료했을 때 획득',    'Y', 1, '200'),
('EXP_EARN_TYPE', 'CHALLENGE', '챌린지',      '챌린지 목표 달성 시 획득',                    'Y', 2, '300'),
('EXP_EARN_TYPE', 'ATTEND',    '출석',        '일일 출석 체크 시 획득',                      'Y', 3, '50'),
('EXP_EARN_TYPE', 'QUIZ',      '퀴즈',        '퀴즈 완료 및 정답률에 따라 획득',             'Y', 4, '100'),
('EXP_EARN_TYPE', 'REVIEW',    '복습',        '이전 학습 콘텐츠 복습 완료 시 획득',          'Y', 5, '80'),
('EXP_EARN_TYPE', 'ADMIN',     '관리자조정',  '관리자 수동 지급',                            'Y', 6, NULL);



-- =====================================================
-- 공통코드 추가 (common_code_ddl.sql에도 추가 권장)
-- sort_ord 32번부터 이어서 추가
-- =====================================================

INSERT INTO `com_code_grp` (`grp_cd`, `grp_nm`, `grp_desc`, `use_yn`, `sort_ord`) VALUES
('APP_TYPE',   '앱 구분',   'app_version.app_type   — 안드로이드/iOS 구분',       'Y', 32),
('STORE_TYPE', '스토어 구분', 'app_version.store_type — 앱 배포 스토어 구분',     'Y', 33);

-- APP_TYPE
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('APP_TYPE', 'ANDROID', '안드로이드', '안드로이드 앱 (Google Play / ONE Store)', 'Y', 1),
('APP_TYPE', 'IOS',     'iOS',        'Apple App Store 앱',                       'Y', 2);

-- STORE_TYPE
INSERT INTO `com_code` (`grp_cd`, `code`, `code_nm`, `code_desc`, `use_yn`, `sort_ord`) VALUES
('STORE_TYPE', 'GOOGLE_PLAY', '구글 플레이', 'Google Play Store',   'Y', 1),
('STORE_TYPE', 'APP_STORE',   '앱 스토어',   'Apple App Store',      'Y', 2),
('STORE_TYPE', 'ONE_STORE',   '원스토어',    '원스토어 (국내)',       'Y', 3);




