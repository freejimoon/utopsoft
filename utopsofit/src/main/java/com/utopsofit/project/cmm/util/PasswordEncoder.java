package com.utopsofit.project.cmm.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * BCrypt 비밀번호 해시 생성 유틸리티
 * main 메서드 직접 실행하여 초기 비밀번호 생성에 사용
 */
public class PasswordEncoder {

    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        // ─── 여기에 생성할 비밀번호를 입력하세요 ───────────────────────
        String[] passwords = {
            "1234",
            "admin1234",
            "utopsoft1!"
        };
        // ──────────────────────────────────────────────────────────────

        System.out.println("=".repeat(60));
        System.out.println("  BCrypt 비밀번호 해시 생성 결과");
        System.out.println("=".repeat(60));

        for (String raw : passwords) {
            String hashed = encoder.encode(raw);
            System.out.printf("%-20s → %s%n", raw, hashed);
        }

        System.out.println("=".repeat(60));
        System.out.println();

        // 검증 예시
        System.out.println("[검증 예시]");
        String sample = "1234";
        String hash   = encoder.encode(sample);
        System.out.printf("원문: %-10s | 해시: %s%n", sample, hash);
        System.out.printf("검증 결과: %s%n", encoder.matches(sample, hash) ? "일치 ✓" : "불일치 ✗");
    }

    /**
     * 단일 비밀번호 인코딩 (다른 클래스에서 재사용 가능)
     */
    public static String encode(String rawPassword) {
        return new BCryptPasswordEncoder().encode(rawPassword);
    }

    /**
     * 비밀번호 일치 여부 확인
     */
    public static boolean matches(String rawPassword, String encodedPassword) {
        return new BCryptPasswordEncoder().matches(rawPassword, encodedPassword);
    }
}
