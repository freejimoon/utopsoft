package com.utopsofit.project.portal.system.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 앱 API 클라이언트 자격증명 VO
 * REST API 호출 앱에 발급되는 appId / appSecret 관리
 */
@Getter
@Setter
public class AppClientVO {

    private String        appId;
    private String        appNm;
    /** DB에는 BCrypt 해시값만 저장 — 발급 시 원본을 1회 노출 후 보관하지 않음 */
    private String        appSecret;
    private String        useYn;
    private String        memo;
    private LocalDateTime createdAt;
    private String        createdBy;
    private LocalDateTime updatedAt;
    private String        updatedBy;

    /** 검색 조건 */
    private String searchKeyword;
    private String searchUseYn;
}
