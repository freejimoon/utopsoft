package com.utopsofit.project.portal.member.controller;

import com.utopsofit.project.portal.code.dao.ComCodeMapper;
import com.utopsofit.project.portal.member.domain.GroupMemberVO;
import com.utopsofit.project.portal.member.service.GroupMemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 단체 회원 관리 컨트롤러
 * GET /member/group/list       → 단체 회원 화면
 * GET /member/group/list/json  → Ajax 데이터 (searchGroupCd, searchKeyword)
 */
@Controller
@RequestMapping("/member/group")
@RequiredArgsConstructor
public class GroupMemberController {

    private final GroupMemberService groupMemberService;
    private final ComCodeMapper      comCodeMapper;

    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("groupTypeCodes", comCodeMapper.selectCodeListByGrp("GROUP_TYPE_CD"));
        return "portal/member/groupMemberList";
    }

    @GetMapping("/list/json")
    @ResponseBody
    public ResponseEntity<List<GroupMemberVO>> listJson(
            @RequestParam(required = false) String searchGroupCd,
            @RequestParam(required = false) String searchKeyword) {
        GroupMemberVO cond = new GroupMemberVO();
        cond.setSearchGroupCd(searchGroupCd);
        cond.setSearchKeyword(searchKeyword);
        return ResponseEntity.ok(groupMemberService.getList(cond));
    }
}
