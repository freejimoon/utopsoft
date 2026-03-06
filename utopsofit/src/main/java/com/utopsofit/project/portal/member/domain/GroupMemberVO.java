package com.utopsofit.project.portal.member.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * 단체 회원 VO — member_group 테이블 기준
 * contract_status_cd: ACTIVE(계약중) / EXPIRED(만료) / CANCELED(해지)
 */
@Getter
@Setter
public class GroupMemberVO {

    /* 기본 정보 */
    private Long    groupNo;             // 단체번호 (PK)
    private String  groupNm;             // 단체명
    private String  groupCd;             // 단체유형 → GROUP_TYPE (SCHOOL/COMPANY/INSTITUTE/ORG)
    private String  groupCdNm;           // 단체유형명 (com_code JOIN)

    /* 담당자 */
    private String  representNm;         // 대표자명
    private String  managerNm;           // 담당자명
    private String  managerPhone;        // 담당자 연락처
    private String  managerEmail;        // 담당자 이메일

    /* 회원 현황 */
    private Integer currentMemberCnt;    // 현재 구성원 수 (member 테이블 실시간 집계)
    private Integer maxMemberCnt;        // 최대 구성원 수

    /* 계약 */
    private String  contractStatusCd;   // 계약상태 → CONTRACT_STATUS_CD
    private String  contractStatusNm;   // 계약상태명 (com_code JOIN)
    private String  contractStartDt;    // 계약 시작일
    private String  contractEndDt;      // 계약 만료일

    /* 결제 */
    private Integer monthlyFee;         // 월 구독료

    /* 검색 조건 */
    private String  searchGroupCd;      // 단체유형 검색
    private String  searchKeyword;      // 단체명/대표자 검색
}
