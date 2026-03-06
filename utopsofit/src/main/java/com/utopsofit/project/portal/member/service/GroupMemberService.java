package com.utopsofit.project.portal.member.service;

import com.utopsofit.project.portal.member.domain.GroupMemberVO;

import java.util.List;

public interface GroupMemberService {
    List<GroupMemberVO> getList(GroupMemberVO cond);
}
