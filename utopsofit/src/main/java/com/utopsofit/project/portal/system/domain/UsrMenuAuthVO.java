package com.utopsofit.project.portal.system.domain;

/**
 * 사용자별 메뉴 접근 권한 VO
 */
public class UsrMenuAuthVO {

    private String usrId;
    private Long   menuNo;
    private String accessYn;

    public String getUsrId()   { return usrId; }
    public void   setUsrId(String usrId) { this.usrId = usrId; }
    public Long   getMenuNo()  { return menuNo; }
    public void   setMenuNo(Long menuNo) { this.menuNo = menuNo; }
    public String getAccessYn() { return accessYn; }
    public void   setAccessYn(String accessYn) { this.accessYn = accessYn; }
}
