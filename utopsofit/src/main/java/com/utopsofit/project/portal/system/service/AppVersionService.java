package com.utopsofit.project.portal.system.service;

import java.util.List;

import com.utopsofit.project.portal.system.domain.AppVersionVO;

/**
 * 앱 버전 관리 서비스
 */
public interface AppVersionService {

    /** 버전 목록 조회 */
    List<AppVersionVO> getList(AppVersionVO condition);

    /** 버전 단건 조회 */
    AppVersionVO getOne(Long versionNo);

    /** 저장 (등록 / 수정) */
    void save(AppVersionVO vo);

    /** 삭제 */
    void remove(Long versionNo);
}
