package com.utopsofit.project.portal.board.faq.service;

import com.utopsofit.project.portal.board.faq.domain.FaqVO;

import java.util.List;

public interface FaqService {

    List<FaqVO> getList(FaqVO condition);

    FaqVO getOne(Long faqNo);

    void save(FaqVO vo);

    void delete(Long faqNo);
}
