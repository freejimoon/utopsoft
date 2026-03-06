package com.utopsofit.project.api.faq.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FaqApiRequest {

    /** FAQ 카테고리 코드 (com_code.grp_cd = 'FAQ_CATEGORY_CD') — 미전달 시 전체 조회 */
    private String categoryCd;

    /** 요청 페이지 번호 (1-based, 기본값 1) */
    private int page = 1;

    /** 페이지당 항목 수 (기본값 10, 최대 100) */
    private int size = 10;

    /** MyBatis OFFSET 계산 — (page-1) * limit */
    public int getOffset() { return (Math.max(page, 1) - 1) * getLimit(); }

    /** MyBatis LIMIT 계산 — size 범위 보정 (1~100) */
    public int getLimit()  { return Math.min(Math.max(size, 1), 100); }
}
