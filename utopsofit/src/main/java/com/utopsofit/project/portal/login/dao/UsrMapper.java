package com.utopsofit.project.portal.login.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.utopsofit.project.portal.login.domain.Usr;

import java.util.List;

/**
 * 사용자 MyBatis Mapper
 */
@Mapper
public interface UsrMapper {

    Usr selectUsrById(@Param("usrId") String usrId);

    int updateLastLogin(@Param("usrId") String usrId);

    int updateLoginFailCnt(@Param("usrId") String usrId, @Param("loginFailCnt") int loginFailCnt);

    int updateLockYn(@Param("usrId") String usrId, @Param("lockYn") String lockYn);

    /** 마지막 로그인이 inactiveDays일 이상 경과한 미잠금 사용자 조회 (배치용) */
    List<Usr> selectInactiveUsrs(@Param("inactiveDays") int inactiveDays);

    /** 마지막 로그인이 inactiveDays일 이상 경과한 사용자 일괄 잠금 처리 (배치용) */
    int lockInactiveUsrs(@Param("inactiveDays") int inactiveDays);
}
