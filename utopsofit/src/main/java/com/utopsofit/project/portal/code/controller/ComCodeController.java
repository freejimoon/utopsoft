package com.utopsofit.project.portal.code.controller;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.utopsofit.project.portal.code.domain.ComCode;
import com.utopsofit.project.portal.code.domain.ComCodeGrp;
import com.utopsofit.project.portal.code.service.ComCodeService;

import lombok.RequiredArgsConstructor;

/**
 * 공통코드 관리 컨트롤러
 */
@Controller
@RequestMapping("/code")
@RequiredArgsConstructor
public class ComCodeController {

    private final ComCodeService comCodeService;

    private static final int DEFAULT_PAGE_SIZE = 10;

    /** 그룹 목록 (GET: 최초진입·리다이렉트, POST: 검색·페이징) */
    @RequestMapping("/grp/list")
    public String grpList(@RequestParam(required = false) String grpCd,
                          @RequestParam(required = false) String grpNm,
                          @RequestParam(required = false) String useYn,
                          @RequestParam(required = false) Integer page,
                          @RequestParam(required = false) Integer size,
                          Model model) {
        ComCodeGrp condition = new ComCodeGrp();
        condition.setGrpCd(grpCd != null ? grpCd : (String) model.asMap().get("condGrpCd"));
        condition.setGrpNm(grpNm != null ? grpNm : (String) model.asMap().get("condGrpNm"));
        condition.setUseYn(useYn != null ? useYn : (String) model.asMap().get("condUseYn"));
        int p = page != null ? page : (model.asMap().get("page") instanceof Integer ? (Integer) model.asMap().get("page") : 1);
        int s = size != null ? size : DEFAULT_PAGE_SIZE;
        if (s < 1 || s > 100) s = DEFAULT_PAGE_SIZE;
        model.addAttribute("condition", condition);
        model.addAttribute("pageResult", comCodeService.getCodeGrpPage(condition, p, s));
        return "portal/code/grpList";
    }

    /** 그룹 등록/수정 폼 (POST 전용 - forward로 뷰 반환) */
    @PostMapping("/grp/form")
    public String grpForm(@RequestParam(required = false) String grpCd, Model model) {
        if (grpCd != null && !grpCd.isEmpty()) {
            model.addAttribute("grp", comCodeService.getCodeGrp(grpCd));
        } else {
            model.addAttribute("grp", new ComCodeGrp());
        }
        return "portal/code/grpForm";
    }

    /** 그룹 저장 */
    @PostMapping("/grp/save")
    public String grpSave(@ModelAttribute ComCodeGrp grp, RedirectAttributes ra) {
        if (grp.getUseYn() == null || grp.getUseYn().isEmpty()) grp.setUseYn("Y");
        comCodeService.saveCodeGrp(grp);
        ra.addFlashAttribute("message", "저장되었습니다.");
        return "redirect:/code/grp/list";
    }

    /** 그룹 삭제 */
    @PostMapping("/grp/delete")
    public String grpDelete(@RequestParam String grpCd,
                            @RequestParam(defaultValue = "1") int page,
                            @RequestParam(required = false) String condGrpCd,
                            @RequestParam(required = false) String condGrpNm,
                            @RequestParam(required = false) String condUseYn,
                            RedirectAttributes ra) {
        comCodeService.removeCodeGrp(grpCd);
        ra.addFlashAttribute("message", "삭제되었습니다.");
        ra.addFlashAttribute("page", page);
        ra.addFlashAttribute("condGrpCd", condGrpCd);
        ra.addFlashAttribute("condGrpNm", condGrpNm);
        ra.addFlashAttribute("condUseYn", condUseYn);
        return "redirect:/code/grp/list";
    }

    /** 그룹 목록 JSON API - DataTables Ajax 용 */
    @GetMapping("/grp/list/json")
    @ResponseBody
    public ResponseEntity<List<ComCodeGrp>> grpListJson() {
        return ResponseEntity.ok(comCodeService.getCodeGrpList(new ComCodeGrp()));
    }

    /** 코드 목록 JSON API - DataTables Ajax 용 */
    @GetMapping("/list/json")
    @ResponseBody
    public ResponseEntity<List<ComCode>> codeListJson(@RequestParam String grpCd) {
        if (grpCd == null || grpCd.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(comCodeService.getCodeList(grpCd));
    }

    /** 코드 목록 (GET: 리다이렉트, POST: 페이징·진입) */
    @RequestMapping("/list")
    public String codeList(@RequestParam(required = false) String grpCd,
                           @RequestParam(required = false) Integer page,
                           @RequestParam(required = false) Integer size,
                           Model model) {
        String g = grpCd != null && !grpCd.isEmpty() ? grpCd : (String) model.asMap().get("grpCd");
        if (g == null || g.isEmpty()) return "redirect:/code/grp/list";
        int p = page != null ? page : (model.asMap().get("page") instanceof Integer ? (Integer) model.asMap().get("page") : 1);
        int s = size != null ? size : DEFAULT_PAGE_SIZE;
        if (s < 1 || s > 100) s = DEFAULT_PAGE_SIZE;
        ComCodeGrp grp = comCodeService.getCodeGrp(g);
        if (grp == null) return "redirect:/code/grp/list";
        model.addAttribute("grp", grp);
        model.addAttribute("pageResult", comCodeService.getCodePage(g, p, s));
        return "portal/code/codeList";
    }

    /** 코드 등록/수정 폼 (POST 전용 - forward로 뷰 반환) */
    @PostMapping("/form")
    public String codeForm(@RequestParam(required = false) String grpCd,
                           @RequestParam(required = false) String code,
                           Model model) {
        String g = grpCd != null && !grpCd.isEmpty() ? grpCd : (String) model.asMap().get("grpCd");
        if (g == null || g.isEmpty()) return "redirect:/code/grp/list";
        model.addAttribute("grp", comCodeService.getCodeGrp(g));
        if (code != null && !code.isEmpty()) {
            model.addAttribute("item", comCodeService.getCode(g, code));
        } else {
            ComCode item = new ComCode();
            item.setGrpCd(g);
            item.setUseYn("Y");
            model.addAttribute("item", item);
        }
        return "portal/code/codeForm";
    }

    /** 코드 저장 */
    @PostMapping("/save")
    public String codeSave(@ModelAttribute("item") ComCode item, RedirectAttributes ra) {
        if (item.getUseYn() == null || item.getUseYn().isEmpty()) item.setUseYn("Y");
        comCodeService.saveCode(item);
        ra.addFlashAttribute("message", "저장되었습니다.");
        ra.addFlashAttribute("grpCd", item.getGrpCd());
        ra.addFlashAttribute("page", 1);
        return "redirect:/code/list";
    }

    /** 코드 삭제 */
    @PostMapping("/delete")
    public String codeDelete(@RequestParam String grpCd,
                             @RequestParam String code,
                             @RequestParam(defaultValue = "1") int page,
                             RedirectAttributes ra) {
        comCodeService.removeCode(grpCd, code);
        ra.addFlashAttribute("message", "삭제되었습니다.");
        ra.addFlashAttribute("grpCd", grpCd);
        ra.addFlashAttribute("page", page);
        return "redirect:/code/list";
    }
}
