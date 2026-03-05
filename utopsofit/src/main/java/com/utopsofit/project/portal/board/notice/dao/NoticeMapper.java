package com.utopsofit.project.portal.board.notice.dao;

import com.utopsofit.project.portal.board.notice.domain.NoticeVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface NoticeMapper {

    List<NoticeVO> selectList(NoticeVO condition);

    NoticeVO selectOne(@Param("noticeNo") Long noticeNo);

    int insert(NoticeVO vo);

    int update(NoticeVO vo);

    int delete(@Param("noticeNo") Long noticeNo);
}
