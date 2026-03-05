package com.utopsofit.project.cmm.batch.scheduler;

import org.springframework.batch.core.job.Job;
import org.springframework.batch.core.job.parameters.JobParameters;
import org.springframework.batch.core.job.parameters.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Spring Batch 스케줄러
 *
 * ┌──────────────────────────────────────────────────────────────────────────┐
 * │  application.properties 제어 항목                                        │
 * │                                                                          │
 * │  batch.lockInactiveUsr.enabled      = true/false  # 잠금 배치 활성화     │
 * │  batch.lockInactiveUsr.cron         = 크론 표현식  # 잠금 배치 실행 주기  │
 * │  batch.lockInactiveUsr.inactiveDays = 숫자         # 미접속 기준 일수     │
 * │                                                                          │
 * │  batch.tempDataCleanup.enabled      = true/false  # 정리 배치 활성화     │
 * │  batch.tempDataCleanup.cron         = 크론 표현식  # 정리 배치 실행 주기  │
 * │  batch.tempDataCleanup.retentionDays = 숫자        # 임시 데이터 보존 일수│
 * └──────────────────────────────────────────────────────────────────────────┘
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class BatchScheduler {

    private final JobLauncher jobLauncher;

    @Qualifier("lockInactiveUsrJob")
    private final Job lockInactiveUsrJob;

    @Qualifier("tempDataCleanupJob")
    private final Job tempDataCleanupJob;

    /* ── properties 주입 ────────────────────────────────────────────── */

    @Value("${batch.lockInactiveUsr.enabled:true}")
    private boolean lockInactiveUsrEnabled;

    @Value("${batch.tempDataCleanup.enabled:true}")
    private boolean tempDataCleanupEnabled;

    /* ── 장기 미접속 계정 잠금 스케줄 ─────────────────────────────── */

    @Scheduled(cron = "${batch.lockInactiveUsr.cron}")
    public void runLockInactiveUsrJob() {
        if (!lockInactiveUsrEnabled) {
            log.info("[BatchScheduler] lockInactiveUsrJob 비활성화 – 실행 건너뜀");
            return;
        }
        launch(lockInactiveUsrJob, "lockInactiveUsrJob",
               new JobParametersBuilder()
                       .addString("requestAt", nowString())
                       .toJobParameters());
    }

    /* ── 임시 데이터 정리 스케줄 ──────────────────────────────────── */

    @Scheduled(cron = "${batch.tempDataCleanup.cron}")
    public void runTempDataCleanupJob() {
        if (!tempDataCleanupEnabled) {
            log.info("[BatchScheduler] tempDataCleanupJob 비활성화 – 실행 건너뜀");
            return;
        }
        launch(tempDataCleanupJob, "tempDataCleanupJob",
               new JobParametersBuilder()
                       .addString("requestAt", nowString())
                       .toJobParameters());
    }

    /* ── 공통 실행 헬퍼 ────────────────────────────────────────────── */

    private void launch(Job job, String jobName, JobParameters params) {
        try {
            log.info("[BatchScheduler] {} 실행 시작", jobName);
            var execution = jobLauncher.run(job, params);
            log.info("[BatchScheduler] {} 실행 완료 – status={}", jobName, execution.getStatus());
        } catch (Exception e) {
            log.error("[BatchScheduler] {} 실행 실패 – {}", jobName, e.getMessage(), e);
        }
    }

    private String nowString() {
        return java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }
}
