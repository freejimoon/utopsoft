package com.utopsofit.project.portal.board.notice.controller;

import com.utopsofit.project.portal.board.notice.domain.NoticeVO;
import com.utopsofit.project.portal.board.notice.service.NoticeService;
import com.utopsofit.project.portal.code.service.ComCodeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
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
 * 공지사항 컨트롤러 (관리자 포털)
 */
@Controller
@RequestMapping("/board/notice")
@RequiredArgsConstructor
@Tag(name = "공지사항", description = "앱 공지사항 API")
public class NoticeController {

    private final NoticeService  noticeService;
    private final ComCodeService comCodeService;

    /* ── 관리자 목록 뷰 ─────────────────────────────── */
    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("noticeTypeCodes", comCodeService.getCodeList("NOTICE_TYPE_CD"));
        return "portal/board/notice/noticeList";
    }

    /* ── 목록 JSON (DataTables) ────────── */
    @GetMapping("/list/json")
    @ResponseBody
    @Operation(
        summary     = "공지사항 목록 조회",
        description = "사용 중인 공지사항 목록을 반환합니다.\n\n" +
                      "- 상단 고정(pin_yn=Y) 항목이 먼저 표시됩니다.\n" +
                      "- `type` 및 `keyword` 파라미터로 필터링할 수 있습니다."
    )
    public List<NoticeVO> listJson(
            @Parameter(description = "공지 유형 (GENERAL / URGENT / EVENT)", example = "GENERAL")
            @RequestParam(required = false) String type,

            @Parameter(description = "제목 키워드 검색", example = "점검")
            @RequestParam(required = false) String keyword) {

        NoticeVO condition = new NoticeVO();
        condition.setSearchType(type);
        condition.setSearchKeyword(keyword);
        return noticeService.getList(condition);
    }

    /* ── 단건 조회 (모달) ────────────────────────────── */
    @GetMapping("/one")
    @ResponseBody
    public NoticeVO one(@RequestParam Long noticeNo) {
        return noticeService.getOne(noticeNo);
    }

    /* ── 저장 (등록/수정) ────────────────────────────── */
    @PostMapping("/save")
    @ResponseBody
    public Map<String, String> save(@RequestBody NoticeVO vo) {
        noticeService.save(vo);
        Map<String, String> result = new HashMap<>();
        result.put("result", "success");
        return result;
    }

    /* ── 삭제 ────────────────────────────────────────── */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, String> delete(@RequestParam Long noticeNo) {
        noticeService.delete(noticeNo);
        Map<String, String> result = new HashMap<>();
        result.put("result", "success");
        return result;
    }
}
