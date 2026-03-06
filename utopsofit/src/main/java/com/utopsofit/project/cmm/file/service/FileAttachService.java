package com.utopsofit.project.cmm.file.service;

import com.utopsofit.project.cmm.file.domain.FileAttachVO;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface FileAttachService {

    /** 첨부파일 목록 조회 */
    List<FileAttachVO> getList(String refType, Long refNo);

    /** 파일 저장 (업로드) */
    FileAttachVO upload(String refType, Long refNo, MultipartFile file, String loginUser) throws IOException;

    /** 단건 조회 (다운로드용) */
    FileAttachVO getOne(Long attachNo);

    /** 파일 삭제 (DB + 물리 파일) */
    void delete(Long attachNo) throws IOException;

    /** 참조 엔티티 전체 삭제 (엔티티 삭제 시 연쇄) */
    void deleteByRef(String refType, Long refNo);
}
