package com.utopsofit.project.portal.system.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 앱 버전 관리 VO
 */
@Getter
@Setter
public class AppVersionVO {

    private Long          versionNo;
    private String        appType;
    private String        storeType;
    private String        version;
    private String        appCode;
    private LocalDate     releaseDt;
    private String        forceUpdateYn;
    private String        useYn;
    private String        note;
    private LocalDateTime createdAt;
    private String        createdBy;
    private LocalDateTime updatedAt;
    private String        updatedBy;

    /* 조회용 — 공통코드 명칭 */
    private String appTypeNm;
    private String storeTypeNm;

    /* 검색 조건 */
    private String searchAppType;
    private String searchStoreType;
}
