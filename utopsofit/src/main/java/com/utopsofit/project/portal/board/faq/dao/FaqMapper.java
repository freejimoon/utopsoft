package com.utopsofit.project.portal.board.faq.dao;

import com.utopsofit.project.api.faq.domain.FaqApiRequest;
import com.utopsofit.project.portal.board.faq.domain.FaqVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FaqMapper {

    List<FaqVO> selectList(FaqVO condition);

    FaqVO selectOne(@Param("faqNo") Long faqNo);

    int insert(FaqVO vo);

    int update(FaqVO vo);

    int delete(@Param("faqNo") Long faqNo);

    /* ── 앱 API 페이징 ── */
    List<FaqVO> selectPageList(FaqApiRequest req);

    long selectTotalCount(FaqApiRequest req);
}
