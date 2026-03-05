package com.utopsofit.project.portal.login.service;

import java.util.Collections;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.utopsofit.project.portal.login.dao.UsrMapper;
import com.utopsofit.project.portal.login.domain.Usr;

import lombok.RequiredArgsConstructor;

/**
 * Spring Security UserDetailsService 구현
 */
@Service
@RequiredArgsConstructor
public class UsrDetailsService implements UserDetailsService {

    private final UsrMapper usrMapper;

    @Override
    public UserDetails loadUserByUsername(String usrId) throws UsernameNotFoundException {
        Usr usr = usrMapper.selectUsrById(usrId);

        if (usr == null) {
            throw new UsernameNotFoundException("존재하지 않는 사용자입니다: " + usrId);
        }
        if (!"Y".equals(usr.getUseYn())) {
            throw new UsernameNotFoundException("비활성화된 계정입니다: " + usrId);
        }
        if ("Y".equals(usr.getLockYn())) {
            throw new UsernameNotFoundException("잠긴 계정입니다: " + usrId);
        }

        return User.builder()
                .username(usr.getUsrId())
                .password(usr.getUsrPw())
                .authorities(Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + usr.getRoleCd())))
                .build();
    }
}
