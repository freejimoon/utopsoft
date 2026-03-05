package com.utopsofit.project.portal.system.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.utopsofit.project.portal.system.domain.AppVersionVO;

/**
 * 앱 버전 관리 Mapper
 */
@Mapper
public interface AppVersionMapper {

    /** 버전 목록 조회 (공통코드 명칭 JOIN, 검색 조건 포함) */
    List<AppVersionVO> selectList(AppVersionVO condition);

    /** 버전 단건 조회 */
    AppVersionVO selectByPk(@Param("versionNo") Long versionNo);

    /** 등록 */
    void insert(AppVersionVO vo);

    /** 수정 */
    void update(AppVersionVO vo);

    /** 삭제 */
    void delete(@Param("versionNo") Long versionNo);
}
