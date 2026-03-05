package com.utopsofit.project.portal.board.terms.dao;

import com.utopsofit.project.portal.board.terms.domain.TermsVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TermsMapper {

    List<TermsVO> selectList(TermsVO condition);

    TermsVO selectOne(@Param("termsNo") Long termsNo);

    int insert(TermsVO vo);

    int update(TermsVO vo);

    int delete(@Param("termsNo") Long termsNo);
}
