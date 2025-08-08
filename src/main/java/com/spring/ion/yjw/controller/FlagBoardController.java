package com.spring.ion.yjw.controller;

import com.spring.ion.lcw.security.CustomUserDetails;
import com.spring.ion.psw.service.NotifyService;
import com.spring.ion.yjw.dto.FlagCommentDTO;
import com.spring.ion.yjw.dto.FlagFileDTO;
import com.spring.ion.yjw.dto.FlagPageDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.service.FlagCommentService;
import com.spring.ion.yjw.service.FlagLikeService;
import com.spring.ion.yjw.service.FlagService;
import lombok.RequiredArgsConstructor;
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
import java.util.List;


@Controller
@RequiredArgsConstructor
@RequestMapping("/flag")
public class FlagBoardController {

    private final FlagService flagService;
    private final FlagCommentService flagCommentService;
    private final FlagLikeService flagLikeService;
    private final NotifyService notifyService;

//    @GetMapping
//    public String flag() {
//        return "yjw/flag";
//    }

    // 글쓰기 폼 이동
    @GetMapping("write")
    public String writeForm(Model model) {
        // 현재 인증된 Principal 객체 가져오기
        Object principal = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        String nickname = "";
        if (principal instanceof com.spring.ion.lcw.security.CustomUserDetails) {
            nickname = ((com.spring.ion.lcw.security.CustomUserDetails) principal).getMemberDTO().getNickname();
        } else if (principal instanceof org.springframework.security.core.userdetails.User) {
            // 닉네임 정보가 없으니 username만 가져올 수 있음
            nickname = ((org.springframework.security.core.userdetails.User) principal).getUsername();
        } else if (principal instanceof String) {
            nickname = (String) principal;
        }

        model.addAttribute("nickname", nickname);
        return "yjw/flagWrite";
    }


    // 글 저장 처리
    @PostMapping("/write")
    public String write(@ModelAttribute FlagPostDTO flagPostDTO,
                        @RequestParam("boardFile") List<MultipartFile> fileList) throws IOException {
        // 로그인 유저
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String userId = null;
        if (principal instanceof CustomUserDetails) {
            userId = ((CustomUserDetails) principal).getUsername();
        } else if (principal instanceof org.springframework.security.core.userdetails.User) {
            userId = ((org.springframework.security.core.userdetails.User) principal).getUsername();
        } else if (principal instanceof String) {
            userId = (String) principal;
        }
        flagPostDTO.setUserId(userId); // 꼭 넣어줘야 함

        flagService.write(flagPostDTO, fileList);
        String city = flagPostDTO.getCity(); // 제보글 시/도
        String district = flagPostDTO.getDistrict(); // 구/군

        System.out.println("글 작성자:"+ flagPostDTO.getNickname());
        System.out.println("글 아이디:"+ flagPostDTO.getId());
        System.out.println("제보글 시/도:"+city);
        System.out.println("제보글 구/군:"+district);

        // 알림 저장
     /*  notifyService.createDangerNotify(flagPostDTO.getNickname(),flagPostDTO.getId(),city,"flag");*/

        return "redirect:/flag";
    }

    // 게시글 목록 조회
    @GetMapping
    public String findAll(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        // DB 에서 모든 회원 리스트 조회
        List<FlagPostDTO> pagingList = flagService.pagingList(page);
        FlagPageDTO pageDTO = flagService.pagingParam(page);

        model.addAttribute("postList", pagingList);
        model.addAttribute("postList",flagService.findAll());
        model.addAttribute("paging", pageDTO);
        return "yjw/flag";
    }

    // 상세보기
    // FlagBoardController.java

    // 상세보기
    @GetMapping("/{id}")
    public String detail(@PathVariable("id") int id, Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        String viewKey = "viewed_post_" + id;

        if (session.getAttribute(viewKey) == null) {
            flagService.increaseViewCount(id);
            session.setAttribute(viewKey, true); // 조회수 중복 방지
        }

        // 게시글/댓글/첨부파일 조회
        FlagPostDTO flagPostDTO = flagService.findById(id);
        List<FlagCommentDTO> flagCommentDTOList = flagCommentService.findAll(id);
        List<FlagFileDTO> fileList = flagService.findFilesByBoardId(id);

        // 로그인 유저 정보 구하기
        String loginUserId = null;
        boolean isAdmin = false;
        org.springframework.security.core.Authentication authentication =
                org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        Object principal = authentication.getPrincipal();
        if (principal instanceof com.spring.ion.lcw.security.CustomUserDetails) {
            loginUserId = ((com.spring.ion.lcw.security.CustomUserDetails) principal).getUsername();
            // [여기!]
            List<String> authorities = ((com.spring.ion.lcw.security.CustomUserDetails) principal).getMemberDTO().getAuthorities();
            isAdmin = authorities != null && authorities.contains("ROLE_ADMIN");
        } else if (principal instanceof org.springframework.security.core.userdetails.User) {
            loginUserId = ((org.springframework.security.core.userdetails.User) principal).getUsername();
        } else if (principal instanceof String) {
            if (!"anonymousUser".equals(principal)) {
                loginUserId = (String) principal;
            }
        }
        model.addAttribute("loginUserId", loginUserId);
        model.addAttribute("isAdmin", isAdmin); // 관리자 아이디 추출

        // 좋아요 정보
        boolean liked = false;
        if (loginUserId != null) {
            liked = flagLikeService.isLiked((long) id, loginUserId);
        }
        flagPostDTO.setLiked(liked);
        flagPostDTO.setLike_count(flagLikeService.getLikeCount((long) id));

        // 모델에 값 전달
        model.addAttribute("flag", flagPostDTO);
        model.addAttribute("flagCommentDTOList", flagCommentDTOList);
        model.addAttribute("fileList", fileList);

        return "yjw/flagDetail";
    }





    // 수정 폼 이동 시 기존 파일 리스트도 함께 넘김
    @GetMapping("/update/{id}")
    public String updateForm(@PathVariable("id") int id, Model model) {
        FlagPostDTO flagPostDTO = flagService.findById(id);
        // 로그인 유저와 권한
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = null;
        boolean isAdmin = false;

        if (principal instanceof CustomUserDetails) {
            loginUserId = ((CustomUserDetails) principal).getUsername();
            List<String> authorities = ((CustomUserDetails) principal).getMemberDTO().getAuthorities();
            isAdmin = authorities != null && authorities.contains("ROLE_ADMIN");
        }
        // 권한 체크
        if (flagPostDTO == null || (
                !flagPostDTO.getUserId().equals(loginUserId)
                        && !isAdmin
        )) {
            // 글 없거나 권한 없으면 목록으로
            return "redirect:/flag";
        }

        List<FlagFileDTO> fileList = flagService.findFilesByBoardId(id);
        model.addAttribute("flag", flagPostDTO);
        model.addAttribute("fileList", fileList);
        return "yjw/flagUpdate";
    }




    // 실제 회원 정보 수정
    @PostMapping("/update")
    public String update(@ModelAttribute FlagPostDTO flagPostDTO,
                         @RequestParam(value = "deleteFile", required = false) List<Long> deleteFileIds,
                         @RequestParam(value = "boardFile", required = false) MultipartFile boardFile) throws IOException {

        boolean result = flagService.update(flagPostDTO, deleteFileIds, boardFile);
        return result ? "redirect:/flag/" + flagPostDTO.getId() : "yjw/flagUpdate";
    }


    // 게시글 삭제
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") int id, HttpServletRequest request) {
        FlagPostDTO post = flagService.findById(id);
        if (post == null) return "redirect:/flag"; // 글 없으면 목록으로

        // 로그인한 유저 id + 권한
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = null;
        boolean isAdmin = false;

        if (principal instanceof CustomUserDetails) {
            loginUserId = ((CustomUserDetails) principal).getUsername();
            List<String> authorities = ((CustomUserDetails) principal).getMemberDTO().getAuthorities();
            isAdmin = authorities != null && authorities.contains("ROLE_ADMIN");
        }

        // "글쓴이거나, 또는 관리자면 삭제"
        if ((loginUserId != null && loginUserId.equals(post.getUserId())) || isAdmin) {
            flagService.delete(id);
        }
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

        return "yjw/flag";
    }

    @GetMapping("/preview")
    public void preview(@RequestParam("fileName") String fileName, HttpServletResponse response) throws IOException {
        String filePath = "C:/upload/" + fileName;
        File file = new File(filePath);

        if (file.exists()) {
            String mimeType = Files.probeContentType(file.toPath());
            response.setContentType(mimeType);

            FileInputStream fis = new FileInputStream(file);
            FileCopyUtils.copy(fis, response.getOutputStream());
            fis.close();
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }


    // 검색기능
    @GetMapping("/search")
    public String flag(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<FlagPostDTO> postList;

        if (keyword != null && !keyword.isEmpty()) {
            postList = flagService.search(keyword); // 검색
        } else {
            postList = flagService.findAll(); // 전체 목록
        }

        model.addAttribute("postList", postList);
        return "yjw/flag"; // 위의 JSP가 위치한 경로
    }


}
