package com.utopsofit.project.portal.board.terms.service.impl;

import com.utopsofit.project.portal.board.terms.dao.TermsMapper;
import com.utopsofit.project.portal.board.terms.domain.TermsVO;
import com.utopsofit.project.portal.board.terms.service.TermsService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TermsServiceImpl implements TermsService {

    private final TermsMapper termsMapper;

    @Override
    public List<TermsVO> getList(TermsVO condition) {
        return termsMapper.selectList(condition);
    }

    @Override
    public TermsVO getOne(Long termsNo) {
        return termsMapper.selectOne(termsNo);
    }

    @Override
    @Transactional
    public void save(TermsVO vo) {
        String loginUser = SecurityContextHolder.getContext().getAuthentication().getName();
        if (vo.getTermsNo() == null) {
            vo.setCreatedBy(loginUser);
            termsMapper.insert(vo);
        } else {
            vo.setUpdatedBy(loginUser);
            termsMapper.update(vo);
        }
    }

    @Override
    @Transactional
    public void delete(Long termsNo) {
        termsMapper.delete(termsNo);
    }
}
