-- ============================================================
-- 앱 API 클라이언트 자격증명 테이블
-- 앱 ↔ 서버 REST API 인증용 appId / appSecret 관리
-- appSecret 은 BCrypt 해시값만 저장 (원본 평문은 발급 시 1회 노출)
-- ============================================================
CREATE TABLE IF NOT EXISTS `app_client` (
    `app_id`      VARCHAR(50)   NOT NULL COMMENT '앱 클라이언트 식별자 (발급 키)',
    `app_nm`      VARCHAR(100)  NOT NULL COMMENT '앱 이름',
    `app_secret`  VARCHAR(255)  NOT NULL COMMENT 'BCrypt 해시된 시크릿',
    `use_yn`      CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부 (Y/N)',
    `memo`        VARCHAR(500)           DEFAULT NULL COMMENT '메모',
    `created_at`  DATETIME      NOT NULL DEFAULT NOW() COMMENT '등록일',
    `created_by`  VARCHAR(50)            DEFAULT NULL COMMENT '등록자',
    `updated_at`  DATETIME               DEFAULT NULL COMMENT '수정일',
    `updated_by`  VARCHAR(50)            DEFAULT NULL COMMENT '수정자',
    PRIMARY KEY (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='앱 API 클라이언트 자격증명';
