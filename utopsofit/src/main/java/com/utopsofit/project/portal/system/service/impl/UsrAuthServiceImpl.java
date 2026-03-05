package com.utopsofit.project.portal.system.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.utopsofit.project.portal.login.domain.Usr;
import com.utopsofit.project.portal.system.dao.UsrAuthMapper;
import com.utopsofit.project.portal.system.domain.MenuVO;
import com.utopsofit.project.portal.system.domain.UsrMenuAuthVO;
import com.utopsofit.project.portal.system.service.UsrAuthService;

import lombok.RequiredArgsConstructor;

/**
 * 사용자 권한 관리 서비스 구현
 */
@Service
@RequiredArgsConstructor
public class UsrAuthServiceImpl implements UsrAuthService {

    private final UsrAuthMapper usrAuthMapper;

    @Override
    public List<Usr> getUsrList() {
        return usrAuthMapper.selectUsrList();
    }

    /**
     * 메뉴 트리 구성
     * - Flat 리스트를 1depth(parent_menu_no=NULL) → 2depth(children) 구조로 변환
     */
    @Override
    public List<MenuVO> getMenuTree(String usrId) {
        List<MenuVO> flatList = usrAuthMapper.selectMenuListWithAuth(usrId);

        List<MenuVO> roots    = new ArrayList<>();
        List<MenuVO> children = new ArrayList<>();

        for (MenuVO menu : flatList) {
            if (menu.getParentMenuNo() == null) {
                menu.setChildren(new ArrayList<>());
                roots.add(menu);
            } else {
                children.add(menu);
            }
        }

        // 자식 메뉴를 부모에 연결
        for (MenuVO child : children) {
            for (MenuVO root : roots) {
                if (root.getMenuNo().equals(child.getParentMenuNo())) {
                    root.getChildren().add(child);
                    break;
                }
            }
        }

        return roots;
    }

    /**
     * 권한 저장
     * - 기존 권한 전체 삭제 후 허용된 메뉴만 재등록
     */
    @Override
    @Transactional
    public void saveAuth(String usrId, List<Long> allowedMenuNos) {
        usrAuthMapper.deleteUsrMenuAuth(usrId);

        if (allowedMenuNos == null || allowedMenuNos.isEmpty()) return;

        for (Long menuNo : allowedMenuNos) {
            UsrMenuAuthVO auth = new UsrMenuAuthVO();
            auth.setUsrId(usrId);
            auth.setMenuNo(menuNo);
            auth.setAccessYn("Y");
            usrAuthMapper.insertUsrMenuAuth(auth);
        }
    }
}
