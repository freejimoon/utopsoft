package com.utopsofit.project.portal.system.service;

import com.utopsofit.project.portal.system.domain.AppClientVO;

import java.util.List;
import java.util.Map;

public interface AppClientService {

    List<AppClientVO> getList(AppClientVO condition);

    AppClientVO getOne(String appId);

    /** 신규 등록 — 발급된 평문 appSecret 반환 (1회 노출용) */
    Map<String, String> register(AppClientVO vo);

    void modify(AppClientVO vo);

    void remove(String appId);

    /** Secret 재발급 — 새 평문 appSecret 반환 */
    Map<String, String> reissueSecret(String appId);

    boolean isDuplicate(String appId);
}
