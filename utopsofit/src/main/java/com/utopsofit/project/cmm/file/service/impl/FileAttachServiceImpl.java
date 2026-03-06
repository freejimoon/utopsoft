package com.utopsofit.project.cmm.file.service.impl;

import com.utopsofit.project.cmm.file.dao.FileAttachMapper;
import com.utopsofit.project.cmm.file.domain.FileAttachVO;
import com.utopsofit.project.cmm.file.service.FileAttachService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class FileAttachServiceImpl implements FileAttachService {

    private final FileAttachMapper fileAttachMapper;

    @Value("${app.file.dir:/utopsoft/files}")
    private String fileBaseDir;

    @Override
    public List<FileAttachVO> getList(String refType, Long refNo) {
        return fileAttachMapper.selectList(refType, refNo);
    }

    @Override
    @Transactional
    public FileAttachVO upload(String refType, Long refNo, MultipartFile file, String loginUser) throws IOException {
        String origNm  = file.getOriginalFilename();
        String ext     = extractExt(origNm);
        String saveNm  = UUID.randomUUID() + (ext.isEmpty() ? "" : "." + ext);
        Path   dir     = Paths.get(fileBaseDir, refType, String.valueOf(refNo));
        Files.createDirectories(dir);
        Path savePath = dir.resolve(saveNm);
        Files.copy(file.getInputStream(), savePath, StandardCopyOption.REPLACE_EXISTING);

        FileAttachVO vo = new FileAttachVO();
        vo.setRefType(refType);
        vo.setRefNo(refNo);
        vo.setOrigNm(origNm);
        vo.setSaveNm(saveNm);
        vo.setFilePath(savePath.toString());
        vo.setFileSize(file.getSize());
        vo.setFileExt(ext);
        vo.setCreatedBy(loginUser);
        fileAttachMapper.insert(vo);
        return vo;
    }

    @Override
    public FileAttachVO getOne(Long attachNo) {
        return fileAttachMapper.selectOne(attachNo);
    }

    @Override
    @Transactional
    public void delete(Long attachNo) throws IOException {
        FileAttachVO vo = fileAttachMapper.selectOne(attachNo);
        if (vo == null) return;
        fileAttachMapper.delete(attachNo);
        Path path = Paths.get(vo.getFilePath());
        if (Files.exists(path)) {
            Files.delete(path);
        }
    }

    @Override
    @Transactional
    public void deleteByRef(String refType, Long refNo) {
        List<FileAttachVO> list = fileAttachMapper.selectList(refType, refNo);
        fileAttachMapper.deleteByRef(refType, refNo);
        for (FileAttachVO vo : list) {
            try {
                Path path = Paths.get(vo.getFilePath());
                if (Files.exists(path)) Files.delete(path);
            } catch (IOException e) {
                log.warn("첨부파일 물리 삭제 실패: {}", vo.getFilePath(), e);
            }
        }
    }

    private String extractExt(String filename) {
        if (filename == null) return "";
        int idx = filename.lastIndexOf('.');
        return idx >= 0 ? filename.substring(idx + 1).toLowerCase() : "";
    }
}
