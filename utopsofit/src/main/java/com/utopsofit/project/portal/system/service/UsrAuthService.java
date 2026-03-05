package com.utopsofit.project.portal.system.service;

import java.util.List;

import com.utopsofit.project.portal.login.domain.Usr;
import com.utopsofit.project.portal.system.domain.MenuVO;
import com.utopsofit.project.portal.system.domain.UsrMenuAuthVO;

/**
 * 사용자 권한 관리 서비스
 */
public interface UsrAuthService {

    /** 관리자 목록 조회 */
    List<Usr> getUsrList();

    /** 메뉴 트리 조회 (사용자별 accessYn 포함) */
    List<MenuVO> getMenuTree(String usrId);

    /** 권한 저장 (기존 권한 전체 삭제 후 재등록) */
    void saveAuth(String usrId, List<Long> allowedMenuNos);
}
