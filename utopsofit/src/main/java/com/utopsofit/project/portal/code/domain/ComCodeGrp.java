package com.utopsofit.project.portal.code.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 공통코드 그룹 엔티티
 */
@Getter
@Setter
public class ComCodeGrp {

    private String        grpCd;
    private String        grpNm;
    private String        grpDesc;
    private String        useYn;
    private int           sortOrd;
    private LocalDateTime createdAt;
    private String        createdBy;
    private LocalDateTime updatedAt;
    private String        updatedBy;
}
