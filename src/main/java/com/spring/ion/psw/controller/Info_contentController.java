package com.spring.ion.psw.controller;

import com.spring.ion.psw.dto.Info_FileDTO;
import com.spring.ion.psw.dto.Info_PageDTO;
import com.spring.ion.psw.dto.Info_commentDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.psw.service.Info_commentService;
import com.spring.ion.psw.service.Info_contentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/info")
@RequiredArgsConstructor
public class Info_contentController{
    private final Info_contentService infoContentService;
    private final Info_commentService infoCommentService;


    //게시물 불러오는 리스트
    @GetMapping
    public String list(Model model,
                       @RequestParam(value = "page", required = false, defaultValue = "1") int page) {

        List<Info_contentDTO> pagingList = infoContentService.pagingList(page);
        Info_PageDTO pageDTO = infoContentService.pagingParam(page);

        Map<Info_contentDTO, Info_FileDTO> postFileMap = new LinkedHashMap<>();
        for (Info_contentDTO post : pagingList) {
            Info_FileDTO file = infoContentService.findFile(post.getId());
            postFileMap.put(post, file);
        }

        model.addAttribute("postMap", postFileMap);
        model.addAttribute("paging", pageDTO);

        return "psw/paging";
    }


    //글 쓰기 폼으로 이동
    @GetMapping("/save")
    public String writeForm() {

        return "psw/write";
    }

    // 글 저장처리
    @PostMapping("/save")
    // 인코딩타입 : multipart > 자동으로 매핑 불가
    public String save(@ModelAttribute Info_contentDTO dto,
                       @ModelAttribute Info_FileDTO infoFileDTO,
                       @RequestParam("file") MultipartFile infoFile, Model model)throws IOException {
        // 파일이 실제로 첨부 되어있는지 확인
        if (!infoFile.isEmpty()) {
            // 파일이 있을 때
            // 사용자가 업로드한 원래 파일 명
            String originalFileName = infoFile.getOriginalFilename(); // pom.xml에 작성한 파일 업로드 라이브러리 때문에 get~ 사용 가능
            // 고유한 파일 이름 생성을 위해 UUID 사용
            String uuid = UUID.randomUUID().toString();

            // 실제 서버에 저장될 파일이름
            String storedFileName = uuid + "_" + originalFileName;

            // ex) C:/upload/uuid_cat.jpg 이런 유형의 경로를 문자열로 저장
            String savePath = "C:/upload/" + storedFileName; // 경로 복붙하면 C:\\upload 로 나오는데 /로 변경

            // 지정한 경로에 파일 저장
            infoFile.transferTo(new File(savePath));

            // 파일은 자동 매핑 안되기 때문에 setter로 넣어줌
            // 서버에 저장될 파일명
            infoFileDTO.setStoredFileName(storedFileName);
            // 사용자가 업로드한 파일의 원래 이름
            infoFileDTO.setOriginalFileName(originalFileName);

        }
        // 게시판 글 저장
        infoContentService.save(dto);

        Long boardId = dto.getId();

        infoFileDTO.setBoard_id(boardId);

        // 게시판 이미지 파일 저장
        infoContentService.saveFile(infoFileDTO);

        // 게시판 이미지 파일 가져오기
        Info_FileDTO infoFileCard =  infoContentService.findFile(boardId);

        model.addAttribute("findFileDto",infoFileCard);
        // 저장 후 게시판 목록으로 이동
        return "redirect:/info/paging";
        
    }


    // 상세보기
    @GetMapping("/detail")
    public String detailForm(@RequestParam("id") long id, Model model,
                             @ModelAttribute Info_contentDTO dto,
                             @ModelAttribute Info_FileDTO infoFileDTO,
                             HttpServletRequest request) {
        HttpSession session = request.getSession();
        String viewKey = "viewed_post_" + id;

        if (session.getAttribute(viewKey) == null) {
            infoContentService.updateHits(id);
            session.setAttribute(viewKey, true); // 조회수 중복 방지
        }

        Info_contentDTO findDto = infoContentService.findContext(id);
        List<Info_commentDTO> infoCommentList= infoCommentService.findAll(id);

        model.addAttribute("findDto", findDto);
        model.addAttribute("commentList", infoCommentList);

        Long boardId = id;

        infoFileDTO.setBoard_id(boardId);
        // 게시판 이미지 파일 가져오기
      Info_FileDTO infoFile =  infoContentService.findFile(boardId);
        
      model.addAttribute("findFileDto",infoFile);

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

        // 게시판 이미지 파일 가져오기
        Info_FileDTO infoFile =  infoContentService.findFile(boardId);
        model.addAttribute("findFileDto",infoFile);

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
                         @ModelAttribute Info_FileDTO infoFileDTO,
                         @RequestParam("file") MultipartFile file,
                         @RequestParam("id") long id,
                         Model model) throws IOException {

        // 게시글 내용 수정
        boolean result = infoContentService.update(infoContentDTO);

        // 파일이 새로 업로드된 경우에만 파일 처리
        if (!file.isEmpty()) {
            String originalFileName = file.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String storedFileName = uuid + "_" + originalFileName;
            String savePath = "C:/upload/" + storedFileName;

            // 파일 저장
            file.transferTo(new File(savePath));

            // DTO에 파일 정보 세팅
            infoFileDTO.setOriginalFileName(originalFileName);
            infoFileDTO.setStoredFileName(storedFileName);
            infoFileDTO.setBoard_id(id);

            // 파일 정보 수정 (기존 파일 대체)
            infoContentService.updateFile(infoFileDTO);
        }

        if (result) {
            return "redirect:/info/";
        } else {
            return "psw/update";
        }
    }


    // 글 삭제
    @GetMapping("/delete")
    public String delete(@RequestParam("id") long id) {
        infoContentService.delete(id);
        return "redirect:/info/";
    }

    // 페이징
    @GetMapping("/paging")
    public String paging(Model model,
                         @RequestParam(value = "page", required = false, defaultValue = "1") int page) {

        // 게시글 리스트 가져오기
        List<Info_contentDTO> pagingList = infoContentService.pagingList(page);
        Info_PageDTO pageDTO = infoContentService.pagingParam(page);

        // 게시글마다 파일 매핑
        Map<Info_contentDTO, Info_FileDTO> postFileMap = new LinkedHashMap<>();
        for (Info_contentDTO post : pagingList) {
            Info_FileDTO file = infoContentService.findFile(post.getId());
            postFileMap.put(post, file);
        }

        model.addAttribute("postMap", postFileMap);
        model.addAttribute("paging", pageDTO);

        return "psw/paging";
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
        System.out.println("검색 키워드:"+keyword);
        List<Info_contentDTO> contentList;
        Map<Info_contentDTO, Info_FileDTO> postFileMap = new LinkedHashMap<>();

        // 키워드가 null이거나 비어있으면 전체 목록을 가져오고, 그렇지 않으면 검색
        if (keyword != null && !keyword.isEmpty()) {
            contentList = infoContentService.search(keyword);
        } else {
            contentList = infoContentService.AllfindList();
        }

        for (Info_contentDTO post : contentList) {
            Info_FileDTO file = infoContentService.findFile(post.getId());
            postFileMap.put(post, file);
        }

        model.addAttribute("postMap", postFileMap);
        return "psw/info";
    }
}
