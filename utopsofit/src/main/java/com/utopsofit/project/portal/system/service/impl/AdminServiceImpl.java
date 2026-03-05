package com.utopsofit.project.portal.system.service.impl;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.utopsofit.project.portal.system.dao.AdminMapper;
import com.utopsofit.project.portal.system.domain.AdminVO;
import com.utopsofit.project.portal.system.service.AdminService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 계정 관리 서비스 구현
 */
@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

    private final AdminMapper     adminMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public List<AdminVO> getList(AdminVO condition) {
        return adminMapper.selectList(condition != null ? condition : new AdminVO());
    }

    @Override
    public AdminVO getOne(String usrId) {
        return adminMapper.selectByPk(usrId);
    }

    @Override
    @Transactional
    public void save(AdminVO vo) {
        if (adminMapper.countById(vo.getUsrId()) == 0) {
            String rawPw = (vo.getUsrPw() == null || vo.getUsrPw().isBlank()) ? "Admin1234!" : vo.getUsrPw();
            vo.setUsrPw(passwordEncoder.encode(rawPw));
            if (vo.getUseYn() == null || vo.getUseYn().isBlank()) vo.setUseYn("Y");
            if (vo.getLockYn() == null || vo.getLockYn().isBlank()) vo.setLockYn("N");
            adminMapper.insert(vo);
        } else {
            adminMapper.update(vo);
        }
    }

    @Override
    @Transactional
    public void remove(String usrId) {
        adminMapper.delete(usrId);
    }

    @Override
    @Transactional
    public void resetPassword(String usrId, String newPassword) {
        String encoded = passwordEncoder.encode(
                (newPassword == null || newPassword.isBlank()) ? "Admin1234!" : newPassword);
        adminMapper.resetPassword(usrId, encoded);
    }

    @Override
    public boolean isDuplicate(String usrId) {
        return adminMapper.countById(usrId) > 0;
    }
}
