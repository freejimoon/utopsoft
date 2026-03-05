package com.utopsofit.project.portal.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.utopsofit.project.portal.code.dao.ComCodeMapper;
import com.utopsofit.project.portal.code.domain.ComCode;
import com.utopsofit.project.portal.system.domain.AdminVO;
import com.utopsofit.project.portal.system.service.AdminService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 계정 관리 컨트롤러
 */
@Controller
@RequestMapping("/system/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService   adminService;
    private final ComCodeMapper  comCodeMapper;

    /**
     * 목록 페이지
     * GET /system/admin/list
     */
    @GetMapping("/list")
    public String list(Model model) {
        List<ComCode> roles = comCodeMapper.selectCodeListByGrp("USR_ROLE");
        model.addAttribute("roles", roles);
        return "portal/system/adminList";
    }

    /**
     * 목록 JSON (DataTables Ajax)
     * GET /system/admin/list/json
     */
    @GetMapping("/list/json")
    @ResponseBody
    public ResponseEntity<List<AdminVO>> listJson(
            @RequestParam(required = false) String searchKeyword,
            @RequestParam(required = false) String searchRoleCd,
            @RequestParam(required = false) String searchUseYn) {
        AdminVO cond = new AdminVO();
        cond.setSearchKeyword(searchKeyword);
        cond.setSearchRoleCd(searchRoleCd);
        cond.setSearchUseYn(searchUseYn);
        return ResponseEntity.ok(adminService.getList(cond));
    }

    /**
     * 단건 JSON (수정 모달용)
     * GET /system/admin/one?usrId=admin
     */
    @GetMapping("/one")
    @ResponseBody
    public ResponseEntity<AdminVO> one(@RequestParam String usrId) {
        AdminVO vo = adminService.getOne(usrId);
        if (vo == null) return ResponseEntity.notFound().build();
        vo.setUsrPw(null);
        return ResponseEntity.ok(vo);
    }

    /**
     * ID 중복 체크
     * GET /system/admin/check-id?usrId=xxx
     */
    @GetMapping("/check-id")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkId(@RequestParam String usrId) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("duplicate", adminService.isDuplicate(usrId));
        return ResponseEntity.ok(result);
    }

    /**
     * 저장 (등록 / 수정)
     * POST /system/admin/save
     */
    @PostMapping("/save")
    @ResponseBody
    public ResponseEntity<String> save(@ModelAttribute AdminVO vo) {
        adminService.save(vo);
        return ResponseEntity.ok("저장되었습니다.");
    }

    /**
     * 삭제
     * POST /system/admin/delete
     */
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> delete(@RequestParam String usrId) {
        adminService.remove(usrId);
        return ResponseEntity.ok("삭제되었습니다.");
    }

    /**
     * 비밀번호 초기화
     * POST /system/admin/reset-password
     */
    @PostMapping("/reset-password")
    @ResponseBody
    public ResponseEntity<String> resetPassword(
            @RequestParam String usrId,
            @RequestParam(required = false) String newPassword) {
        adminService.resetPassword(usrId, newPassword);
        return ResponseEntity.ok("비밀번호가 초기화되었습니다.");
    }
}
