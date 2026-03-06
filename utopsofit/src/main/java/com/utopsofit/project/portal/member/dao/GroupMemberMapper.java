package com.utopsofit.project.portal.member.dao;

import com.utopsofit.project.portal.member.domain.GroupMemberVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface GroupMemberMapper {

    /** 단체 회원 목록 */
    List<GroupMemberVO> selectList(GroupMemberVO cond);
}
