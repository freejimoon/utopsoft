package com.utopsofit.project.portal.member.domain;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 회원 VO — member 테이블 기준
 * status_cd: ACTIVE(활성) / DORMANT(휴면) / WITHDRAWN(탈퇴)
 */
@Getter
@Setter
public class MemberVO {

    /* 기본 정보 */
    private Long          memberNo;         // 회원번호 (PK)
    private String        memberId;         // 회원 로그인 ID
    private String        memberNm;         // 닉네임
    private String        realNm;           // 실명
    private String        email;            // 이메일
    private String        phone;            // 휴대폰
    private String        genderCd;         // 성별 → GENDER (M/F)
    private LocalDate     birthDt;          // 생년월일

    /* 소셜 로그인 */
    private String        socialCd;         // 소셜 유형 → SOCIAL_TYPE_CD
    private String        socialNm;         // 소셜 유형명 (com_code JOIN)

    /* 회원 유형 / 구독 */
    private String        membershipCd;     // 회원유형 → MEMBERSHIP_TYPE_CD (FREE/PAID/GROUP)
    private String        membershipNm;     // 회원유형명 (com_code JOIN)
    private String        subStatusCd;      // 구독상태 → SUB_STATUS_CD
    private String        subStatusNm;      // 구독상태명 (com_code JOIN)
    private String        subPlanCd;        // 구독 플랜 → SUB_PLAN_CD
    private LocalDate     subStartDt;       // 구독 시작일
    private LocalDate     subEndDt;         // 구독 만료일
    private String        subAutoYn;        // 자동 갱신 (Y/N)

    /* 단체 소속 */
    private Long          groupNo;          // 소속 단체번호
    private String        groupNm;          // 소속 단체명 (JOIN)
    private String        groupRoleCd;      // 단체 내 역할 → GROUP_ROLE (ADMIN/MEMBER)

    /* 계정 상태 */
    private String        statusCd;         // 계정상태 → MEMBER_STATUS_CD
    private String        gradeCd;          // 등급 → MEMBER_GRADE_CD
    private String        gradeNm;          // 등급명 (com_code JOIN)

    /* 일시 */
    private LocalDateTime joinDt;           // 가입일시
    private LocalDateTime lastLoginDt;      // 최종 로그인 일시
    private LocalDateTime withdrawDt;       // 탈퇴 일시
    private LocalDateTime updatedAt;        // 수정일시 (휴면 처리일 대용)

    /* 검색 조건 */
    private String        searchMemberId;       // 회원 ID 검색
    private String        searchMemberNm;       // 닉네임 검색
    private String        searchEmail;          // 이메일 검색
    private String        searchGroupNm;        // 단체명 검색
    private String        searchMembershipCd;   // 회원유형 검색
    private String        searchSocialCd;       // 소셜 유형 검색
    private String        searchJoinFrom;       // 가입일시 from
    private String        searchJoinTo;         // 가입일시 to
}
