package com.utopsofit.project.api.faq.controller;

import com.utopsofit.project.api.faq.domain.FaqApiRequest;
import com.utopsofit.project.api.faq.domain.FaqApiResponse;
import com.utopsofit.project.cmm.util.ApiResponse;
import com.utopsofit.project.portal.board.faq.dao.FaqMapper;
import com.utopsofit.project.portal.board.faq.domain.FaqVO;
import com.utopsofit.project.portal.code.domain.PageResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Tag(name = "FAQ API")
@RestController
@RequestMapping("/api/faq")
@RequiredArgsConstructor
public class FaqApiController {

    private final FaqMapper faqMapper;

    /** 목록 조회 (페이징) — ?page=1&size=10&categoryCd=FAQ001 */
    @Operation(summary = "FAQ 목록 조회")
    @GetMapping("/list")
    public ResponseEntity<ApiResponse<PageResult<FaqApiResponse>>> list(
            @RequestParam(required = false) String categoryCd,
            @RequestParam(defaultValue = "1")  int page,
            @RequestParam(defaultValue = "10") int size) {

        FaqApiRequest req = new FaqApiRequest();
        req.setCategoryCd(categoryCd);
        req.setPage(page);
        req.setSize(size);

        long totalCount = faqMapper.selectTotalCount(req);
        List<FaqApiResponse> list = faqMapper.selectPageList(req)
                .stream().map(FaqApiResponse::from).collect(Collectors.toList());

        return ResponseEntity.ok(ApiResponse.ok(PageResult.of(list, totalCount, page, req.getLimit())));
    }

    /** 단건 조회 */
    @Operation(summary = "FAQ 단건 조회")
    @GetMapping("/{faqNo}")
    public ResponseEntity<ApiResponse<FaqApiResponse>> getOne(@PathVariable Long faqNo) {
        FaqVO vo = faqMapper.selectOne(faqNo);
        if (vo == null) return ResponseEntity.ok(ApiResponse.error(404, "FAQ를 찾을 수 없습니다."));
        return ResponseEntity.ok(ApiResponse.ok(FaqApiResponse.from(vo)));
    }
}
