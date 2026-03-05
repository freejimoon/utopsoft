package com.utopsofit.project.cmm.batch.tasklet;

import com.utopsofit.project.portal.login.dao.UsrMapper;
import com.utopsofit.project.portal.login.domain.Usr;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.StepContribution;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.infrastructure.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 장기 미접속 사용자 계정 잠금 Tasklet
 *
 * 마지막 로그인(last_login_dt)이 설정 일수(inactiveDays) 이상 경과한
 * 활성(use_yn=Y) 미잠금(lock_yn=N) 사용자를 일괄 잠금(lock_yn=Y) 처리한다.
 *
 * application.properties:
 *   batch.lockInactiveUsr.inactiveDays=60   # 기준 일수 (기본 60일)
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class LockInactiveUsrTasklet implements Tasklet {

    private final UsrMapper usrMapper;

    @Value("${batch.lockInactiveUsr.inactiveDays:60}")
    private int inactiveDays;

    @Override
    public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) {

        String jobName = chunkContext.getStepContext().getJobName();

        log.info("===== [{}] 장기 미접속 계정 잠금 배치 시작 =====", jobName);
        log.info("  기준 일수 : 마지막 로그인 {} 일 이상 경과", inactiveDays);

        /* 1. 잠금 대상 사용자 조회 */
        List<Usr> targets = usrMapper.selectInactiveUsrs(inactiveDays);

        if (targets.isEmpty()) {
            log.info("  잠금 대상 사용자 없음 – 배치 종료");
            log.info("===== [{}] 장기 미접속 계정 잠금 배치 종료 =====", jobName);
            return RepeatStatus.FINISHED;
        }

        log.info("  잠금 대상 사용자 수 : {} 명", targets.size());
        for (Usr usr : targets) {
            log.info("  [대상] usrId={}, usrNm={}, lastLoginDt={}",
                    usr.getUsrId(), usr.getUsrNm(), usr.getLastLoginDt());
        }

        /* 2. 일괄 잠금 처리 */
        int lockedCount = usrMapper.lockInactiveUsrs(inactiveDays);

        log.info("  처리 완료 : {} 명 잠금(lock_yn=Y) 전환", lockedCount);
        log.info("===== [{}] 장기 미접속 계정 잠금 배치 종료 =====", jobName);

        contribution.incrementWriteCount(lockedCount);

        return RepeatStatus.FINISHED;
    }
}
