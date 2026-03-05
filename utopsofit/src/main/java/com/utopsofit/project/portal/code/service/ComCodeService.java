package com.utopsofit.project.portal.code.service;

import java.util.List;

import com.utopsofit.project.portal.code.domain.ComCode;
import com.utopsofit.project.portal.code.domain.ComCodeGrp;
import com.utopsofit.project.portal.code.domain.PageResult;

/**
 * 공통코드 서비스
 */
public interface ComCodeService {

    List<ComCodeGrp> getCodeGrpList(ComCodeGrp condition);
    PageResult<ComCodeGrp> getCodeGrpPage(ComCodeGrp condition, int page, int size);
    ComCodeGrp getCodeGrp(String grpCd);
    void saveCodeGrp(ComCodeGrp grp);
    void removeCodeGrp(String grpCd);

    List<ComCode> getCodeList(String grpCd);
    PageResult<ComCode> getCodePage(String grpCd, int page, int size);
    ComCode getCode(String grpCd, String code);
    void saveCode(ComCode code);
    void removeCode(String grpCd, String code);
}
