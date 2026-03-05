-- =============================================================
--  Spring Batch + Quartz Scheduler DDL  (MySQL / InnoDB)
--  Spring Batch  : 5.x 기준
--  Quartz        : 2.3.x 기준
-- =============================================================

-- 실행 전 기존 테이블/시퀀스 제거
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
--  [1] Spring Batch 메타 테이블
-- =====================================================

DROP TABLE IF EXISTS BATCH_STEP_EXECUTION_CONTEXT;
DROP TABLE IF EXISTS BATCH_JOB_EXECUTION_CONTEXT;
DROP TABLE IF EXISTS BATCH_STEP_EXECUTION;
DROP TABLE IF EXISTS BATCH_JOB_EXECUTION_PARAMS;
DROP TABLE IF EXISTS BATCH_JOB_EXECUTION;
DROP TABLE IF EXISTS BATCH_JOB_INSTANCE;

DROP TABLE IF EXISTS BATCH_STEP_EXECUTION_SEQ;
DROP TABLE IF EXISTS BATCH_JOB_EXECUTION_SEQ;
DROP TABLE IF EXISTS BATCH_JOB_SEQ;

-- -----------------------------------------------------
--  잡 인스턴스 (Job 실행 단위 식별)
-- -----------------------------------------------------
CREATE TABLE BATCH_JOB_INSTANCE (
    JOB_INSTANCE_ID   BIGINT         NOT NULL PRIMARY KEY COMMENT '잡 인스턴스 ID',
    VERSION           BIGINT                              COMMENT '낙관적 잠금 버전',
    JOB_NAME          VARCHAR(100)   NOT NULL             COMMENT '잡 이름',
    JOB_KEY           VARCHAR(32)    NOT NULL             COMMENT '잡 파라미터 해시',
    CONSTRAINT JOB_INST_UN UNIQUE (JOB_NAME, JOB_KEY)
) ENGINE=InnoDB COMMENT='Spring Batch 잡 인스턴스';

-- -----------------------------------------------------
--  잡 실행 (Job 한 번의 실행)
-- -----------------------------------------------------
CREATE TABLE BATCH_JOB_EXECUTION (
    JOB_EXECUTION_ID    BIGINT          NOT NULL PRIMARY KEY COMMENT '잡 실행 ID',
    VERSION             BIGINT                               COMMENT '낙관적 잠금 버전',
    JOB_INSTANCE_ID     BIGINT          NOT NULL             COMMENT '잡 인스턴스 ID',
    CREATE_TIME         DATETIME(6)     NOT NULL             COMMENT '생성 일시',
    START_TIME          DATETIME(6)                          COMMENT '시작 일시',
    END_TIME            DATETIME(6)                          COMMENT '종료 일시',
    STATUS              VARCHAR(10)                          COMMENT '실행 상태 (COMPLETED/FAILED 등)',
    EXIT_CODE           VARCHAR(2500)                        COMMENT '종료 코드',
    EXIT_MESSAGE        VARCHAR(2500)                        COMMENT '종료 메시지',
    LAST_UPDATED        DATETIME(6)                          COMMENT '최종 수정 일시',
    CONSTRAINT JOB_INST_EXEC_FK FOREIGN KEY (JOB_INSTANCE_ID)
        REFERENCES BATCH_JOB_INSTANCE (JOB_INSTANCE_ID)
) ENGINE=InnoDB COMMENT='Spring Batch 잡 실행';

-- -----------------------------------------------------
--  잡 실행 파라미터
-- -----------------------------------------------------
CREATE TABLE BATCH_JOB_EXECUTION_PARAMS (
    JOB_EXECUTION_ID  BIGINT        NOT NULL COMMENT '잡 실행 ID',
    PARAMETER_NAME    VARCHAR(100)  NOT NULL COMMENT '파라미터 명',
    PARAMETER_TYPE    VARCHAR(100)  NOT NULL COMMENT '파라미터 타입',
    PARAMETER_VALUE   VARCHAR(2500)          COMMENT '파라미터 값',
    IDENTIFYING       CHAR(1)       NOT NULL COMMENT '식별 파라미터 여부 (Y/N)',
    CONSTRAINT JOB_EXEC_PARAMS_FK FOREIGN KEY (JOB_EXECUTION_ID)
        REFERENCES BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
) ENGINE=InnoDB COMMENT='Spring Batch 잡 실행 파라미터';

-- -----------------------------------------------------
--  스텝 실행
-- -----------------------------------------------------
CREATE TABLE BATCH_STEP_EXECUTION (
    STEP_EXECUTION_ID   BIGINT         NOT NULL PRIMARY KEY COMMENT '스텝 실행 ID',
    VERSION             BIGINT         NOT NULL             COMMENT '낙관적 잠금 버전',
    STEP_NAME           VARCHAR(100)   NOT NULL             COMMENT '스텝 이름',
    JOB_EXECUTION_ID    BIGINT         NOT NULL             COMMENT '잡 실행 ID',
    CREATE_TIME         DATETIME(6)    NOT NULL             COMMENT '생성 일시',
    START_TIME          DATETIME(6)                         COMMENT '시작 일시',
    END_TIME            DATETIME(6)                         COMMENT '종료 일시',
    STATUS              VARCHAR(10)                         COMMENT '실행 상태',
    COMMIT_COUNT        BIGINT                              COMMENT '커밋 횟수',
    READ_COUNT          BIGINT                              COMMENT '읽기 건수',
    FILTER_COUNT        BIGINT                              COMMENT '필터 건수',
    WRITE_COUNT         BIGINT                              COMMENT '쓰기 건수',
    READ_SKIP_COUNT     BIGINT                              COMMENT '읽기 스킵 건수',
    WRITE_SKIP_COUNT    BIGINT                              COMMENT '쓰기 스킵 건수',
    PROCESS_SKIP_COUNT  BIGINT                              COMMENT '처리 스킵 건수',
    ROLLBACK_COUNT      BIGINT                              COMMENT '롤백 횟수',
    EXIT_CODE           VARCHAR(2500)                       COMMENT '종료 코드',
    EXIT_MESSAGE        VARCHAR(2500)                       COMMENT '종료 메시지',
    LAST_UPDATED        DATETIME(6)                         COMMENT '최종 수정 일시',
    CONSTRAINT JOB_EXEC_STEP_FK FOREIGN KEY (JOB_EXECUTION_ID)
        REFERENCES BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
) ENGINE=InnoDB COMMENT='Spring Batch 스텝 실행';

-- -----------------------------------------------------
--  잡 실행 컨텍스트 (재시작용 직렬화 데이터)
-- -----------------------------------------------------
CREATE TABLE BATCH_JOB_EXECUTION_CONTEXT (
    JOB_EXECUTION_ID   BIGINT         NOT NULL PRIMARY KEY COMMENT '잡 실행 ID',
    SHORT_CONTEXT      VARCHAR(2500)  NOT NULL             COMMENT '컨텍스트 요약',
    SERIALIZED_CONTEXT TEXT                                COMMENT '직렬화된 컨텍스트',
    CONSTRAINT JOB_EXEC_CTX_FK FOREIGN KEY (JOB_EXECUTION_ID)
        REFERENCES BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
) ENGINE=InnoDB COMMENT='Spring Batch 잡 실행 컨텍스트';

-- -----------------------------------------------------
--  스텝 실행 컨텍스트
-- -----------------------------------------------------
CREATE TABLE BATCH_STEP_EXECUTION_CONTEXT (
    STEP_EXECUTION_ID  BIGINT         NOT NULL PRIMARY KEY COMMENT '스텝 실행 ID',
    SHORT_CONTEXT      VARCHAR(2500)  NOT NULL             COMMENT '컨텍스트 요약',
    SERIALIZED_CONTEXT TEXT                                COMMENT '직렬화된 컨텍스트',
    CONSTRAINT STEP_EXEC_CTX_FK FOREIGN KEY (STEP_EXECUTION_ID)
        REFERENCES BATCH_STEP_EXECUTION (STEP_EXECUTION_ID)
) ENGINE=InnoDB COMMENT='Spring Batch 스텝 실행 컨텍스트';

-- -----------------------------------------------------
--  시퀀스 테이블 (AUTO_INCREMENT 대체)
-- -----------------------------------------------------
CREATE TABLE BATCH_STEP_EXECUTION_SEQ (
    ID         BIGINT        NOT NULL,
    UNIQUE_KEY CHAR(1)       NOT NULL,
    CONSTRAINT UNIQUE_KEY_UN UNIQUE (UNIQUE_KEY)
) ENGINE=InnoDB COMMENT='Spring Batch 스텝 실행 시퀀스';

INSERT INTO BATCH_STEP_EXECUTION_SEQ (ID, UNIQUE_KEY) SELECT * FROM (SELECT 0 AS ID, '0' AS UNIQUE_KEY) AS tmp
WHERE NOT EXISTS (SELECT * FROM BATCH_STEP_EXECUTION_SEQ);

CREATE TABLE BATCH_JOB_EXECUTION_SEQ (
    ID         BIGINT        NOT NULL,
    UNIQUE_KEY CHAR(1)       NOT NULL,
    CONSTRAINT UNIQUE_KEY_UN2 UNIQUE (UNIQUE_KEY)
) ENGINE=InnoDB COMMENT='Spring Batch 잡 실행 시퀀스';

INSERT INTO BATCH_JOB_EXECUTION_SEQ (ID, UNIQUE_KEY) SELECT * FROM (SELECT 0 AS ID, '0' AS UNIQUE_KEY) AS tmp
WHERE NOT EXISTS (SELECT * FROM BATCH_JOB_EXECUTION_SEQ);

CREATE TABLE BATCH_JOB_SEQ (
    ID         BIGINT        NOT NULL,
    UNIQUE_KEY CHAR(1)       NOT NULL,
    CONSTRAINT UNIQUE_KEY_UN3 UNIQUE (UNIQUE_KEY)
) ENGINE=InnoDB COMMENT='Spring Batch 잡 시퀀스';

INSERT INTO BATCH_JOB_SEQ (ID, UNIQUE_KEY) SELECT * FROM (SELECT 0 AS ID, '0' AS UNIQUE_KEY) AS tmp
WHERE NOT EXISTS (SELECT * FROM BATCH_JOB_SEQ);


-- =====================================================
--  [2] Quartz Scheduler 테이블
-- =====================================================

DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- -----------------------------------------------------
--  잡 상세 정보
-- -----------------------------------------------------
CREATE TABLE QRTZ_JOB_DETAILS (
    SCHED_NAME        VARCHAR(120)   NOT NULL COMMENT '스케줄러 이름',
    JOB_NAME          VARCHAR(200)   NOT NULL COMMENT '잡 이름',
    JOB_GROUP         VARCHAR(200)   NOT NULL COMMENT '잡 그룹',
    DESCRIPTION       VARCHAR(250)            COMMENT '설명',
    JOB_CLASS_NAME    VARCHAR(250)   NOT NULL COMMENT '잡 클래스 전체 경로',
    IS_DURABLE        VARCHAR(1)     NOT NULL COMMENT '트리거 없어도 유지 여부',
    IS_NONCONCURRENT  VARCHAR(1)     NOT NULL COMMENT '동시 실행 금지 여부',
    IS_UPDATE_DATA    VARCHAR(1)     NOT NULL COMMENT '실행 후 JobDataMap 갱신 여부',
    REQUESTS_RECOVERY VARCHAR(1)     NOT NULL COMMENT '복구 요청 여부',
    JOB_DATA          BLOB                    COMMENT '잡 데이터 (직렬화)',
    PRIMARY KEY (SCHED_NAME, JOB_NAME, JOB_GROUP)
) ENGINE=InnoDB COMMENT='Quartz 잡 상세';

-- -----------------------------------------------------
--  트리거 공통
-- -----------------------------------------------------
CREATE TABLE QRTZ_TRIGGERS (
    SCHED_NAME     VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    TRIGGER_NAME   VARCHAR(200)  NOT NULL COMMENT '트리거 이름',
    TRIGGER_GROUP  VARCHAR(200)  NOT NULL COMMENT '트리거 그룹',
    JOB_NAME       VARCHAR(200)  NOT NULL COMMENT '잡 이름',
    JOB_GROUP      VARCHAR(200)  NOT NULL COMMENT '잡 그룹',
    DESCRIPTION    VARCHAR(250)           COMMENT '설명',
    NEXT_FIRE_TIME BIGINT(13)             COMMENT '다음 실행 시간(ms)',
    PREV_FIRE_TIME BIGINT(13)             COMMENT '이전 실행 시간(ms)',
    PRIORITY       INTEGER                COMMENT '우선순위',
    TRIGGER_STATE  VARCHAR(16)   NOT NULL COMMENT '상태 (WAITING/ACQUIRED/EXECUTING 등)',
    TRIGGER_TYPE   VARCHAR(8)    NOT NULL COMMENT '트리거 타입 (SIMPLE/CRON 등)',
    START_TIME     BIGINT(13)    NOT NULL COMMENT '시작 시간(ms)',
    END_TIME       BIGINT(13)             COMMENT '종료 시간(ms)',
    CALENDAR_NAME  VARCHAR(200)           COMMENT '달력 이름',
    MISFIRE_INSTR  SMALLINT(2)            COMMENT '미실행 처리 방식',
    JOB_DATA       BLOB                   COMMENT '잡 데이터 (직렬화)',
    PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    CONSTRAINT QRTZ_TRIG_TO_JOB_FK FOREIGN KEY (SCHED_NAME, JOB_NAME, JOB_GROUP)
        REFERENCES QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP)
) ENGINE=InnoDB COMMENT='Quartz 트리거 공통';

-- -----------------------------------------------------
--  단순 트리거 (반복 횟수·간격)
-- -----------------------------------------------------
CREATE TABLE QRTZ_SIMPLE_TRIGGERS (
    SCHED_NAME      VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    TRIGGER_NAME    VARCHAR(200)  NOT NULL COMMENT '트리거 이름',
    TRIGGER_GROUP   VARCHAR(200)  NOT NULL COMMENT '트리거 그룹',
    REPEAT_COUNT    BIGINT(7)     NOT NULL COMMENT '반복 횟수',
    REPEAT_INTERVAL BIGINT(12)    NOT NULL COMMENT '반복 간격(ms)',
    TIMES_TRIGGERED BIGINT(10)    NOT NULL COMMENT '실행된 횟수',
    PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    CONSTRAINT QRTZ_SIMPLE_TRIG_FK FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
) ENGINE=InnoDB COMMENT='Quartz 단순 트리거';

-- -----------------------------------------------------
--  Cron 트리거
-- -----------------------------------------------------
CREATE TABLE QRTZ_CRON_TRIGGERS (
    SCHED_NAME      VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    TRIGGER_NAME    VARCHAR(200)  NOT NULL COMMENT '트리거 이름',
    TRIGGER_GROUP   VARCHAR(200)  NOT NULL COMMENT '트리거 그룹',
    CRON_EXPRESSION VARCHAR(120)  NOT NULL COMMENT 'Cron 표현식',
    TIME_ZONE_ID    VARCHAR(80)            COMMENT '타임존',
    PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    CONSTRAINT QRTZ_CRON_TRIG_FK FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
) ENGINE=InnoDB COMMENT='Quartz Cron 트리거';

-- -----------------------------------------------------
--  단순 속성 트리거 (CalendarIntervalTrigger 등)
-- -----------------------------------------------------
CREATE TABLE QRTZ_SIMPROP_TRIGGERS (
    SCHED_NAME    VARCHAR(120)   NOT NULL COMMENT '스케줄러 이름',
    TRIGGER_NAME  VARCHAR(200)   NOT NULL COMMENT '트리거 이름',
    TRIGGER_GROUP VARCHAR(200)   NOT NULL COMMENT '트리거 그룹',
    STR_PROP_1    VARCHAR(512)            COMMENT '문자열 속성 1',
    STR_PROP_2    VARCHAR(512)            COMMENT '문자열 속성 2',
    STR_PROP_3    VARCHAR(512)            COMMENT '문자열 속성 3',
    INT_PROP_1    INT                     COMMENT '정수 속성 1',
    INT_PROP_2    INT                     COMMENT '정수 속성 2',
    LONG_PROP_1   BIGINT                  COMMENT '정수(long) 속성 1',
    LONG_PROP_2   BIGINT                  COMMENT '정수(long) 속성 2',
    DEC_PROP_1    NUMERIC(13, 4)          COMMENT '소수 속성 1',
    DEC_PROP_2    NUMERIC(13, 4)          COMMENT '소수 속성 2',
    BOOL_PROP_1   VARCHAR(1)              COMMENT '불리언 속성 1',
    BOOL_PROP_2   VARCHAR(1)              COMMENT '불리언 속성 2',
    PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    CONSTRAINT QRTZ_SIMPROP_TRIG_FK FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
) ENGINE=InnoDB COMMENT='Quartz 단순 속성 트리거';

-- -----------------------------------------------------
--  Blob 트리거 (커스텀 트리거 직렬화)
-- -----------------------------------------------------
CREATE TABLE QRTZ_BLOB_TRIGGERS (
    SCHED_NAME    VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    TRIGGER_NAME  VARCHAR(200)  NOT NULL COMMENT '트리거 이름',
    TRIGGER_GROUP VARCHAR(200)  NOT NULL COMMENT '트리거 그룹',
    BLOB_DATA     BLOB                   COMMENT '직렬화된 트리거 데이터',
    PRIMARY KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    CONSTRAINT QRTZ_BLOB_TRIG_FK FOREIGN KEY (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
) ENGINE=InnoDB COMMENT='Quartz Blob 트리거';

-- -----------------------------------------------------
--  달력 (실행 제외일 정의)
-- -----------------------------------------------------
CREATE TABLE QRTZ_CALENDARS (
    SCHED_NAME    VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    CALENDAR_NAME VARCHAR(200)  NOT NULL COMMENT '달력 이름',
    CALENDAR      BLOB          NOT NULL COMMENT '직렬화된 달력 데이터',
    PRIMARY KEY (SCHED_NAME, CALENDAR_NAME)
) ENGINE=InnoDB COMMENT='Quartz 달력';

-- -----------------------------------------------------
--  일시 정지된 트리거 그룹
-- -----------------------------------------------------
CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (
    SCHED_NAME    VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    TRIGGER_GROUP VARCHAR(200)  NOT NULL COMMENT '정지된 트리거 그룹',
    PRIMARY KEY (SCHED_NAME, TRIGGER_GROUP)
) ENGINE=InnoDB COMMENT='Quartz 일시 정지 트리거 그룹';

-- -----------------------------------------------------
--  실행 중인 트리거 (클러스터 상태 관리)
-- -----------------------------------------------------
CREATE TABLE QRTZ_FIRED_TRIGGERS (
    SCHED_NAME        VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    ENTRY_ID          VARCHAR(95)   NOT NULL COMMENT '실행 항목 ID',
    TRIGGER_NAME      VARCHAR(200)  NOT NULL COMMENT '트리거 이름',
    TRIGGER_GROUP     VARCHAR(200)  NOT NULL COMMENT '트리거 그룹',
    INSTANCE_NAME     VARCHAR(200)  NOT NULL COMMENT '스케줄러 인스턴스 이름',
    FIRED_TIME        BIGINT(13)    NOT NULL COMMENT '실행 시각(ms)',
    SCHED_TIME        BIGINT(13)    NOT NULL COMMENT '예약 시각(ms)',
    PRIORITY          INTEGER       NOT NULL COMMENT '우선순위',
    STATE             VARCHAR(16)   NOT NULL COMMENT '상태',
    JOB_NAME          VARCHAR(200)           COMMENT '잡 이름',
    JOB_GROUP         VARCHAR(200)           COMMENT '잡 그룹',
    IS_NONCONCURRENT  VARCHAR(1)             COMMENT '동시 실행 금지 여부',
    REQUESTS_RECOVERY VARCHAR(1)             COMMENT '복구 요청 여부',
    PRIMARY KEY (SCHED_NAME, ENTRY_ID)
) ENGINE=InnoDB COMMENT='Quartz 실행 중인 트리거';

-- -----------------------------------------------------
--  스케줄러 상태 (클러스터 Heart-beat)
-- -----------------------------------------------------
CREATE TABLE QRTZ_SCHEDULER_STATE (
    SCHED_NAME        VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    INSTANCE_NAME     VARCHAR(200)  NOT NULL COMMENT '인스턴스 이름',
    LAST_CHECKIN_TIME BIGINT(13)    NOT NULL COMMENT '마지막 체크인 시각(ms)',
    CHECKIN_INTERVAL  BIGINT(13)    NOT NULL COMMENT '체크인 간격(ms)',
    PRIMARY KEY (SCHED_NAME, INSTANCE_NAME)
) ENGINE=InnoDB COMMENT='Quartz 스케줄러 상태 (클러스터)';

-- -----------------------------------------------------
--  분산 락 (클러스터 동기화)
-- -----------------------------------------------------
CREATE TABLE QRTZ_LOCKS (
    SCHED_NAME VARCHAR(120)  NOT NULL COMMENT '스케줄러 이름',
    LOCK_NAME  VARCHAR(40)   NOT NULL COMMENT '락 이름 (TRIGGER_ACCESS / STATE_ACCESS 등)',
    PRIMARY KEY (SCHED_NAME, LOCK_NAME)
) ENGINE=InnoDB COMMENT='Quartz 분산 락';

-- 기본 락 데이터 삽입
INSERT INTO QRTZ_LOCKS (SCHED_NAME, LOCK_NAME) VALUES
    ('DefaultQuartzScheduler', 'TRIGGER_ACCESS'),
    ('DefaultQuartzScheduler', 'JOB_ACCESS'),
    ('DefaultQuartzScheduler', 'CALENDAR_ACCESS'),
    ('DefaultQuartzScheduler', 'STATE_ACCESS'),
    ('DefaultQuartzScheduler', 'MISFIRE_ACCESS');

-- -----------------------------------------------------
--  성능 인덱스
-- -----------------------------------------------------
CREATE INDEX IDX_QRTZ_J_REQ_RECOVERY  ON QRTZ_JOB_DETAILS (SCHED_NAME, REQUESTS_RECOVERY);
CREATE INDEX IDX_QRTZ_J_GRP           ON QRTZ_JOB_DETAILS (SCHED_NAME, JOB_GROUP);

CREATE INDEX IDX_QRTZ_T_J             ON QRTZ_TRIGGERS (SCHED_NAME, JOB_NAME, JOB_GROUP);
CREATE INDEX IDX_QRTZ_T_JG            ON QRTZ_TRIGGERS (SCHED_NAME, JOB_GROUP);
CREATE INDEX IDX_QRTZ_T_C             ON QRTZ_TRIGGERS (SCHED_NAME, CALENDAR_NAME);
CREATE INDEX IDX_QRTZ_T_G             ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_GROUP);
CREATE INDEX IDX_QRTZ_T_STATE         ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_N_STATE       ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_N_G_STATE     ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_GROUP, TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_NEXT_FIRE     ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE, NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_ST        ON QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE, NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_MISFIRE   ON QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME);
CREATE INDEX IDX_QRTZ_T_NFT_ST_MISFIRE ON QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_STATE);
CREATE INDEX IDX_QRTZ_T_NFT_ST_MISFIRE_GRP ON QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_GROUP, TRIGGER_STATE);

CREATE INDEX IDX_QRTZ_FT_TRIG_INST_NAME ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, INSTANCE_NAME);
CREATE INDEX IDX_QRTZ_FT_INST_JOB_REQ_RCVRY ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, INSTANCE_NAME, REQUESTS_RECOVERY);
CREATE INDEX IDX_QRTZ_FT_J_G            ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, JOB_NAME, JOB_GROUP);
CREATE INDEX IDX_QRTZ_FT_JG             ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, JOB_GROUP);
CREATE INDEX IDX_QRTZ_FT_T_G            ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);
CREATE INDEX IDX_QRTZ_FT_TG             ON QRTZ_FIRED_TRIGGERS (SCHED_NAME, TRIGGER_GROUP);

SET FOREIGN_KEY_CHECKS = 1;
