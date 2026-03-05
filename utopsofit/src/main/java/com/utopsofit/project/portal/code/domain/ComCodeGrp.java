package com.utopsofit.project.portal.code.domain;

import java.time.LocalDateTime;

/**
 * 공통코드 그룹 엔티티
 */
public class ComCodeGrp {

    private String grpCd;
    private String grpNm;
    private String grpDesc;
    private String useYn;
    private int sortOrd;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;

    public String getGrpCd() { return grpCd; }
    public void setGrpCd(String grpCd) { this.grpCd = grpCd; }
    public String getGrpNm() { return grpNm; }
    public void setGrpNm(String grpNm) { this.grpNm = grpNm; }
    public String getGrpDesc() { return grpDesc; }
    public void setGrpDesc(String grpDesc) { this.grpDesc = grpDesc; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public int getSortOrd() { return sortOrd; }
    public void setSortOrd(int sortOrd) { this.sortOrd = sortOrd; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public String getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(String updatedBy) { this.updatedBy = updatedBy; }
}
