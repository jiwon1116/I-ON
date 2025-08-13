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
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequiredArgsConstructor
@RequestMapping("/flag")
public class FlagBoardController {

    private final FlagService flagService;
    private final FlagCommentService flagCommentService;
    private final FlagLikeService flagLikeService;
    private final NotifyService notifyService;


    @GetMapping("write")
    public String writeForm(Model model) {
        Object principal = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        String nickname = "";
        if (principal instanceof com.spring.ion.lcw.security.CustomUserDetails) {
            nickname = ((com.spring.ion.lcw.security.CustomUserDetails) principal).getMemberDTO().getNickname();
        } else if (principal instanceof org.springframework.security.core.userdetails.User) {
            nickname = ((org.springframework.security.core.userdetails.User) principal).getUsername();
        } else if (principal instanceof String) {
            nickname = (String) principal;
        }

        model.addAttribute("nickname", nickname);
        return "yjw/flagWrite";
    }


    @PostMapping("/write")
    public String write(@ModelAttribute FlagPostDTO flagPostDTO,
                        @RequestParam("boardFile") List<MultipartFile> fileList) throws IOException {

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String userId = null;
        if (principal instanceof CustomUserDetails) {
            userId = ((CustomUserDetails) principal).getUsername();
        } else if (principal instanceof org.springframework.security.core.userdetails.User) {
            userId = ((org.springframework.security.core.userdetails.User) principal).getUsername();
        } else if (principal instanceof String) {
            userId = (String) principal;
        }
        flagPostDTO.setUserId(userId);

        boolean isAdmin = false;
        if (principal instanceof CustomUserDetails) {
            var authorities = ((CustomUserDetails) principal).getMemberDTO().getAuthorities();
            isAdmin = authorities != null && authorities.contains("ROLE_ADMIN");
        }
        if (isAdmin) {
            flagPostDTO.setStatus("APPROVED");
        }

        flagService.write(flagPostDTO, fileList);
        return "redirect:/flag";
    }


    @GetMapping
    public String findAll(Model model,
                          @RequestParam(value = "page", defaultValue = "1") int page) {

        String loginUserId = null;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof CustomUserDetails) {
            loginUserId = ((CustomUserDetails) principal).getUsername();
        } else if (principal instanceof org.springframework.security.core.userdetails.User) {
            loginUserId = ((org.springframework.security.core.userdetails.User) principal).getUsername();
        } else if (principal instanceof String) {
            loginUserId = (String) principal;
        }

        List<FlagPostDTO> list = flagService.pagingListPublicOrMine(page, loginUserId);
        FlagPageDTO pageDTO = flagService.pagingParamPublicOrMine(page, loginUserId);

        model.addAttribute("postList", list);
        model.addAttribute("paging", pageDTO);
        return "yjw/flag";
    }

    @GetMapping("/paging")
    public String paging(Model model,
                         @RequestParam(value = "page", defaultValue = "1") int page) {
        return findAll(model, page);
    }




    @GetMapping("/{id}")
    public String detail(@PathVariable("id") int id, Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        String viewKey = "viewed_post_" + id;

        if (session.getAttribute(viewKey) == null) {
            flagService.increaseViewCount(id);
            session.setAttribute(viewKey, true);
        }

        FlagPostDTO flagPostDTO = flagService.findById(id);
        if (flagPostDTO == null) return "redirect:/flag";

        List<FlagCommentDTO> flagCommentDTOList = flagCommentService.findAll(id);
        List<FlagFileDTO> fileList = flagService.findFilesByBoardId(id);

        String loginUserId = null;
        boolean isAdmin = false;
        org.springframework.security.core.Authentication authentication =
                org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        Object principal = authentication.getPrincipal();
        if (principal instanceof com.spring.ion.lcw.security.CustomUserDetails) {
            loginUserId = ((com.spring.ion.lcw.security.CustomUserDetails) principal).getUsername();
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
        model.addAttribute("isAdmin", isAdmin);

        if ("PENDING".equals(flagPostDTO.getStatus())) {
            if (!isAdmin && !flagPostDTO.getUserId().equals(loginUserId)) {
                return "error/403";
            }
        }
        boolean liked = false;
        if (loginUserId != null) {
            liked = flagLikeService.isLiked((long) id, loginUserId);
        }
        flagPostDTO.setLiked(liked);
        flagPostDTO.setLike_count(flagLikeService.getLikeCount((long) id));

        model.addAttribute("flag", flagPostDTO);
        model.addAttribute("flagCommentDTOList", flagCommentDTOList);
        model.addAttribute("fileList", fileList);

        return "yjw/flagDetail";
    }


    @GetMapping("/update/{id}")
    public String updateForm(@PathVariable("id") int id, Model model) {
        FlagPostDTO flagPostDTO = flagService.findById(id);
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = null;
        boolean isAdmin = false;

        if (principal instanceof CustomUserDetails) {
            loginUserId = ((CustomUserDetails) principal).getUsername();
            List<String> authorities = ((CustomUserDetails) principal).getMemberDTO().getAuthorities();
            isAdmin = authorities != null && authorities.contains("ROLE_ADMIN");
        }
        if (flagPostDTO == null || (
                !flagPostDTO.getUserId().equals(loginUserId)
                        && !isAdmin
        )) {
            return "redirect:/flag";
        }

        List<FlagFileDTO> fileList = flagService.findFilesByBoardId(id);
        model.addAttribute("flag", flagPostDTO);
        model.addAttribute("fileList", fileList);
        return "yjw/flagUpdate";
    }




    @PostMapping("/update")
    public String update(@ModelAttribute FlagPostDTO flagPostDTO,
                         @RequestParam(value = "deleteFile", required = false) List<Long> deleteFileIds,
                         @RequestParam(value = "boardFile", required = false) MultipartFile boardFile) throws IOException {

        if ("REJECTED".equals(flagPostDTO.getStatus())) {
            flagPostDTO.setStatus("PENDING");
        }

        boolean result = flagService.update(flagPostDTO, deleteFileIds, boardFile);
        return result ? "redirect:/flag/" + flagPostDTO.getId() : "yjw/flagUpdate";
    }


    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") long id, HttpServletRequest request) {
        FlagPostDTO post = flagService.findById(id);
        if (post == null) return "redirect:/flag";

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = null;
        boolean isAdmin = false;

        if (principal instanceof CustomUserDetails) {
            loginUserId = ((CustomUserDetails) principal).getUsername();
            List<String> authorities = ((CustomUserDetails) principal).getMemberDTO().getAuthorities();
            isAdmin = authorities != null && authorities.contains("ROLE_ADMIN");
        }

        if ((loginUserId != null && loginUserId.equals(post.getUserId())) || isAdmin) {
            flagService.delete(id);
            notifyService.deleteByPostId(id);
        }
        return "redirect:/flag/";
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


    @GetMapping("/search")
    public String search(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        String loginUserId = null;
        Object p = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (p instanceof CustomUserDetails) {
            loginUserId = ((CustomUserDetails) p).getUsername();
        } else if (p instanceof org.springframework.security.core.userdetails.User) {
            loginUserId = ((org.springframework.security.core.userdetails.User) p).getUsername();
        } else if (p instanceof String && !"anonymousUser".equals(p)) {
            loginUserId = (String) p;
        }

        List<FlagPostDTO> postList = (keyword != null && !keyword.isEmpty())
                ? flagService.searchPublicOrMine(keyword, loginUserId)
                : flagService.pagingListPublicOrMine(1, loginUserId);

        model.addAttribute("postList", postList);
        model.addAttribute("paging", flagService.pagingParamPublicOrMine(1, loginUserId));
        return "yjw/flag";
    }




}
