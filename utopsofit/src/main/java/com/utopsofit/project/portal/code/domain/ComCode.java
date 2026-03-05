package com.utopsofit.project.portal.code.domain;

import java.time.LocalDateTime;

/**
 * 공통코드 엔티티
 */
public class ComCode {

    private String grpCd;
    private String code;
    private String codeNm;
    private String codeDesc;
    private String useYn;
    private int sortOrd;
    private String attr1;
    private String attr2;
    private String attr3;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;

    public String getGrpCd() { return grpCd; }
    public void setGrpCd(String grpCd) { this.grpCd = grpCd; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getCodeNm() { return codeNm; }
    public void setCodeNm(String codeNm) { this.codeNm = codeNm; }
    public String getCodeDesc() { return codeDesc; }
    public void setCodeDesc(String codeDesc) { this.codeDesc = codeDesc; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public int getSortOrd() { return sortOrd; }
    public void setSortOrd(int sortOrd) { this.sortOrd = sortOrd; }
    public String getAttr1() { return attr1; }
    public void setAttr1(String attr1) { this.attr1 = attr1; }
    public String getAttr2() { return attr2; }
    public void setAttr2(String attr2) { this.attr2 = attr2; }
    public String getAttr3() { return attr3; }
    public void setAttr3(String attr3) { this.attr3 = attr3; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public String getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(String updatedBy) { this.updatedBy = updatedBy; }
}
