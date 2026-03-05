package com.utopsofit.project.portal.board.terms.service;

import com.utopsofit.project.portal.board.terms.domain.TermsVO;

import java.util.List;

public interface TermsService {

    List<TermsVO> getList(TermsVO condition);

    TermsVO getOne(Long termsNo);

    void save(TermsVO vo);

    void delete(Long termsNo);
}
