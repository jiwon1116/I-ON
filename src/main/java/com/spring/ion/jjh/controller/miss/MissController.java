package com.spring.ion.jjh.controller.miss;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.miss.MissCommentDTO;
import com.spring.ion.jjh.dto.miss.MissDTO;
import com.spring.ion.jjh.dto.miss.MissFileDTO;
import com.spring.ion.jjh.service.miss.MissCommentService;
import com.spring.ion.jjh.service.miss.MissLikeService;
import com.spring.ion.jjh.service.miss.MissService;
import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/miss")
@RequiredArgsConstructor
public class MissController {
    private final MissService missService;
    private final MissCommentService missCommentService;
    private final MissLikeService missLikeService;

    @GetMapping
    public String paging(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
                         @RequestParam(value = "searchContent", required = false) String searchContent,
                         Model model) {

        List<MissDTO> pagingList;
        PageDTO pageDTO;

        if (searchContent != null && !searchContent.isEmpty()) {
            pagingList = missService.searchPagingList(searchContent, page);
            pageDTO = missService.searchPagingParam(searchContent, page);
        } else {
            pagingList = missService.pagingList(page);
            pageDTO = missService.pagingParam(page);
        }

        for (MissDTO post : pagingList) {
            int likeCount = missLikeService.getLikeCount(post.getId());
            post.setLike_count(likeCount);
        }

        model.addAttribute("missboardList", pagingList);
        model.addAttribute("paging", pageDTO);
        model.addAttribute("searchContent", searchContent); // 검색 유지용

        return "jjh/miss/miss";
    }

    @GetMapping("/write")
    public String writeForm(Model model){
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);
        return "jjh/miss/write";
    }

    @PostMapping("/write")
    public String write(
            @ModelAttribute MissDTO missDTO,
            @RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles
    ) {
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();

        missDTO.setUserId(user.getUsername());
        missDTO.setNickname(memberDTO.getNickname());

        int result = missService.write(missDTO, uploadFiles);

        if (result > 0) {
            return "redirect:/miss";
        } else {
            return "jjh/miss/write";
        }
    }

    @GetMapping("/{id}") // detail 페이지
    public String detail(@PathVariable("id") Long id, MissDTO missDTO, Model model, HttpSession session) {
        Set<Long> viewCount = (Set<Long>) session.getAttribute("viewCount");
        if (viewCount == null) {
            viewCount = new HashSet<>();
            session.setAttribute("viewCount", viewCount);
        }

        if (!viewCount.contains(id)) {
            missService.updateViewCount(id);
            viewCount.add(id);
        }

        MissDTO miss = missService.findById(id);
        if (miss == null) return "redirect:/miss";

        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = user.getUsername();
        model.addAttribute("loginUserId", loginUserId);

        // --- 관리자 권한 체크 추가! ---
        boolean isAdmin = false;
        List<String> authorities = user.getMemberDTO().getAuthorities();
        if (authorities != null && authorities.contains("ROLE_ADMIN")) {
            isAdmin = true;
        }
        model.addAttribute("isAdmin", isAdmin);
        // 여기까지

        int likeCount = missLikeService.getLikeCount(id);
        miss.setLike_count(likeCount);

        model.addAttribute("miss", miss);

        List<MissCommentDTO> commentDTO = missCommentService.findAll(id);
        model.addAttribute("commentList", commentDTO);

        List<MissFileDTO> fileList = missService.findFileById(id);
        model.addAttribute("fileList", fileList);
        return "jjh/miss/detail";
    }

    @GetMapping("/update/{id}")
    public String updateForm(@PathVariable("id") Long id, Model model) {
        MissDTO miss = missService.findById(id);
        model.addAttribute("miss", miss);
        return "jjh/miss/update";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable("id") Long id,
                         @ModelAttribute MissDTO missDTO,
                         @RequestParam("file") MultipartFile file) {
        missDTO.setId(id);
        boolean result = missService.update(missDTO, file);

        if (result) {
            return "redirect:/miss/{id}";
        } else {
            return "jjh/miss/update";
        }
    }


    @GetMapping("/delete")
    public String delete(MissDTO missDTO) {
        long clickId = missDTO.getId();
        MissDTO miss = missService.findById(clickId);

        // 로그인 유저
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = user.getUsername();

        // 관리자 체크
        boolean isAdmin = false;
        List<String> authorities = user.getMemberDTO().getAuthorities();
        if (authorities != null && authorities.contains("ROLE_ADMIN")) {
            isAdmin = true;
        }

        if (miss != null && (loginUserId.equals(miss.getUserId()) || isAdmin)) {
            missService.delete(clickId);
        }
        return "redirect:/miss";
    }

    @GetMapping("/preview")
    public void preview(@RequestParam("fileName") String fileName, HttpServletResponse response) throws IOException, IOException {
        String filePath = "C:/upload/miss/" + fileName;
        File file = new File(filePath);

        if (file.exists()) {
            String mimeType = Files.probeContentType(file.toPath());
            response.setContentType(mimeType);
            FileInputStream fis = new FileInputStream(file);
            FileCopyUtils.copy(fis, response.getOutputStream());
            fis.close();
        }
    }


}
