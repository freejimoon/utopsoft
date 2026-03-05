package com.utopsofit.project.portal.system.service.impl;

import com.utopsofit.project.portal.system.dao.AppClientMapper;
import com.utopsofit.project.portal.system.domain.AppClientVO;
import com.utopsofit.project.portal.system.service.AppClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AppClientServiceImpl implements AppClientService {

    private final AppClientMapper appClientMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public List<AppClientVO> getList(AppClientVO condition) {
        return appClientMapper.selectList(condition != null ? condition : new AppClientVO());
    }

    @Override
    public AppClientVO getOne(String appId) {
        return appClientMapper.selectByPk(appId);
    }

    @Override
    @Transactional
    public Map<String, String> register(AppClientVO vo) {
        String rawSecret = generateSecret();
        vo.setAppSecret(passwordEncoder.encode(rawSecret));
        if (vo.getUseYn() == null || vo.getUseYn().isEmpty()) vo.setUseYn("Y");
        appClientMapper.insert(vo);

        Map<String, String> result = new HashMap<>();
        result.put("appId",     vo.getAppId());
        result.put("appSecret", rawSecret); // 평문 — 화면에 1회 노출 후 서버는 보관하지 않음
        return result;
    }

    @Override
    @Transactional
    public void modify(AppClientVO vo) {
        appClientMapper.update(vo);
    }

    @Override
    @Transactional
    public void remove(String appId) {
        appClientMapper.delete(appId);
    }

    @Override
    @Transactional
    public Map<String, String> reissueSecret(String appId) {
        String rawSecret    = generateSecret();
        String hashedSecret = passwordEncoder.encode(rawSecret);
        appClientMapper.updateSecret(appId, hashedSecret);

        Map<String, String> result = new HashMap<>();
        result.put("appId",     appId);
        result.put("appSecret", rawSecret);
        return result;
    }

    @Override
    public boolean isDuplicate(String appId) {
        return appClientMapper.countById(appId) > 0;
    }

    /** UUID 기반 32자리 랜덤 시크릿 생성 */
    private String generateSecret() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
