package com.spring.ion.jjh.controller.entrust;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.entrust.EntrustCommentDTO;
import com.spring.ion.jjh.dto.entrust.EntrustDTO;
import com.spring.ion.jjh.dto.entrust.EntrustFileDTO;
import com.spring.ion.jjh.service.entrust.EntrustCommentService;
import com.spring.ion.jjh.service.entrust.EntrustLikeService;
import com.spring.ion.jjh.service.entrust.EntrustService;
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
@RequestMapping("/entrust")
@RequiredArgsConstructor
public class EntrustController {
    private final EntrustService entrustService;
    private final EntrustCommentService entrustCommentService;
    private final EntrustLikeService entrustLikeService;

    @GetMapping
    public String paging(@RequestParam(value = "page", required = false, defaultValue = "1") int page,
                         @RequestParam(value = "searchContent", required = false) String searchContent,
                         Model model) {

        List<EntrustDTO> pagingList;
        PageDTO pageDTO;

        if (searchContent != null && !searchContent.isEmpty()) {
            pagingList = entrustService.searchPagingList(searchContent, page);
            pageDTO = entrustService.searchPagingParam(searchContent, page);
        } else {
            pagingList = entrustService.pagingList(page);
            pageDTO = entrustService.pagingParam(page);
        }

        for (EntrustDTO post : pagingList) {
            int likeCount = entrustLikeService.getLikeCount(post.getId());
            post.setLike_count(likeCount);
        }

        model.addAttribute("entrustboardList", pagingList);
        model.addAttribute("paging", pageDTO);
        model.addAttribute("searchContent", searchContent); // 검색 유지용

        return "jjh/entrust/entrust";
    }

    @GetMapping("/write")
    public String writeForm(Model model){
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();
        model.addAttribute("member", memberDTO);
        return "jjh/entrust/write";
    }

    @PostMapping("/write")
    public String write(
            @ModelAttribute EntrustDTO entrustDTO,
            @RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles
    ) {
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        MemberDTO memberDTO = user.getMemberDTO();

        entrustDTO.setUserId(user.getUsername());
        entrustDTO.setNickname(memberDTO.getNickname());

        int result = entrustService.write(entrustDTO, uploadFiles);

        if (result > 0) {
            return "redirect:/entrust";
        } else {
            return "jjh/entrust/write";
        }
    }

    @GetMapping("/{id}") // detail 페이지
    public String detail(@PathVariable("id") Long id, EntrustDTO entrustDTO, Model model, HttpSession session) {
        Set<Long> viewCount = (Set<Long>) session.getAttribute("viewCount");
        if (viewCount == null) {
            viewCount = new HashSet<>();
            session.setAttribute("viewCount", viewCount);
        }

        if (!viewCount.contains(id)) {
            entrustService.updateViewCount(id);
            viewCount.add(id);
        }

        EntrustDTO entrust = entrustService.findById(id);

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

        int likeCount = entrustLikeService.getLikeCount(id);
        entrust.setLike_count(likeCount);

        // 로그인 사용자 좋아요 여부
//        String memberId = (String) session.getAttribute("loginId");
//        if (memberId != null) {
//            boolean liked = entrustLikeService.isLiked(id, memberId);
//            entrust.setLiked(liked);
//        }

        model.addAttribute("entrust", entrust);

        List<EntrustCommentDTO> commentDTO = entrustCommentService.findAll(id);
        model.addAttribute("commentList", commentDTO);

        List<EntrustFileDTO> fileList = entrustService.findFileById(id);
        model.addAttribute("fileList", fileList);
        return "jjh/entrust/detail";
    }

    @GetMapping("/update/{id}")
    public String updateForm(@PathVariable("id") Long id, Model model) {
        EntrustDTO entrust = entrustService.findById(id);
        model.addAttribute("entrust", entrust);
        return "jjh/entrust/update";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable("id") Long id,
                         @ModelAttribute EntrustDTO entrustDTO,
                         @RequestParam("file") MultipartFile file) {
        entrustDTO.setId(id);
        boolean result = entrustService.update(entrustDTO, file);

        if (result) {
            return "redirect:/entrust/{id}";
        } else {
            return "jjh/entrust/update";
        }
    }


    @GetMapping("/delete")
    public String delete(EntrustDTO entrustDTO) {
        long clickId = entrustDTO.getId();
        EntrustDTO entrust = entrustService.findById(clickId);

        // 로그인 유저
        CustomUserDetails user = (CustomUserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = user.getUsername();

        // 관리자 체크
        boolean isAdmin = false;
        List<String> authorities = user.getMemberDTO().getAuthorities();
        if (authorities != null && authorities.contains("ROLE_ADMIN")) {
            isAdmin = true;
        }

        // 권한 체크: 작성자이거나 관리자일 때만 삭제!
        if (entrust != null && (loginUserId.equals(entrust.getUserId()) || isAdmin)) {
            entrustService.delete(clickId);
        }
        return "redirect:/entrust";
    }

    @GetMapping("/preview")
    public void preview(@RequestParam("fileName") String fileName, HttpServletResponse response) throws IOException, IOException {
        String filePath = "C:/upload/entrust/" + fileName;
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
