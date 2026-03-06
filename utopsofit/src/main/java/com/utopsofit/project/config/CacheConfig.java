package com.utopsofit.project.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

/**
 * Caffeine 기반 Spring Cache 설정
 *
 * 캐시 목록:
 *   comCodeList  — grpCd 별 코드 목록  (TTL 1시간, 최대 100개 그룹)
 *   comCode      — grpCd+code 단건     (TTL 1시간, 최대 500개)
 *   comCodeGrp   — grpCd 별 그룹 단건  (TTL 1시간, 최대 100개)
 *
 * 코드 데이터 변경(등록·수정·삭제) 시 @CacheEvict 로 해당 캐시 자동 제거됨.
 */
@EnableCaching
@Configuration
public class CacheConfig {

    public static final String CODE_LIST = "comCodeList";
    public static final String CODE      = "comCode";
    public static final String CODE_GRP  = "comCodeGrp";

    @Bean
    public CacheManager cacheManager() {
        CaffeineCacheManager manager = new CaffeineCacheManager(CODE_LIST, CODE, CODE_GRP);
        manager.setCaffeine(
            Caffeine.newBuilder()
                .expireAfterWrite(1, TimeUnit.HOURS)
                .maximumSize(500)
                .recordStats()          // 캐시 히트율 통계 (로그 등에서 확인 가능)
        );
        return manager;
    }
}
