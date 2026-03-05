package com.utopsofit.project.portal.system.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.utopsofit.project.portal.system.domain.AdminVO;

/**
 * 관리자 계정 관리 Mapper
 */
@Mapper
public interface AdminMapper {

    /** 목록 조회 (역할명 JOIN, 검색 조건 포함) */
    List<AdminVO> selectList(AdminVO condition);

    /** 단건 조회 */
    AdminVO selectByPk(@Param("usrId") String usrId);

    /** 등록 */
    void insert(AdminVO vo);

    /** 수정 */
    void update(AdminVO vo);

    /** 삭제 */
    void delete(@Param("usrId") String usrId);

    /** 비밀번호 초기화 */
    void resetPassword(@Param("usrId") String usrId, @Param("usrPw") String usrPw);

    /** ID 중복 체크 */
    int countById(@Param("usrId") String usrId);
}
