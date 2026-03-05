package com.utopsofit.project.portal.login.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 사용자 엔티티
 */
@Getter
@Setter
public class Usr {

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
}
