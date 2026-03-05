package com.utopsofit.project.portal.login.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 사용자 엔티티
 */
public class Usr {

    private String usrId;
    private String usrNm;
    private String usrPw;
    private String email;
    private String phone;
    private String deptNm;
    private String roleCd;
    private String useYn;
    private LocalDate pwdChgDt;
    private LocalDateTime lastLoginDt;
    private int loginFailCnt;
    private String lockYn;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;

    public String getUsrId() { return usrId; }
    public void setUsrId(String usrId) { this.usrId = usrId; }
    public String getUsrNm() { return usrNm; }
    public void setUsrNm(String usrNm) { this.usrNm = usrNm; }
    public String getUsrPw() { return usrPw; }
    public void setUsrPw(String usrPw) { this.usrPw = usrPw; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getDeptNm() { return deptNm; }
    public void setDeptNm(String deptNm) { this.deptNm = deptNm; }
    public String getRoleCd() { return roleCd; }
    public void setRoleCd(String roleCd) { this.roleCd = roleCd; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
    public LocalDate getPwdChgDt() { return pwdChgDt; }
    public void setPwdChgDt(LocalDate pwdChgDt) { this.pwdChgDt = pwdChgDt; }
    public LocalDateTime getLastLoginDt() { return lastLoginDt; }
    public void setLastLoginDt(LocalDateTime lastLoginDt) { this.lastLoginDt = lastLoginDt; }
    public int getLoginFailCnt() { return loginFailCnt; }
    public void setLoginFailCnt(int loginFailCnt) { this.loginFailCnt = loginFailCnt; }
    public String getLockYn() { return lockYn; }
    public void setLockYn(String lockYn) { this.lockYn = lockYn; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public String getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(String updatedBy) { this.updatedBy = updatedBy; }
}
