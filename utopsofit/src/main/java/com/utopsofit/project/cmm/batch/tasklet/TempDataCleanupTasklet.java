package com.utopsofit.project.cmm.batch.tasklet;

import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.StepContribution;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.infrastructure.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

/**
 * 임시 데이터 정리 Tasklet
 *
 * 보존 기간(retentionDays)이 경과한 임시 데이터를 삭제한다.
 * 실제 업무에서는 Mapper를 주입받아 DB 삭제 쿼리로 교체한다.
 *
 * application.properties:
 *   batch.tempDataCleanup.retentionDays=30   # 보존 기간 (기본 30일)
 */
@Slf4j
@Component
public class TempDataCleanupTasklet implements Tasklet {

    @Value("${batch.tempDataCleanup.retentionDays:30}")
    private int retentionDays;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) {

        String jobName   = chunkContext.getStepContext().getJobName();
        LocalDate cutoff = LocalDate.now().minusDays(retentionDays);

        log.info("===== [{}] 임시 데이터 정리 배치 시작 =====", jobName);
        log.info("  보존 기간 : {} 일 / 기준일 : {} 이전 데이터 정리", retentionDays, cutoff);

        /* 실제 구현 예시:
         *   int deleted = tempDataMapper.deleteExpired(cutoff);
         *   contribution.incrementWriteCount(deleted);
         */
        log.info("  [샘플] 임시 파일 정리 완료 (실제 구현 시 Mapper 호출로 교체)");
        log.info("===== [{}] 임시 데이터 정리 배치 종료 =====", jobName);

        return RepeatStatus.FINISHED;
    }
}
