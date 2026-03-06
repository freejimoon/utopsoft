package com.utopsofit.project.portal.board.faq.domain;

import com.utopsofit.project.cmm.file.domain.FileAttachVO;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

/**
 * FAQ VO
 */
@Getter
@Setter
public class FaqVO {

    private Long          faqNo;
    private String        categoryCd;
    private String        categoryNm;
    private String        question;
    private String        answer;
    private Integer       sortOrd;
    private String        useYn;
    private LocalDateTime createdAt;
    private String        createdBy;
    private LocalDateTime updatedAt;
    private String        updatedBy;

    /* 첨부파일 */
    private Integer           attachCount;
    private List<FileAttachVO> attachList;

    /* 검색 조건 */
    private String searchCategory;
    private String searchKeyword;
}
