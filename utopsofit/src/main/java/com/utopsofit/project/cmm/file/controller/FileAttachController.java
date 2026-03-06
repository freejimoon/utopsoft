package com.utopsofit.project.cmm.file.controller;

import com.utopsofit.project.cmm.file.domain.FileAttachVO;
import com.utopsofit.project.cmm.file.service.FileAttachService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

/**
 * 공통 첨부파일 API
 * POST   /attach/upload?refType=FAQ&refNo=1   — 파일 업로드
 * GET    /attach/list?refType=FAQ&refNo=1      — 목록 조회
 * GET    /attach/download?attachNo=1           — 다운로드
 * POST   /attach/delete?attachNo=1             — 삭제
 */
@Slf4j
@RestController
@RequestMapping("/attach")
@RequiredArgsConstructor
public class FileAttachController {

    private final FileAttachService fileAttachService;

    /** 파일 업로드 */
    @PostMapping("/upload")
    public ResponseEntity<?> upload(
            @RequestParam String refType,
            @RequestParam Long   refNo,
            @RequestParam MultipartFile file,
            Authentication auth) {

        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("result", "error", "message", "파일이 비어있습니다."));
        }
        try {
            String loginUser = auth != null ? auth.getName() : "system";
            FileAttachVO vo = fileAttachService.upload(refType, refNo, file, loginUser);
            return ResponseEntity.ok(Map.of(
                "result",   "success",
                "attachNo", vo.getAttachNo(),
                "origNm",   vo.getOrigNm(),
                "fileSize", vo.getFileSize()
            ));
        } catch (IOException e) {
            log.error("파일 업로드 실패", e);
            return ResponseEntity.internalServerError().body(Map.of("result", "error", "message", "파일 업로드 중 오류가 발생했습니다."));
        }
    }

    /** 첨부파일 목록 조회 */
    @GetMapping("/list")
    public ResponseEntity<List<FileAttachVO>> list(
            @RequestParam String refType,
            @RequestParam Long   refNo) {
        return ResponseEntity.ok(fileAttachService.getList(refType, refNo));
    }

    /** 파일 다운로드 */
    @GetMapping("/download")
    public ResponseEntity<Resource> download(@RequestParam Long attachNo) {
        FileAttachVO vo = fileAttachService.getOne(attachNo);
        if (vo == null) return ResponseEntity.notFound().build();

        Resource resource = new FileSystemResource(Paths.get(vo.getFilePath()));
        if (!resource.exists()) return ResponseEntity.notFound().build();

        String encodedName = URLEncoder.encode(vo.getOrigNm(), StandardCharsets.UTF_8).replace("+", "%20");

        try {
            String contentType = Files.probeContentType(Paths.get(vo.getFilePath()));
            if (contentType == null) contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedName)
                    .body(resource);
        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    /** 파일 삭제 */
    @PostMapping("/delete")
    public ResponseEntity<?> delete(@RequestParam Long attachNo) {
        try {
            fileAttachService.delete(attachNo);
            return ResponseEntity.ok(Map.of("result", "success"));
        } catch (IOException e) {
            log.error("파일 삭제 실패: attachNo={}", attachNo, e);
            return ResponseEntity.internalServerError().body(Map.of("result", "error", "message", "파일 삭제 중 오류가 발생했습니다."));
        }
    }
}
