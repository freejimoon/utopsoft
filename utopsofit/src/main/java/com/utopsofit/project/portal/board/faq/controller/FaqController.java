package com.utopsofit.project.portal.board.faq.controller;

import com.utopsofit.project.portal.board.faq.domain.FaqVO;
import com.utopsofit.project.portal.board.faq.service.FaqService;
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
 * FAQ 컨트롤러
 */
@Controller
@RequestMapping("/board/faq")
@RequiredArgsConstructor
public class FaqController {

    private final FaqService faqService;

    /* ── 목록 뷰 ─────────────────────────────────────── */
    @GetMapping("/list")
    public String list(Model model) {
        return "portal/board/faq/faqList";
    }

    /* ── 목록 JSON (DataTables Ajax) ─────────────────── */
    @GetMapping("/list/json")
    @ResponseBody
    public List<FaqVO> listJson(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword) {

        FaqVO condition = new FaqVO();
        condition.setSearchCategory(category);
        condition.setSearchKeyword(keyword);
        return faqService.getList(condition);
    }

    /* ── 단건 조회 (모달) ────────────────────────────── */
    @GetMapping("/one")
    @ResponseBody
    public FaqVO one(@RequestParam Long faqNo) {
        return faqService.getOne(faqNo);
    }

    /* ── 저장 (등록/수정) ────────────────────────────── */
    @PostMapping("/save")
    @ResponseBody
    public Map<String, String> save(@RequestBody FaqVO vo) {
        faqService.save(vo);
        Map<String, String> result = new HashMap<>();
        result.put("result", "success");
        return result;
    }

    /* ── 삭제 ────────────────────────────────────────── */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, String> delete(@RequestParam Long faqNo) {
        faqService.delete(faqNo);
        Map<String, String> result = new HashMap<>();
        result.put("result", "success");
        return result;
    }
}
