package com.utopsofit.project.portal.system.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.utopsofit.project.portal.system.domain.MenuVO;
import com.utopsofit.project.portal.system.service.UsrAuthService;

import lombok.RequiredArgsConstructor;

/**
 * 사용자별 메뉴 권한 관리 컨트롤러
 */
@Controller
@RequestMapping("/system/auth")
@RequiredArgsConstructor
public class UsrAuthController {

    private final UsrAuthService usrAuthService;

    /** 권한 관리 목록 페이지 */
    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("usrList", usrAuthService.getUsrList());
        return "portal/system/usrAuthList";
    }

    /**
     * 사용자별 메뉴 트리 JSON (권한 모달용)
     * GET /system/auth/menus?usrId=admin
     */
    @GetMapping("/menus")
    @ResponseBody
    public ResponseEntity<List<MenuVO>> menus(@RequestParam String usrId) {
        return ResponseEntity.ok(usrAuthService.getMenuTree(usrId));
    }

    /**
     * 권한 저장
     * POST /system/auth/save
     * menuNos[] : 허용할 메뉴번호 배열
     */
    @PostMapping("/save")
    @ResponseBody
    public ResponseEntity<String> save(@RequestParam String usrId,
                                       @RequestParam(required = false) List<Long> menuNos) {
        usrAuthService.saveAuth(usrId, menuNos);
        return ResponseEntity.ok("저장되었습니다.");
    }
}
