package com.utopsofit.project.cmm.file.dao;

import com.utopsofit.project.cmm.file.domain.FileAttachVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FileAttachMapper {

    /** 첨부파일 목록 조회 */
    List<FileAttachVO> selectList(@Param("refType") String refType, @Param("refNo") Long refNo);

    /** 첨부파일 건수 조회 */
    int countByRef(@Param("refType") String refType, @Param("refNo") Long refNo);

    /** 단건 조회 */
    FileAttachVO selectOne(@Param("attachNo") Long attachNo);

    /** 등록 */
    int insert(FileAttachVO vo);

    /** 삭제 (물리 삭제) */
    int delete(@Param("attachNo") Long attachNo);

    /** 참조 엔티티 전체 삭제 (FAQ 삭제 시 연쇄 삭제용) */
    int deleteByRef(@Param("refType") String refType, @Param("refNo") Long refNo);
}
