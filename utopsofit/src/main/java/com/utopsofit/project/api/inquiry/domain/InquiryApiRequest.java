package com.utopsofit.project.api.inquiry.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

/**
 * 앱 문의 등록 요청 DTO
 */
@Getter
@Setter
@Schema(description = "문의 등록 요청")
public class InquiryApiRequest {

    @Schema(description = "회원번호", example = "1", requiredMode = Schema.RequiredMode.REQUIRED)
    private Long memberNo;

    @Schema(description = "제목", example = "앱 실행이 안돼요", requiredMode = Schema.RequiredMode.REQUIRED)
    private String title;

    @Schema(description = "문의 내용", example = "앱을 실행하면 바로 종료됩니다.", requiredMode = Schema.RequiredMode.REQUIRED)
    private String content;
    
    @Schema(description = "문의11 내용", example = "앱을 실행하면 바로 종료됩니다.", requiredMode = Schema.RequiredMode.REQUIRED)
    private String test;
}
