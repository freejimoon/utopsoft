package com.utopsofit.project.portal.board.terms.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 약관 VO
 */
@Getter
@Setter
public class TermsVO {

    private Long          termsNo;
    private String        appTypeCd;
    private String        appTypeNm;
    private String        termsTypeCd;
    private String        termsTypeNm;
    private String        requiredYn;
    private Integer       version;
    private String        content;
    private String        useYn;
    private LocalDateTime createdAt;
    private String        createdBy;
    private LocalDateTime updatedAt;
    private String        updatedBy;

    /* 검색 조건 */
    private String searchAppType;
    private String searchTermsType;
    private String searchKeyword;
}
