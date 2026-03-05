package com.utopsofit.project.portal.system.dao;

import com.utopsofit.project.portal.system.domain.AppClientVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AppClientMapper {

    List<AppClientVO> selectList(AppClientVO condition);

    AppClientVO selectByPk(@Param("appId") String appId);

    int insert(AppClientVO vo);

    int update(AppClientVO vo);

    int delete(@Param("appId") String appId);

    /** Secret 재발급 — 해시값만 업데이트 */
    int updateSecret(@Param("appId") String appId, @Param("appSecret") String appSecret);

    /** appId 중복 체크 */
    int countById(@Param("appId") String appId);
}
