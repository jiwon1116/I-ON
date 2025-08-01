package com.spring.ion.yjw.controller;

import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.dto.FlagPageDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.service.FlagCommentService;
import com.spring.ion.yjw.service.FlagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/flag")
public class FlagBoardController {

    private final FlagService flagService;
    private final FlagCommentService flagCommentService;

//    @GetMapping
//    public String flag() {
//        return "yjw/flag";
//    }

    // 글쓰기 폼 이동
    @GetMapping("write")
    public String writeForm() {
        return "yjw/flagWrite";
    }

    // 글 저장 처리
    @PostMapping("/write")
    public String write(FlagPostDTO flagPostDTO) {
        int writeResult = flagService.write(flagPostDTO);
        if (writeResult > 0) {
            return "redirect:/flag";
        } else {
            return "yjw/flagWrite";
        }
    }

    // 게시글 목록 조회
    @GetMapping
    public String findAll(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        // DB 에서 모든 회원 리스트 조회
        List<FlagPostDTO> pagingList = flagService.pagingList(page);
        FlagPageDTO pageDTO = flagService.pagingParam(page);

        model.addAttribute("postList", pagingList);
        model.addAttribute("paging", pageDTO);
        return "yjw/flag";
    }

    // 상세보기
    @GetMapping("/{id}")
    // @PathVariable : URL 경로 일부를 메서드의 파라미터로 전달
    public String detail(@PathVariable("id") int id, Model model) {
        FlagPostDTO flagPostDTO = flagService.findById(id);
        List<FlagCommentDTO> flagCommentDTOList = flagCommentService.findAll(id);

        // LocalDateTime → 포맷된 문자열로 변환
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm");
        String formattedCreatedAt = flagPostDTO.getCreated_at().format(formatter);

        model.addAttribute("flag", flagPostDTO);
        model.addAttribute("flagCommentDTOList", flagCommentDTOList);

        return "yjw/flagDetail";
    }

    // 수정 페이지로 이동
    @GetMapping("/update/{id}")
    public String updateForm(@PathVariable("id") int id, Model model) {
        FlagPostDTO flagPostDTO = flagService.findById(id);
        model.addAttribute("flag", flagPostDTO);
        return "yjw/flagUpdate";
    }

    // 실제 회원 정보 수정
    @PostMapping("/update")
    // @ModelAttribute : 폼 데이터에서 DTO 바인딩용
    public String update(@ModelAttribute FlagPostDTO flagPostDTO) {
        boolean result = flagService.update(flagPostDTO);

        if (result) {
            return "redirect:/flag";
        } else {
            return "yjw/flagUpdate";
        }
    }

    // 게시글 삭제
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") int id) {
        flagService.delete(id);
        return "redirect:/flag/";
    }

    // 페이징
    @GetMapping("/paging")
    public String paging(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        System.out.println("page = " + page);

        // 현재 페이지에 해당하는 게시글 목록 가져오기
        List<FlagPostDTO> pagingList = flagService.pagingList(page);
        System.out.println("pagingList = " + pagingList);

        // 페이징에 필요한 정보 계산
        FlagPageDTO pageDTO = flagService.pagingParam(page);

        model.addAttribute("postList", pagingList);
        model.addAttribute("paging", pageDTO);

        return "yjw/flagPaging";
    }

    // 이미지 미리보기
    @GetMapping("/preview")
    public void preview(@RequestParam("fileName") String fileName,
                        HttpServletResponse response) throws IOException {
        // 실제 파일 경로 저장
        String filePath = "C:/upload/" + fileName;
        File file = new File(filePath); // 미리보기할 파일 객체 생성

        if (file.exists()) {
            // 파일에 타입을 자동으로 추론하게 만들어줌
            String mimeType = Files.probeContentType(file.toPath());
            // 브라우저가 추론한 타입에 맞춰 화면에 출력하도록 설정
            response.setContentType(mimeType);

            // 파일 읽어서 사용자 브라우저에 전송
            FileInputStream fis = new FileInputStream(file); // 로컬과 프로젝트 사이에 연결
            FileCopyUtils.copy(fis, response.getOutputStream()); // 응답 스트링 전달
            fis.close();
        }
    }





}
