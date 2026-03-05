package com.utopsofit.project.portal.code.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 공통코드 엔티티
 */
@Getter
@Setter
public class ComCode {

    private String        grpCd;
    private String        code;
    private String        codeNm;
    private String        codeDesc;
    private String        useYn;
    private int           sortOrd;
    private String        attr1;
    private String        attr2;
    private String        attr3;
    private LocalDateTime createdAt;
    private String        createdBy;
    private LocalDateTime updatedAt;
    private String        updatedBy;
}
