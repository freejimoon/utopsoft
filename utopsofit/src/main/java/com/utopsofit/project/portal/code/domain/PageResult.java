package com.utopsofit.project.portal.code.domain;

import java.util.Collections;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 페이징 결과 (공통)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PageResult<T> {

    private List<T> list;
    private long totalCount;
    private int currentPage;
    private int pageSize;
    private int totalPages;
    private int startPage;
    private int endPage;
    private boolean hasPrev;
    private boolean hasNext;

    public static <T> PageResult<T> of(List<T> list, long totalCount, int currentPage, int pageSize) {
        if (list == null) list = Collections.emptyList();
        int totalPages = (int) ((totalCount + pageSize - 1) / pageSize);
        if (totalPages < 1) totalPages = 1;
        int blockSize = 10;
        int block = (currentPage - 1) / blockSize;
        int startPage = block * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPages);
        return new PageResult<>(
            list, totalCount, currentPage, pageSize,
            totalPages, startPage, endPage,
            currentPage > 1, currentPage < totalPages
        );
    }
}
