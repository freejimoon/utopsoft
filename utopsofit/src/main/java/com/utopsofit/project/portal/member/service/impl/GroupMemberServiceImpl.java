package com.utopsofit.project.portal.member.service.impl;

import com.utopsofit.project.portal.member.dao.GroupMemberMapper;
import com.utopsofit.project.portal.member.domain.GroupMemberVO;
import com.utopsofit.project.portal.member.service.GroupMemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class GroupMemberServiceImpl implements GroupMemberService {

    private final GroupMemberMapper groupMemberMapper;

    @Override
    public List<GroupMemberVO> getList(GroupMemberVO cond) {
        return groupMemberMapper.selectList(cond);
    }
}
