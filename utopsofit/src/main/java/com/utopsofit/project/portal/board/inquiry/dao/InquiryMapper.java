package com.utopsofit.project.portal.board.inquiry.dao;

import com.utopsofit.project.portal.board.inquiry.domain.InquiryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 문의 관리 Mapper
 */
@Mapper
public interface InquiryMapper {

    List<InquiryVO> selectList(InquiryVO condition);

    InquiryVO selectOne(@Param("inqNo") Long inqNo);

    int updateReply(InquiryVO vo);

    int insert(InquiryVO vo);
}
