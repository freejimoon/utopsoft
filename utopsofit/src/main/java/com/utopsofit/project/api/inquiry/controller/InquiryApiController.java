package com.utopsofit.project.api.inquiry.controller;

import com.utopsofit.project.cmm.util.ApiResponse;
import com.utopsofit.project.api.inquiry.domain.InquiryApiRequest;
import com.utopsofit.project.portal.board.inquiry.dao.InquiryMapper;
import com.utopsofit.project.portal.board.inquiry.domain.InquiryVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 문의 앱 API
 */
@RestController
@RequestMapping("/api/inquiry")
@RequiredArgsConstructor
@Tag(name = "문의관리", description = "앱 문의 API")
public class InquiryApiController {

    private final InquiryMapper inquiryMapper;

    @GetMapping("/list")
    @Operation(
        summary     = "문의 목록 조회",
        description = "앱 회원의 문의 목록을 반환합니다.\n\n" +
                      "- `memberNo` 파라미터로 특정 회원의 문의만 필터링할 수 있습니다.\n" +
                      "- `status` 파라미터로 상태별 조회가 가능합니다. (WAIT: 대기중 / DONE: 답변완료)"
    )
    public ResponseEntity<ApiResponse<List<InquiryVO>>> list(
            @Parameter(description = "회원번호 (전달 시 해당 회원 문의만 조회)", example = "1")
            @RequestParam(required = false) Long memberNo,

            @Parameter(description = "문의 상태 필터 (WAIT / DONE)", example = "WAIT")
            @RequestParam(required = false) String status) {

        InquiryVO condition = new InquiryVO();
        condition.setMemberNo(memberNo);
        condition.setSearchStatus(status);

        List<InquiryVO> list = inquiryMapper.selectList(condition);
        return ResponseEntity.ok(ApiResponse.ok(list));
    }

    @PostMapping
    @Operation(
        summary     = "문의 등록",
        description = "앱 회원이 문의를 등록합니다.\n\n" +
                      "- 등록된 문의는 관리자 포털 **문의 관리** 화면에서 확인할 수 있습니다.\n" +
                      "- 초기 상태는 **대기중(WAIT)** 으로 자동 설정됩니다."
    )
    public ResponseEntity<ApiResponse<Void>> submit(@RequestBody InquiryApiRequest request) {
        InquiryVO vo = new InquiryVO();
        vo.setMemberNo(request.getMemberNo());
        vo.setTitle(request.getTitle());
        vo.setContent(request.getContent());

        inquiryMapper.insert(vo);
        return ResponseEntity.ok(ApiResponse.ok());
    }
}
