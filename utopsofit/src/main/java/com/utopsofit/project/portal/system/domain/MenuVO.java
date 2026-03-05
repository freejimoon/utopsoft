package com.utopsofit.project.portal.system.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 메뉴 마스터 VO
 */
@Getter
@Setter
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
}
