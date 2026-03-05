package com.utopsofit.project.portal.system.controller;

import com.utopsofit.project.portal.system.domain.AppClientVO;
import com.utopsofit.project.portal.system.service.AppClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 앱 API 클라이언트 관리 컨트롤러
 * GET  /system/app-client/list        → 목록 화면
 * GET  /system/app-client/list/json   → DataTables Ajax
 * GET  /system/app-client/one         → 단건 JSON
 * GET  /system/app-client/check-id    → ID 중복 확인
 * POST /system/app-client/register    → 신규 발급 (평문 secret 1회 반환)
 * POST /system/app-client/modify      → 앱명/사용여부/메모 수정
 * POST /system/app-client/delete      → 삭제
 * POST /system/app-client/reissue     → Secret 재발급
 */
@Controller
@RequestMapping("/system/app-client")
@RequiredArgsConstructor
public class AppClientController {

    private final AppClientService appClientService;

    @GetMapping("/list")
    public String list() {
        return "portal/system/appClientList";
    }

    @GetMapping("/list/json")
    @ResponseBody
    public ResponseEntity<List<AppClientVO>> listJson(
            @RequestParam(required = false) String searchKeyword,
            @RequestParam(required = false) String searchUseYn) {
        AppClientVO cond = new AppClientVO();
        cond.setSearchKeyword(searchKeyword);
        cond.setSearchUseYn(searchUseYn);
        return ResponseEntity.ok(appClientService.getList(cond));
    }

    @GetMapping("/one")
    @ResponseBody
    public ResponseEntity<AppClientVO> one(@RequestParam String appId) {
        AppClientVO vo = appClientService.getOne(appId);
        if (vo == null) return ResponseEntity.notFound().build();
        vo.setAppSecret(null); // 해시값 노출 방지
        return ResponseEntity.ok(vo);
    }

    @GetMapping("/check-id")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> checkId(@RequestParam String appId) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("duplicate", appClientService.isDuplicate(appId));
        return ResponseEntity.ok(result);
    }

    /** 신규 발급 — 응답에 평문 appSecret 포함 (화면에 1회 표시) */
    @PostMapping("/register")
    @ResponseBody
    public ResponseEntity<Map<String, String>> register(@ModelAttribute AppClientVO vo) {
        return ResponseEntity.ok(appClientService.register(vo));
    }

    @PostMapping("/modify")
    @ResponseBody
    public ResponseEntity<String> modify(@ModelAttribute AppClientVO vo) {
        appClientService.modify(vo);
        return ResponseEntity.ok("수정되었습니다.");
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> delete(@RequestParam String appId) {
        appClientService.remove(appId);
        return ResponseEntity.ok("삭제되었습니다.");
    }

    /** Secret 재발급 — 응답에 새 평문 appSecret 포함 */
    @PostMapping("/reissue")
    @ResponseBody
    public ResponseEntity<Map<String, String>> reissue(@RequestParam String appId) {
        return ResponseEntity.ok(appClientService.reissueSecret(appId));
    }
}
