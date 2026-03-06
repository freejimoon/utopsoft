package com.utopsofit.project.portal.member.controller;

import com.utopsofit.project.portal.code.service.ComCodeService;
import com.utopsofit.project.portal.member.domain.MemberVO;
import com.utopsofit.project.portal.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 개인 회원 관리 컨트롤러
 * GET /member/active/list       → 회원 현황 화면
 * GET /member/active/list/json  → Ajax 데이터
 * GET /member/withdraw/list     → 탈퇴 회원 화면
 * GET /member/withdraw/list/json
 * GET /member/dormant/list      → 휴면 회원 화면
 * GET /member/dormant/list/json
 */
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService  memberService;
    private final ComCodeService comCodeService;

    private void addSearchCodes(Model model) {
        model.addAttribute("membershipCodes", comCodeService.getCodeList("MEMBERSHIP_TYPE_CD"));
        model.addAttribute("socialCodes",     comCodeService.getCodeList("SOCIAL_TYPE_CD"));
    }

    /* ── 회원 현황 ───────────────────────────── */
    @GetMapping("/active/list")
    public String activeList(Model model) {
        addSearchCodes(model);
        return "portal/member/memberList";
    }

    @GetMapping("/active/list/json")
    @ResponseBody
    public ResponseEntity<List<MemberVO>> activeListJson(@ModelAttribute MemberVO cond) {
        return ResponseEntity.ok(memberService.getActiveList(cond));
    }

    /* ── 탈퇴 회원 ───────────────────────────── */
    @GetMapping("/withdraw/list")
    public String withdrawList(Model model) {
        addSearchCodes(model);
        return "portal/member/withdrawList";
    }

    @GetMapping("/withdraw/list/json")
    @ResponseBody
    public ResponseEntity<List<MemberVO>> withdrawListJson(@ModelAttribute MemberVO cond) {
        return ResponseEntity.ok(memberService.getWithdrawList(cond));
    }

    /* ── 휴면 회원 ───────────────────────────── */
    @GetMapping("/dormant/list")
    public String dormantList(Model model) {
        addSearchCodes(model);
        return "portal/member/dormantList";
    }

    @GetMapping("/dormant/list/json")
    @ResponseBody
    public ResponseEntity<List<MemberVO>> dormantListJson(@ModelAttribute MemberVO cond) {
        return ResponseEntity.ok(memberService.getDormantList(cond));
    }
}
