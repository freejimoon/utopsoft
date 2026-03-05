package com.utopsofit.project.portal.login.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.utopsofit.project.portal.login.domain.Usr;

/**
 * 사용자 MyBatis Mapper
 */
@Mapper
public interface UsrMapper {

    Usr selectUsrById(@Param("usrId") String usrId);

    int updateLastLogin(@Param("usrId") String usrId);

    int updateLoginFailCnt(@Param("usrId") String usrId, @Param("loginFailCnt") int loginFailCnt);

    int updateLockYn(@Param("usrId") String usrId, @Param("lockYn") String lockYn);
}
