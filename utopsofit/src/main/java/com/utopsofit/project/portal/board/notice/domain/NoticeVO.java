package com.utopsofit.project.portal.board.notice.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 공지사항 VO
 */
@Getter
@Setter
@Schema(description = "공지사항")
public class NoticeVO {

    @Schema(description = "공지번호", example = "1")
    private Long noticeNo;

    @Schema(description = "제목", example = "서버 점검 안내")
    private String title;

    @Schema(description = "내용")
    private String content;

    @Schema(description = "공지 유형 코드 (GENERAL/URGENT/EVENT)", example = "GENERAL")
    private String noticeType;

    @Schema(description = "공지 유형명", example = "일반")
    private String noticeTypeNm;

    @Schema(description = "상단 고정 여부 (Y/N)", example = "N")
    private String pinYn;

    @Schema(description = "조회수", example = "120")
    private Integer viewCnt;

    @Schema(description = "등록일시", example = "2026-03-01T09:00:00")
    private LocalDateTime createdAt;
    private String        createdBy;
    private LocalDateTime updatedAt;
    private String        updatedBy;

    /* 검색 조건 */
    private String searchType;
    private String searchKeyword;
}
