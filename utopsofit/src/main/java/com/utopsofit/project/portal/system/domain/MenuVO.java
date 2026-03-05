package com.utopsofit.project.portal.system.domain;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 메뉴 마스터 VO
 */
public class MenuVO {

    private Long   menuNo;
    private Long   parentMenuNo;
    private String menuNm;
    private String menuUrl;
    private String menuIcon;
    private String menuType;   // GROUP / LINK
    private int    sortOrd;
    private String useYn;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;
    private String updatedBy;

    /** 트리 구성용 하위 메뉴 목록 */
    private List<MenuVO> children;

    /** 권한 조회 시 해당 사용자의 접근 허용 여부 */
    private String accessYn;

    public Long   getMenuNo()        { return menuNo; }
    public void   setMenuNo(Long menuNo) { this.menuNo = menuNo; }
    public Long   getParentMenuNo()  { return parentMenuNo; }
    public void   setParentMenuNo(Long parentMenuNo) { this.parentMenuNo = parentMenuNo; }
    public String getMenuNm()        { return menuNm; }
    public void   setMenuNm(String menuNm) { this.menuNm = menuNm; }
    public String getMenuUrl()       { return menuUrl; }
    public void   setMenuUrl(String menuUrl) { this.menuUrl = menuUrl; }
    public String getMenuIcon()      { return menuIcon; }
    public void   setMenuIcon(String menuIcon) { this.menuIcon = menuIcon; }
    public String getMenuType()      { return menuType; }
    public void   setMenuType(String menuType) { this.menuType = menuType; }
    public int    getSortOrd()       { return sortOrd; }
    public void   setSortOrd(int sortOrd) { this.sortOrd = sortOrd; }
    public String getUseYn()         { return useYn; }
    public void   setUseYn(String useYn) { this.useYn = useYn; }
    public LocalDateTime getCreatedAt()  { return createdAt; }
    public void   setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getCreatedBy()     { return createdBy; }
    public void   setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public LocalDateTime getUpdatedAt()  { return updatedAt; }
    public void   setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public String getUpdatedBy()     { return updatedBy; }
    public void   setUpdatedBy(String updatedBy) { this.updatedBy = updatedBy; }
    public List<MenuVO> getChildren()    { return children; }
    public void   setChildren(List<MenuVO> children) { this.children = children; }
    public String getAccessYn()      { return accessYn; }
    public void   setAccessYn(String accessYn) { this.accessYn = accessYn; }
}
