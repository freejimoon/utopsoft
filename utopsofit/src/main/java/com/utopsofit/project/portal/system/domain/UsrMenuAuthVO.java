package com.utopsofit.project.portal.system.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * 사용자별 메뉴 접근 권한 VO
 */
@Getter
@Setter
public class UsrMenuAuthVO {

    private String usrId;
    private Long   menuNo;
    private String accessYn;
}
