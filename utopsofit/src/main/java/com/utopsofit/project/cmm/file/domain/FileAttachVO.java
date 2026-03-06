package com.utopsofit.project.cmm.file.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 공통 첨부파일 VO
 * ref_type + ref_no 조합으로 어느 엔티티든 첨부파일 연결 가능
 */
@Getter
@Setter
public class FileAttachVO {

    private Long          attachNo;
    private String        refType;       // 참조 엔티티 유형 (FAQ, NOTICE ...)
    private Long          refNo;         // 참조 엔티티 PK
    private String        origNm;        // 원본 파일명
    private String        saveNm;        // 저장 파일명 (UUID.ext)
    private String        filePath;      // 저장 경로
    private Long          fileSize;      // 파일 크기 (bytes)
    private String        fileExt;       // 확장자 (소문자)
    private LocalDateTime createdAt;
    private String        createdBy;
}
