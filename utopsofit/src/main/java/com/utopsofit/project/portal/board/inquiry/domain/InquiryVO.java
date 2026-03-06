package com.utopsofit.project.portal.board.inquiry.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 문의 VO
 */
@Getter
@Setter
public class InquiryVO {

    private Long          inqNo;
    private Long          memberNo;
    private String        title;
    private String        content;
    private String        inqCategoryCd;
    private String        inqStatusCd;
    private String        replyContent;
    private LocalDateTime replyDt;
    private String        replyBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /* JOIN — member 정보 */
    private String memberEmail;
    private String memberNm;

    /* 공통코드 명칭 */
    private String inqCategoryNm;
    private String inqStatusNm;

    /* 검색 조건 */
    private String searchCategory;
    private String searchStatus;
    private String searchKeyword;
}
