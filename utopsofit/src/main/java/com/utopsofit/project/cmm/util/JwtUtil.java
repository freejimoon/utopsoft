package com.utopsofit.project.cmm.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Base64;
import java.util.Date;

/**
 * JWT 생성 / 검증 유틸리티
 * - 토큰 주체(sub): appId
 * - 만료시간: application.properties jwt.expiration-sec 참조
 */
@Component
public class JwtUtil {

    private final SecretKey key;
    private final long expirationMs;

    public JwtUtil(
            @Value("${jwt.secret}") String base64Secret,
            @Value("${jwt.expiration-sec:86400}") long expirationSec) {
        this.key          = Keys.hmacShaKeyFor(Base64.getDecoder().decode(base64Secret));
        this.expirationMs = expirationSec * 1000L;
    }

    /** JWT 생성 */
    public String generate(String appId) {
        Date now    = new Date();
        Date expiry = new Date(now.getTime() + expirationMs);
        return Jwts.builder()
                .subject(appId)
                .issuedAt(now)
                .expiration(expiry)
                .signWith(key)
                .compact();
    }

    /** 만료 시간(초) 반환 */
    public long getExpirationSec() {
        return expirationMs / 1000L;
    }

    /** 토큰 검증 후 Claims 반환 — 만료·위변조 시 예외 발생 */
    public Claims parse(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /** appId 추출 */
    public String getAppId(String token) {
        return parse(token).getSubject();
    }
}
