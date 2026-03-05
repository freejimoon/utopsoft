package com.utopsofit.project.portal.board.notice.service;

import com.utopsofit.project.portal.board.notice.domain.NoticeVO;

import java.util.List;

public interface NoticeService {

    List<NoticeVO> getList(NoticeVO condition);

    NoticeVO getOne(Long noticeNo);

    void save(NoticeVO vo);

    void delete(Long noticeNo);
}
