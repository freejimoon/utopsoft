package com.utopsofit.project.portal.member.service.impl;

import com.utopsofit.project.portal.member.dao.MemberMapper;
import com.utopsofit.project.portal.member.domain.MemberVO;
import com.utopsofit.project.portal.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberMapper memberMapper;

    @Override
    public List<MemberVO> getActiveList(MemberVO cond) {
        return memberMapper.selectActiveList(cond);
    }

    @Override
    public List<MemberVO> getWithdrawList(MemberVO cond) {
        return memberMapper.selectWithdrawList(cond);
    }

    @Override
    public List<MemberVO> getDormantList(MemberVO cond) {
        return memberMapper.selectDormantList(cond);
    }
}
