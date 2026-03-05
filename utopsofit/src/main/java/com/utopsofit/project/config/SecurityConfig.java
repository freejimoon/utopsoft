package com.utopsofit.project.config;

import com.utopsofit.project.cmm.filter.JwtAuthFilter;
import com.utopsofit.project.portal.login.service.LoginFailureHandler;
import com.utopsofit.project.portal.login.service.LoginSuccessHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Spring Security 설정
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final LoginSuccessHandler loginSuccessHandler;
    private final LoginFailureHandler loginFailureHandler;
    private final JwtAuthFilter       jwtAuthFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            /* REST API 는 세션/CSRF 불필요 — /api/** 경로만 예외 적용 */
            .csrf(csrf -> csrf
                .ignoringRequestMatchers("/api/**")
            )
            /* JWT 필터: UsernamePasswordAuthenticationFilter 앞에 실행 */
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers(
                        "/login", "/login/process",
                        "/css/**", "/js/**", "/images/**",
                        "/error", "/WEB-INF/**",
                        /* Swagger UI */
                        "/swagger-ui/**", "/swagger-ui.html",
                        "/v3/api-docs/**", "/v3/api-docs",
                        /* 토큰 발급은 인증 불필요 */
                        "/api/token"
                ).permitAll()
                /* /api/faq/** 등 나머지 API 는 JWT 인증 필요 */
                .requestMatchers("/api/**").authenticated()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login/process")
                .usernameParameter("username")
                .passwordParameter("password")
                .successHandler(loginSuccessHandler)
                .failureHandler(loginFailureHandler)
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Spring Boot 가 JwtAuthFilter 를 서블릿 기본 필터 체인에 자동 등록하는 것을 방지.
     * 필터는 Security 필터 체인(addFilterBefore) 에서만 동작해야 SecurityContext 가 정상 유지됨.
     */
    @Bean
    public FilterRegistrationBean<JwtAuthFilter> jwtFilterRegistration(JwtAuthFilter filter) {
        FilterRegistrationBean<JwtAuthFilter> registration = new FilterRegistrationBean<>(filter);
        registration.setEnabled(false);
        return registration;
    }
}
