package com.utopsofit.project.portal.board.faq.service.impl;

import com.utopsofit.project.portal.board.faq.dao.FaqMapper;
import com.utopsofit.project.portal.board.faq.domain.FaqVO;
import com.utopsofit.project.portal.board.faq.service.FaqService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FaqServiceImpl implements FaqService {

    private final FaqMapper faqMapper;

    @Override
    public List<FaqVO> getList(FaqVO condition) {
        return faqMapper.selectList(condition);
    }

    @Override
    public FaqVO getOne(Long faqNo) {
        return faqMapper.selectOne(faqNo);
    }

    @Override
    @Transactional
    public void save(FaqVO vo) {
        String loginUser = SecurityContextHolder.getContext().getAuthentication().getName();
        if (vo.getFaqNo() == null) {
            vo.setCreatedBy(loginUser);
            faqMapper.insert(vo);
        } else {
            vo.setUpdatedBy(loginUser);
            faqMapper.update(vo);
        }
    }

    @Override
    @Transactional
    public void delete(Long faqNo) {
        faqMapper.delete(faqNo);
    }
}
