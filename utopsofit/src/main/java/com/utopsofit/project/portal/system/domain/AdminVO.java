package com.utopsofit.project.portal.system.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 관리자 계정 관리 VO
 */
@Getter
@Setter
public class AdminVO {

    private String        usrId;
    private String        usrNm;
    private String        usrPw;
    private String        email;
    private String        phone;
    private String        deptNm;
    private String        roleCd;
    private String        useYn;
    private LocalDate     pwdChgDt;
    private LocalDateTime lastLoginDt;
    private int           loginFailCnt;
    private String        lockYn;
    private LocalDateTime createdAt;
    private String        createdBy;
    private LocalDateTime updatedAt;
    private String        updatedBy;

    /** 조회용 - 역할명 (com_code JOIN) */
    private String roleNm;

    /** 검색 조건 */
    private String searchKeyword;
    private String searchRoleCd;
    private String searchUseYn;
}
