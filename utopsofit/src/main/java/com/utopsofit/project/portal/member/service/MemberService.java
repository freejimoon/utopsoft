package com.utopsofit.project.portal.member.service;

import com.utopsofit.project.portal.member.domain.MemberVO;

import java.util.List;

public interface MemberService {
    List<MemberVO> getActiveList(MemberVO cond);
    List<MemberVO> getWithdrawList(MemberVO cond);
    List<MemberVO> getDormantList(MemberVO cond);
}
