package com.utopsofit.project.cmm.batch.config;

import com.utopsofit.project.cmm.batch.tasklet.LockInactiveUsrTasklet;
import com.utopsofit.project.cmm.batch.tasklet.TempDataCleanupTasklet;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.core.job.Job;
import org.springframework.batch.core.step.Step;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

/**
 * Spring Batch Job / Step 빈 등록
 *
 * lockInactiveUsrJob  : 장기 미접속(60일↑) 사용자 계정 잠금
 * tempDataCleanupJob  : 임시 데이터 정리
 *
 * 실행 스케줄 및 활성화 여부는 BatchScheduler + application.properties 로 제어한다.
 */
@Configuration
@RequiredArgsConstructor
public class BatchJobConfig {

    private final JobRepository              jobRepository;
    private final PlatformTransactionManager transactionManager;
    private final LockInactiveUsrTasklet     lockInactiveUsrTasklet;
    private final TempDataCleanupTasklet     tempDataCleanupTasklet;

    /* ------------------------------------------------------------------ */
    /*  Job1 – 장기 미접속 사용자 계정 잠금                                  */
    /* ------------------------------------------------------------------ */

    @Bean
    public Job lockInactiveUsrJob() {
        return new JobBuilder("lockInactiveUsrJob", jobRepository)
                .start(lockInactiveUsrStep())
                .build();
    }

    @Bean
    public Step lockInactiveUsrStep() {
        return new StepBuilder("lockInactiveUsrStep", jobRepository)
                .tasklet(lockInactiveUsrTasklet, transactionManager)
                .build();
    }

    /* ------------------------------------------------------------------ */
    /*  Job2 – 임시 데이터 정리                                             */
    /* ------------------------------------------------------------------ */

    @Bean
    public Job tempDataCleanupJob() {
        return new JobBuilder("tempDataCleanupJob", jobRepository)
                .start(tempDataCleanupStep())
                .build();
    }

    @Bean
    public Step tempDataCleanupStep() {
        return new StepBuilder("tempDataCleanupStep", jobRepository)
                .tasklet(tempDataCleanupTasklet, transactionManager)
                .build();
    }
}
