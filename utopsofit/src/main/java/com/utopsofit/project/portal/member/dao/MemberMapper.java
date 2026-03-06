package com.utopsofit.project.portal.member.dao;

import com.utopsofit.project.portal.member.domain.MemberVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MemberMapper {

    /** 활성 회원 목록 (회원 현황) */
    List<MemberVO> selectActiveList(MemberVO cond);

    /** 탈퇴 회원 목록 */
    List<MemberVO> selectWithdrawList(MemberVO cond);

    /** 휴면 회원 목록 */
    List<MemberVO> selectDormantList(MemberVO cond);
}
