package com.utopsofit.project.portal.code.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.utopsofit.project.portal.code.domain.ComCode;
import com.utopsofit.project.portal.code.domain.ComCodeGrp;

/**
 * 공통코드 MyBatis Mapper (DAO)
 */
@Mapper
public interface ComCodeMapper {

    /* 그룹 */
    List<ComCodeGrp> selectCodeGrpList(ComCodeGrp condition);
    long countCodeGrpList(ComCodeGrp condition);
    List<ComCodeGrp> selectCodeGrpListPaging(@Param("condition") ComCodeGrp condition, @Param("offset") int offset, @Param("limit") int limit);
    ComCodeGrp selectCodeGrpByPk(@Param("grpCd") String grpCd);
    int insertCodeGrp(ComCodeGrp grp);
    int updateCodeGrp(ComCodeGrp grp);
    int deleteCodeGrp(@Param("grpCd") String grpCd);

    /* 코드 */
    List<ComCode> selectCodeListByGrp(@Param("grpCd") String grpCd);
    long countCodeListByGrp(@Param("grpCd") String grpCd);
    List<ComCode> selectCodeListByGrpPaging(@Param("grpCd") String grpCd, @Param("offset") int offset, @Param("limit") int limit);
    ComCode selectCodeByPk(@Param("grpCd") String grpCd, @Param("code") String code);
    int insertCode(ComCode code);
    int updateCode(ComCode code);
    int deleteCode(@Param("grpCd") String grpCd, @Param("code") String code);
}
