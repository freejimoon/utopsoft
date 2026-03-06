package com.utopsofit.project.portal.code.service.impl;

import java.util.List;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.utopsofit.project.config.CacheConfig;
import com.utopsofit.project.portal.code.dao.ComCodeMapper;
import com.utopsofit.project.portal.code.domain.ComCode;
import com.utopsofit.project.portal.code.domain.ComCodeGrp;
import com.utopsofit.project.portal.code.domain.PageResult;
import com.utopsofit.project.portal.code.service.ComCodeService;

import lombok.RequiredArgsConstructor;

/**
 * 공통코드 서비스 구현
 *
 * 캐시 전략:
 *   - 조회(read)  : @Cacheable  — 캐시 히트 시 DB 쿼리 생략
 *   - 변경(write) : @CacheEvict — 관련 캐시 즉시 무효화
 *
 * 캐시 TTL: 1시간 (CacheConfig 참조)
 */
@Service
@RequiredArgsConstructor
public class ComCodeServiceImpl implements ComCodeService {

    private final ComCodeMapper comCodeMapper;

    // ─────────────────────────────────────────
    // 코드 그룹 (ComCodeGrp)
    // ─────────────────────────────────────────

    /** 전체 그룹 목록 — 조건 검색이므로 캐시 미적용 (가변 결과) */
    @Override
    public List<ComCodeGrp> getCodeGrpList(ComCodeGrp condition) {
        return comCodeMapper.selectCodeGrpList(condition != null ? condition : new ComCodeGrp());
    }

    @Override
    public PageResult<ComCodeGrp> getCodeGrpPage(ComCodeGrp condition, int page, int size) {
        ComCodeGrp c = condition != null ? condition : new ComCodeGrp();
        long total   = comCodeMapper.countCodeGrpList(c);
        int  offset  = (page - 1) * size;
        var  list    = comCodeMapper.selectCodeGrpListPaging(c, offset, size);
        return PageResult.of(list, total, page, size);
    }

    /** 그룹 단건 — grpCd 키로 캐시 */
    @Override
    @Cacheable(cacheNames = CacheConfig.CODE_GRP, key = "#grpCd")
    public ComCodeGrp getCodeGrp(String grpCd) {
        return comCodeMapper.selectCodeGrpByPk(grpCd);
    }

    /** 그룹 저장 — 해당 그룹 캐시 제거 */
    @Override
    @Transactional
    @CacheEvict(cacheNames = CacheConfig.CODE_GRP, key = "#grp.grpCd")
    public void saveCodeGrp(ComCodeGrp grp) {
        if (comCodeMapper.selectCodeGrpByPk(grp.getGrpCd()) == null) {
            comCodeMapper.insertCodeGrp(grp);
        } else {
            comCodeMapper.updateCodeGrp(grp);
        }
    }

    /** 그룹 삭제 — 그룹 캐시 + 해당 그룹의 코드 목록 캐시 함께 제거 */
    @Override
    @Transactional
    @Caching(evict = {
        @CacheEvict(cacheNames = CacheConfig.CODE_GRP,  key = "#grpCd"),
        @CacheEvict(cacheNames = CacheConfig.CODE_LIST, key = "#grpCd")
    })
    public void removeCodeGrp(String grpCd) {
        comCodeMapper.deleteCodeGrp(grpCd);
    }

    // ─────────────────────────────────────────
    // 코드 (ComCode)
    // ─────────────────────────────────────────

    /** 그룹별 코드 목록 — grpCd 키로 캐시 (가장 빈번히 조회되는 메서드) */
    @Override
    @Cacheable(cacheNames = CacheConfig.CODE_LIST, key = "#grpCd")
    public List<ComCode> getCodeList(String grpCd) {
        return comCodeMapper.selectCodeListByGrp(grpCd);
    }

    /** 페이징 조회 — 가변 결과이므로 캐시 미적용 */
    @Override
    public PageResult<ComCode> getCodePage(String grpCd, int page, int size) {
        long total  = comCodeMapper.countCodeListByGrp(grpCd);
        int  offset = (page - 1) * size;
        var  list   = comCodeMapper.selectCodeListByGrpPaging(grpCd, offset, size);
        return PageResult.of(list, total, page, size);
    }

    /** 코드 단건 — grpCd+code 복합 키로 캐시 */
    @Override
    @Cacheable(cacheNames = CacheConfig.CODE, key = "#grpCd + ':' + #code")
    public ComCode getCode(String grpCd, String code) {
        return comCodeMapper.selectCodeByPk(grpCd, code);
    }

    /** 코드 저장 — 코드 단건 캐시 + 그룹 목록 캐시 제거 */
    @Override
    @Transactional
    @Caching(evict = {
        @CacheEvict(cacheNames = CacheConfig.CODE,      key = "#code.grpCd + ':' + #code.code"),
        @CacheEvict(cacheNames = CacheConfig.CODE_LIST, key = "#code.grpCd")
    })
    public void saveCode(ComCode code) {
        if (comCodeMapper.selectCodeByPk(code.getGrpCd(), code.getCode()) == null) {
            comCodeMapper.insertCode(code);
        } else {
            comCodeMapper.updateCode(code);
        }
    }

    /** 코드 삭제 — 코드 단건 캐시 + 그룹 목록 캐시 제거 */
    @Override
    @Transactional
    @Caching(evict = {
        @CacheEvict(cacheNames = CacheConfig.CODE,      key = "#grpCd + ':' + #code"),
        @CacheEvict(cacheNames = CacheConfig.CODE_LIST, key = "#grpCd")
    })
    public void removeCode(String grpCd, String code) {
        comCodeMapper.deleteCode(grpCd, code);
    }
}
