package com.utopsofit.project.portal.board.inquiry.service.impl;

import com.utopsofit.project.portal.board.inquiry.dao.InquiryMapper;
import com.utopsofit.project.portal.board.inquiry.domain.InquiryVO;
import com.utopsofit.project.portal.board.inquiry.service.InquiryService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class InquiryServiceImpl implements InquiryService {

    private final InquiryMapper inquiryMapper;

    @Override
    public List<InquiryVO> getList(InquiryVO condition) {
        return inquiryMapper.selectList(condition);
    }

    @Override
    public InquiryVO getOne(Long inqNo) {
        return inquiryMapper.selectOne(inqNo);
    }

    @Override
    @Transactional
    public void saveReply(InquiryVO vo) {
        String loginId = SecurityContextHolder.getContext().getAuthentication().getName();
        vo.setReplyBy(loginId);
        inquiryMapper.updateReply(vo);
    }
}
