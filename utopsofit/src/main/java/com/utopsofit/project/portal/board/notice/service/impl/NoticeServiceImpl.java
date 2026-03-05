package com.utopsofit.project.portal.board.notice.service.impl;

import com.utopsofit.project.portal.board.notice.dao.NoticeMapper;
import com.utopsofit.project.portal.board.notice.domain.NoticeVO;
import com.utopsofit.project.portal.board.notice.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {

    private final NoticeMapper noticeMapper;

    @Override
    public List<NoticeVO> getList(NoticeVO condition) {
        return noticeMapper.selectList(condition);
    }

    @Override
    public NoticeVO getOne(Long noticeNo) {
        return noticeMapper.selectOne(noticeNo);
    }

    @Override
    @Transactional
    public void save(NoticeVO vo) {
        String loginUser = SecurityContextHolder.getContext().getAuthentication().getName();
        if (vo.getNoticeNo() == null) {
            vo.setCreatedBy(loginUser);
            noticeMapper.insert(vo);
        } else {
            vo.setUpdatedBy(loginUser);
            noticeMapper.update(vo);
        }
    }

    @Override
    @Transactional
    public void delete(Long noticeNo) {
        noticeMapper.delete(noticeNo);
    }
}
