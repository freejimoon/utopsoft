package com.utopsofit.project.portal.code.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.utopsofit.project.portal.code.dao.ComCodeMapper;
import com.utopsofit.project.portal.code.domain.ComCode;
import com.utopsofit.project.portal.code.domain.ComCodeGrp;
import com.utopsofit.project.portal.code.domain.PageResult;
import com.utopsofit.project.portal.code.service.ComCodeService;

import lombok.RequiredArgsConstructor;

/**
 * 공통코드 서비스 구현
 */
@Service
@RequiredArgsConstructor
public class ComCodeServiceImpl implements ComCodeService {

    private final ComCodeMapper comCodeMapper;

    @Override
    public List<ComCodeGrp> getCodeGrpList(ComCodeGrp condition) {
        return comCodeMapper.selectCodeGrpList(condition != null ? condition : new ComCodeGrp());
    }

    @Override
    public PageResult<ComCodeGrp> getCodeGrpPage(ComCodeGrp condition, int page, int size) {
        ComCodeGrp c = condition != null ? condition : new ComCodeGrp();
        long total = comCodeMapper.countCodeGrpList(c);
        int offset = (page - 1) * size;
        var list = comCodeMapper.selectCodeGrpListPaging(c, offset, size);
        return PageResult.of(list, total, page, size);
    }

    @Override
    public ComCodeGrp getCodeGrp(String grpCd) {
        return comCodeMapper.selectCodeGrpByPk(grpCd);
    }

    @Override
    @Transactional
    public void saveCodeGrp(ComCodeGrp grp) {
        if (comCodeMapper.selectCodeGrpByPk(grp.getGrpCd()) == null) {
            comCodeMapper.insertCodeGrp(grp);
        } else {
            comCodeMapper.updateCodeGrp(grp);
        }
    }

    @Override
    @Transactional
    public void removeCodeGrp(String grpCd) {
        comCodeMapper.deleteCodeGrp(grpCd);
    }

    @Override
    public List<ComCode> getCodeList(String grpCd) {
        return comCodeMapper.selectCodeListByGrp(grpCd);
    }

    @Override
    public PageResult<ComCode> getCodePage(String grpCd, int page, int size) {
        long total = comCodeMapper.countCodeListByGrp(grpCd);
        int offset = (page - 1) * size;
        var list = comCodeMapper.selectCodeListByGrpPaging(grpCd, offset, size);
        return PageResult.of(list, total, page, size);
    }

    @Override
    public ComCode getCode(String grpCd, String code) {
        return comCodeMapper.selectCodeByPk(grpCd, code);
    }

    @Override
    @Transactional
    public void saveCode(ComCode code) {
        if (comCodeMapper.selectCodeByPk(code.getGrpCd(), code.getCode()) == null) {
            comCodeMapper.insertCode(code);
        } else {
            comCodeMapper.updateCode(code);
        }
    }

    @Override
    @Transactional
    public void removeCode(String grpCd, String code) {
        comCodeMapper.deleteCode(grpCd, code);
    }
}
