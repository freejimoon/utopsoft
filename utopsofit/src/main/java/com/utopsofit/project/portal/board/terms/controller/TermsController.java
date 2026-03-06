package com.utopsofit.project.portal.board.terms.controller;

import com.utopsofit.project.portal.board.terms.domain.TermsVO;
import com.utopsofit.project.portal.board.terms.service.TermsService;
import com.utopsofit.project.portal.code.dao.ComCodeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 약관 컨트롤러
 */
@Controller
@RequestMapping("/board/terms")
@RequiredArgsConstructor
public class TermsController {

    private final TermsService  termsService;
    private final ComCodeMapper comCodeMapper;

    /* ── 목록 뷰 ─────────────────────────────────────── */
    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("appTypeCodes",   comCodeMapper.selectCodeListByGrp("TERMS_APP_TYPE_CD"));
        model.addAttribute("termsTypeCodes", comCodeMapper.selectCodeListByGrp("TERMS_TYPE_CD"));
        return "portal/board/terms/termsList";
    }

    /* ── 목록 JSON ───────────────────────────────────── */
    @GetMapping("/list/json")
    @ResponseBody
    public List<TermsVO> listJson(
            @RequestParam(required = false) String appType,
            @RequestParam(required = false) String termsType) {

        TermsVO condition = new TermsVO();
        condition.setSearchAppType(appType);
        condition.setSearchTermsType(termsType);
        return termsService.getList(condition);
    }

    /* ── 단건 조회 ───────────────────────────────────── */
    @GetMapping("/one")
    @ResponseBody
    public TermsVO one(@RequestParam Long termsNo) {
        return termsService.getOne(termsNo);
    }

    /* ── 저장 (등록/수정) ────────────────────────────── */
    @PostMapping("/save")
    @ResponseBody
    public Map<String, String> save(@RequestBody TermsVO vo) {
        termsService.save(vo);
        Map<String, String> result = new HashMap<>();
        result.put("result", "success");
        return result;
    }

    /* ── 삭제 ────────────────────────────────────────── */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, String> delete(@RequestParam Long termsNo) {
        termsService.delete(termsNo);
        Map<String, String> result = new HashMap<>();
        result.put("result", "success");
        return result;
    }
}
