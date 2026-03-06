package com.utopsofit.project.portal.system.controller;

import java.util.List;

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
import com.utopsofit.project.portal.system.domain.AppVersionVO;
import com.utopsofit.project.portal.system.service.AppVersionService;

import lombok.RequiredArgsConstructor;

/**
 * 앱 버전 관리 컨트롤러
 */
@Controller
@RequestMapping("/system/version")
@RequiredArgsConstructor
public class AppVersionController {

    private final AppVersionService appVersionService;
    private final ComCodeMapper     comCodeMapper;

    /**
     * 버전 목록 페이지
     * GET /system/version/list
     */
    @GetMapping("/list")
    public String list(Model model) {
        List<ComCode> appTypes   = comCodeMapper.selectCodeListByGrp("APP_TYPE_CD");
        List<ComCode> storeTypes = comCodeMapper.selectCodeListByGrp("STORE_TYPE_CD");
        model.addAttribute("appTypes",   appTypes);
        model.addAttribute("storeTypes", storeTypes);
        return "portal/system/appVersionList";
    }

    /**
     * 버전 목록 JSON (DataTables Ajax + 검색 필터)
     * GET /system/version/list/json?searchAppType=&searchStoreType=
     */
    @GetMapping("/list/json")
    @ResponseBody
    public ResponseEntity<List<AppVersionVO>> listJson(
            @RequestParam(required = false) String searchAppCd,
            @RequestParam(required = false) String searchStoreCd) {
        AppVersionVO condition = new AppVersionVO();
        condition.setSearchAppCd(searchAppCd);
        condition.setSearchStoreCd(searchStoreCd);
        return ResponseEntity.ok(appVersionService.getList(condition));
    }

    /**
     * 버전 단건 JSON (수정 모달용)
     * GET /system/version/one?versionNo=1
     */
    @GetMapping("/one")
    @ResponseBody
    public ResponseEntity<AppVersionVO> one(@RequestParam Long versionNo) {
        AppVersionVO vo = appVersionService.getOne(versionNo);
        if (vo == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(vo);
    }

    /**
     * 저장 (등록 / 수정)
     * POST /system/version/save
     */
    @PostMapping("/save")
    @ResponseBody
    public ResponseEntity<String> save(@ModelAttribute AppVersionVO vo) {
        appVersionService.save(vo);
        return ResponseEntity.ok("저장되었습니다.");
    }

    /**
     * 삭제
     * POST /system/version/delete
     */
    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> delete(@RequestParam Long versionNo) {
        appVersionService.remove(versionNo);
        return ResponseEntity.ok("삭제되었습니다.");
    }
}
