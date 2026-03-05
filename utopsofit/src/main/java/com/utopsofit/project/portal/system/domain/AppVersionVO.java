package com.utopsofit.project.portal.system.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 앱 버전 관리 VO
 */
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

    public Long          getVersionNo()       { return versionNo; }
    public void          setVersionNo(Long versionNo) { this.versionNo = versionNo; }
    public String        getAppType()         { return appType; }
    public void          setAppType(String appType) { this.appType = appType; }
    public String        getStoreType()       { return storeType; }
    public void          setStoreType(String storeType) { this.storeType = storeType; }
    public String        getVersion()         { return version; }
    public void          setVersion(String version) { this.version = version; }
    public String        getAppCode()         { return appCode; }
    public void          setAppCode(String appCode) { this.appCode = appCode; }
    public LocalDate     getReleaseDt()       { return releaseDt; }
    public void          setReleaseDt(LocalDate releaseDt) { this.releaseDt = releaseDt; }
    public String        getForceUpdateYn()   { return forceUpdateYn; }
    public void          setForceUpdateYn(String forceUpdateYn) { this.forceUpdateYn = forceUpdateYn; }
    public String        getUseYn()           { return useYn; }
    public void          setUseYn(String useYn) { this.useYn = useYn; }
    public String        getNote()            { return note; }
    public void          setNote(String note) { this.note = note; }
    public LocalDateTime getCreatedAt()       { return createdAt; }
    public void          setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String        getCreatedBy()       { return createdBy; }
    public void          setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public LocalDateTime getUpdatedAt()       { return updatedAt; }
    public void          setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public String        getUpdatedBy()       { return updatedBy; }
    public void          setUpdatedBy(String updatedBy) { this.updatedBy = updatedBy; }
    public String        getAppTypeNm()       { return appTypeNm; }
    public void          setAppTypeNm(String appTypeNm) { this.appTypeNm = appTypeNm; }
    public String        getStoreTypeNm()     { return storeTypeNm; }
    public void          setStoreTypeNm(String storeTypeNm) { this.storeTypeNm = storeTypeNm; }
    public String        getSearchAppType()   { return searchAppType; }
    public void          setSearchAppType(String searchAppType) { this.searchAppType = searchAppType; }
    public String        getSearchStoreType() { return searchStoreType; }
    public void          setSearchStoreType(String searchStoreType) { this.searchStoreType = searchStoreType; }
}
