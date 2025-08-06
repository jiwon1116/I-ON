package com.spring.ion.psw.controller;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.dto.Info_FileDTO;
import com.spring.ion.psw.dto.Info_PageDTO;
import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.service.Info_LikeService;
import com.spring.ion.psw.service.Info_commentService;
import com.spring.ion.psw.service.Info_contentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.*;

@Controller
@RequestMapping("/info")
@RequiredArgsConstructor
public class Info_contentController{
    private final Info_contentService infoContentService;
    private final Info_commentService infoCommentService;
    private final Info_LikeService infoLikeService;


    //게시물 불러오는 리스트
    @GetMapping
    public String list(Model model,
                       @RequestParam(value = "page", required = false, defaultValue = "1") int page) {

        // 로그인 유저 정보
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);

        // 페이징된 글 목록 리스트
        List<Info_contentDTO> pagingList = infoContentService.pagingList(page);
        // 페이징 정보
        Info_PageDTO pageDTO = infoContentService.pagingParam(page);

        // 글 내용, 파일 함께들어간 맵
        Map<Info_contentDTO, Info_FileDTO> postFileMap = new LinkedHashMap<>();

        for (Info_contentDTO post : pagingList) {
            Info_FileDTO file = infoContentService.findFile(post.getId());
            postFileMap.put(post, file); // 글, 파일 매칭(key, value)해서 저장
        }

        model.addAttribute("postMap", postFileMap);
        model.addAttribute("paging", pageDTO);

        return "psw/info";
    }

    // 글 작성 페이지 이동
    @GetMapping("/save")
    public String writeForm(){
        return "psw/write";
    }

    // 글 저장 처리
    @PostMapping("/save")
    public String save(@ModelAttribute Info_contentDTO dto,
                       @RequestParam("file") List<MultipartFile> files) throws IOException {

        infoContentService.save(dto); // 게시글 저장
        Long boardId = dto.getId();   // 저장된 게시글 ID

        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                String originalFileName = file.getOriginalFilename();
                String storedFileName = UUID.randomUUID() + "_" + originalFileName;
                String savePath = "C:/upload/" + storedFileName;

                file.transferTo(new File(savePath)); // 파일 저장

                // 파일 정보 저장
                Info_FileDTO fileDTO = new Info_FileDTO();
                fileDTO.setBoard_id(boardId);
                fileDTO.setOriginalFileName(originalFileName);
                fileDTO.setStoredFileName(storedFileName);

                infoContentService.saveFile(fileDTO); // 파일 저장
            }
        }

        return "redirect:/info";
    }


    @GetMapping("/detail")
    public String detailForm(@RequestParam("id") long id, Model model,
                             HttpServletRequest request) {
        HttpSession session = request.getSession();
        String viewKey = "viewed_post_" + id;

        if (session.getAttribute(viewKey) == null) {
            infoContentService.updateHits(id);
            session.setAttribute(viewKey, true); // 조회수 중복 방지
        }

        // 게시글 정보
        Info_contentDTO findDto = infoContentService.findContext(id);

        // 댓글 정보
        List<Info_commentDTO> infoCommentList = infoCommentService.findAll(id);

        //로그인 유저 정보
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);

        // 좋아요 여부 및 카운트 설정
        boolean liked = memberDTO.getUserId() != null && infoLikeService.isLiked(id, memberDTO.getUserId());
        findDto.setLiked(liked);
        findDto.setLike_count(infoLikeService.getLikeCount(id));

        // 게시글 이미지 전체 조회
        List<Info_FileDTO> fileList = infoContentService.findFiles(id); // 2개 이상 저장된 경우

        Info_FileDTO secondImage = null;
        if (fileList.size() >= 2) {
            secondImage = fileList.get(1); // 두 번째 이미지
        } else if (!fileList.isEmpty()) {
            secondImage = fileList.get(0); // 하나만 있을 경우
        }

        model.addAttribute("findDto", findDto);
        model.addAttribute("commentList", infoCommentList);
        model.addAttribute("findFileDto", secondImage); // secondImage를 기존 변수명에 맞게 전달
        return "psw/detail";
    }


    // 글 수정 폼
    @PostMapping("/detail")
    public String updateForm(@ModelAttribute Info_contentDTO infoContentDTO, Model model,
                             @ModelAttribute Info_FileDTO infoFileDTO,
                             @RequestParam("id") long id
                             ) {
        Info_contentDTO findDto = infoContentService.findContext(infoContentDTO.getId());
        model.addAttribute("findDto", findDto);
        Long boardId = id;

        infoFileDTO.setBoard_id(boardId);
        return "psw/update";
    }
    
    // 좋아요수 증가
    @PostMapping("/like")
    @ResponseBody
    public ResponseEntity<Integer> likeUpdate(@RequestParam("id") long id) {
        infoContentService.updateLike(id);
        Info_contentDTO updatedDto = infoContentService.findContext(id);
        int likeCount = updatedDto.getLike_count(); // 좋아요 수 필드에 따라 수정
        return ResponseEntity.ok(likeCount);
    }

    // 글 수정 처리
    @PostMapping("/update")
    public String update(@ModelAttribute Info_contentDTO infoContentDTO,
                         @RequestParam("file") List<MultipartFile> files,
                         @RequestParam("id") long id) throws IOException {

        // 게시글 내용 수정
        boolean result = infoContentService.update(infoContentDTO);

        // 기존 파일 서버 + DB 삭제
        List<Info_FileDTO> existingFiles = infoContentService.findFiles(id);
        infoContentService.deleteFilesFromServer(existingFiles); // 서버에서 삭제
        // 새 파일 저장
        infoContentService.saveFiles(files, id);
        return result ? "redirect:/info/" : "psw/update";
    }

    // 글 삭제
    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        // 기존 파일 서버에서 삭제 + DB에서도 삭제 (필요시)
        List<Info_FileDTO> existingFiles = infoContentService.findFiles(id);
        infoContentService.deleteFilesFromServer(existingFiles); // 서버에서 삭제
        infoContentService.delete(id);
        return "redirect:/info/";
    }

    // 페이징
    @GetMapping("/paging")
    public String paging(Model model,
                         @RequestParam(value = "page", required = false, defaultValue = "1") int page) {

        // 게시글 리스트 가져오기
        List<Info_contentDTO> pagingList = infoContentService.pagingList(page);
        // 페이징에 필요한 정보 계산
        Info_PageDTO pageDTO = infoContentService.pagingParam(page);

        // 게시글마다 파일 매핑
        Map<Info_contentDTO, Info_FileDTO> postFileMap = new LinkedHashMap<>();
        for (Info_contentDTO post : pagingList) {
            Info_FileDTO file = infoContentService.findFile(post.getId());
            postFileMap.put(post, file);
        }

        model.addAttribute("postMap", postFileMap);
        model.addAttribute("paging", pageDTO);

        return "psw/info";
    }


    // 사진 미리 보기
    @GetMapping("/preview")
    public void preview(@RequestParam("storedFileName") String storedFileName, HttpServletResponse response) throws IOException {

        // 실제 파일 경로 저장
        String filePath = "C:/upload/" + storedFileName;
        File file = new File(filePath); // 미리보기할 파일 객체 생성

        if (file.exists()) {

            // 파일의 타입을 자동으로 추론
            String mimeType = Files.probeContentType(file.toPath());
            // 브라우저가 추론한 타입에 맞춰 화면에 출력하도록 설정
            response.setContentType(mimeType);

            // 파일 읽어서 사용자 브라우저에 전송
            FileInputStream fis = new FileInputStream(file); // 로컬과 프로젝트 사이에 연결
            FileCopyUtils.copy(fis, response.getOutputStream()); // 응답 스트림 전달
            fis.close();
        }
    }

    // 검색기능
    @GetMapping("/search")
    public String infoSearch(@RequestParam(value = "keyword", required = false) String keyword,
                             @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                             Model model) {
        System.out.println("검색 키워드: " + keyword);
        List<Info_contentDTO> contentList;
        Map<Info_contentDTO, Info_FileDTO> postFileMap = new LinkedHashMap<>();

        if (keyword != null && !keyword.isEmpty()) {
            contentList = infoContentService.searchPagingList(keyword, page);  //검색 결과 페이징
            Info_PageDTO pageDTO = infoContentService.searchPagingParam(keyword, page); //페이징 정보
            model.addAttribute("paging", pageDTO);
        } else {
            contentList = infoContentService.pagingList(page);
            Info_PageDTO pageDTO = infoContentService.pagingParam(page);
            model.addAttribute("paging", pageDTO);
        }

        for (Info_contentDTO post : contentList) {
            Info_FileDTO file = infoContentService.findFile(post.getId());
            postFileMap.put(post, file);
        }

        model.addAttribute("postMap", postFileMap);
        model.addAttribute("postList", contentList);
        model.addAttribute("keyword", keyword);

        return "psw/info";
    }

}


