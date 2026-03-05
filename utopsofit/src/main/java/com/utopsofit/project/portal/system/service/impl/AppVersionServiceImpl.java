package com.utopsofit.project.portal.system.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.utopsofit.project.portal.system.dao.AppVersionMapper;
import com.utopsofit.project.portal.system.domain.AppVersionVO;
import com.utopsofit.project.portal.system.service.AppVersionService;

import lombok.RequiredArgsConstructor;

/**
 * 앱 버전 관리 서비스 구현
 */
@Service
@RequiredArgsConstructor
public class AppVersionServiceImpl implements AppVersionService {

    private final AppVersionMapper appVersionMapper;

    @Override
    public List<AppVersionVO> getList(AppVersionVO condition) {
        return appVersionMapper.selectList(condition != null ? condition : new AppVersionVO());
    }

    @Override
    public AppVersionVO getOne(Long versionNo) {
        return appVersionMapper.selectByPk(versionNo);
    }

    @Override
    @Transactional
    public void save(AppVersionVO vo) {
        if (vo.getVersionNo() == null) {
            if (vo.getUseYn() == null || vo.getUseYn().isEmpty()) vo.setUseYn("Y");
            if (vo.getForceUpdateYn() == null || vo.getForceUpdateYn().isEmpty()) vo.setForceUpdateYn("N");
            appVersionMapper.insert(vo);
        } else {
            appVersionMapper.update(vo);
        }
    }

    @Override
    @Transactional
    public void remove(Long versionNo) {
        appVersionMapper.delete(versionNo);
    }
}
