package com.utopsofit.project.portal.board.inquiry.controller;

import com.utopsofit.project.portal.board.inquiry.domain.InquiryVO;
import com.utopsofit.project.portal.board.inquiry.service.InquiryService;
import com.utopsofit.project.portal.code.dao.ComCodeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board/inquiry")
@RequiredArgsConstructor
public class InquiryController {

    private final InquiryService  inquiryService;
    private final ComCodeMapper   comCodeMapper;

    /** 목록 화면 */
    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("statusCodes", comCodeMapper.selectCodeListByGrp("INQ_STATUS"));
        return "portal/board/inquiry/inquiryList";
    }

    /** DataTables Ajax */
    @GetMapping("/list/json")
    @ResponseBody
    public List<InquiryVO> listJson(InquiryVO condition) {
        return inquiryService.getList(condition);
    }

    /** 단건 조회 (상세 모달) */
    @GetMapping("/one")
    @ResponseBody
    public ResponseEntity<InquiryVO> one(@RequestParam Long inqNo) {
        InquiryVO vo = inquiryService.getOne(inqNo);
        if (vo == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(vo);
    }

    /** 답변 등록 */
    @PostMapping("/reply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> reply(@RequestBody InquiryVO vo) {
        try {
            inquiryService.saveReply(vo);
            return ResponseEntity.ok(Map.of("result", "success"));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("result", "error", "message", e.getMessage()));
        }
    }
}
