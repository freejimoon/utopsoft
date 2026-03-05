package com.utopsofit.project.portal.system.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.utopsofit.project.portal.login.domain.Usr;
import com.utopsofit.project.portal.system.domain.MenuVO;
import com.utopsofit.project.portal.system.domain.UsrMenuAuthVO;

/**
 * 사용자 권한 관리 Mapper
 */
@Mapper
public interface UsrAuthMapper {

    /** 관리자 목록 전체 조회 (권한 관리 대상) */
    List<Usr> selectUsrList();

    /** 전체 메뉴 목록 (use_yn = Y, sort_ord 순) */
    List<MenuVO> selectMenuList();

    /**
     * 특정 사용자의 메뉴 권한 목록 조회
     * accessYn 컬럼을 LEFT JOIN으로 가져옴
     */
    List<MenuVO> selectMenuListWithAuth(@Param("usrId") String usrId);

    /** 특정 사용자의 권한 전체 삭제 (재등록 방식) */
    void deleteUsrMenuAuth(@Param("usrId") String usrId);

    /** 권한 단건 등록 */
    void insertUsrMenuAuth(UsrMenuAuthVO auth);
}
