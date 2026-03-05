package com.utopsofit.project.portal.system.service;

import java.util.List;

import com.utopsofit.project.portal.system.domain.AdminVO;

/**
 * 관리자 계정 관리 서비스
 */
public interface AdminService {

    /** 목록 조회 */
    List<AdminVO> getList(AdminVO condition);

    /** 단건 조회 */
    AdminVO getOne(String usrId);

    /** 저장 (등록 / 수정) */
    void save(AdminVO vo);

    /** 삭제 */
    void remove(String usrId);

    /** 비밀번호 초기화 */
    void resetPassword(String usrId, String newPassword);

    /** ID 중복 체크 */
    boolean isDuplicate(String usrId);
}
