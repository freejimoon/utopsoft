package com.utopsofit.project.api.faq.domain;

import com.utopsofit.project.portal.board.faq.domain.FaqVO;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class FaqApiResponse {

    private final Long          faqNo;
    private final String        categoryCd;
    private final String        categoryNm;
    private final String        question;
    private final String        answer;
    private final Integer       sortOrd;
    private final String        useYn;
    private final LocalDateTime createdAt;
    private final String        createdBy;
    private final LocalDateTime updatedAt;
    private final String        updatedBy;

    private FaqApiResponse(FaqVO vo) {
        this.faqNo      = vo.getFaqNo();
        this.categoryCd = vo.getCategoryCd();
        this.categoryNm = vo.getCategoryNm();
        this.question   = vo.getQuestion();
        this.answer     = vo.getAnswer();
        this.sortOrd    = vo.getSortOrd();
        this.useYn      = vo.getUseYn();
        this.createdAt  = vo.getCreatedAt();
        this.createdBy  = vo.getCreatedBy();
        this.updatedAt  = vo.getUpdatedAt();
        this.updatedBy  = vo.getUpdatedBy();
    }

    public static FaqApiResponse from(FaqVO vo) {
        return new FaqApiResponse(vo);
    }
}
