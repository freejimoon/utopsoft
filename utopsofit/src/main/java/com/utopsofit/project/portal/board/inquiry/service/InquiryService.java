package com.utopsofit.project.portal.board.inquiry.service;

import com.utopsofit.project.portal.board.inquiry.domain.InquiryVO;

import java.util.List;

public interface InquiryService {

    List<InquiryVO> getList(InquiryVO condition);

    InquiryVO getOne(Long inqNo);

    void saveReply(InquiryVO vo);
}
