package com.spring.ion.jjh.controller.free;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.free.FreeCommentDTO;
import com.spring.ion.jjh.dto.free.FreeDTO;
import com.spring.ion.jjh.dto.free.FreeFileDTO;
import com.spring.ion.jjh.service.free.FreeCommentService;
import com.spring.ion.jjh.service.free.FreeLikeService;
import com.spring.ion.jjh.service.free.FreeService;
import lombok.RequiredArgsConstructor;
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
@RequestMapping("/free")
@RequiredArgsConstructor
public class FreeController {
    private final FreeService freeService;
    private final FreeCommentService commentService;
    private final FreeLikeService freeLikeService;

    @GetMapping
    public String paging(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        // 현재 페이지에 해당하는 게시글 목록 가져오기
        List<FreeDTO> pagingList = freeService.pagingList(page);

        // 페이징에 필요한 정보 계산(전체 페이지수, 현재 페이지, 시작 페이지 등)
        PageDTO pageDTO = freeService.pagingParam(page);

        for (FreeDTO post : pagingList) {
            int likeCount = freeLikeService.getLikeCount(post.getId());
            post.setLike_count(likeCount);
        }

        model.addAttribute("freeboardList", pagingList);
        model.addAttribute("paging", pageDTO);

        return "jjh/free/free";
    }

    @GetMapping("/write")
    public String writeForm() {
        return "jjh/free/write";
    }

    @PostMapping("/write")
    public String write(
            @ModelAttribute FreeDTO freeDTO,
            @RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles
    ) {
        int result = freeService.write(freeDTO, uploadFiles);

        if (result > 0) {
            return "redirect:/free";
        } else {
            return "jjh/free/write";
        }
    }

    @GetMapping("/{id}") // detail 페이지
    public String detail(@PathVariable("id") Long id, FreeDTO freeDTO, Model model, HttpSession session) {
        Set<Long> viewCount = (Set<Long>) session.getAttribute("viewCount");
        if (viewCount == null) {
            viewCount = new HashSet<>();
            session.setAttribute("viewCount", viewCount);
        }

        if (!viewCount.contains(id)) {
            freeService.updateViewCount(id);
            viewCount.add(id);
        }

        FreeDTO free = freeService.findById(id);

        int likeCount = freeLikeService.getLikeCount(id);
        free.setLike_count(likeCount);

        // 로그인 사용자 좋아요 여부
//        String memberId = (String) session.getAttribute("loginId");
//        if (memberId != null) {
//            boolean liked = freeLikeService.isLiked(id, memberId);
//            free.setLiked(liked);
//        }

        model.addAttribute("free", free);

        List<FreeCommentDTO> commentDTO = commentService.findAll(id);
        model.addAttribute("commentList", commentDTO);

        List<FreeFileDTO> fileList = freeService.findFileById(id);
        model.addAttribute("fileList", fileList);
        return "jjh/free/detail";
    }

    @GetMapping("/search")
    public String searchResult(@RequestParam(value = "searchContent", required = false) String searchContent, Model model) {
        List<FreeDTO> freeboardList;

        if (searchContent != null && !searchContent.isEmpty()) {
            freeboardList = freeService.search(searchContent);
        } else {
            freeboardList = freeService.allFreeList();
        }

        model.addAttribute("freeboardList", freeboardList);
        return "jjh/free/free";
    }

    @GetMapping("/update/{id}")
    public String updateForm(@PathVariable("id") Long id, Model model) {
        FreeDTO free = freeService.findById(id);
        model.addAttribute("free", free);
        return "jjh/free/update";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable("id") Long id,
                         @ModelAttribute FreeDTO freeDTO,
                         @RequestParam("file") MultipartFile file) {
        freeDTO.setId(id);
        boolean result = freeService.update(freeDTO, file);

        if (result) {
            return "redirect:/free";
        } else {
            return "jjh/free/update";
        }
    }


    @GetMapping("/delete")
    public String delete(FreeDTO freeDTO) {
        long clickId = freeDTO.getId();
        FreeDTO free = freeService.findById(clickId);

        if (free != null) {
            freeService.delete(clickId);
        }
        return "redirect:/free";
    }

    @GetMapping("/preview")
    public void preview(@RequestParam("fileName") String fileName, HttpServletResponse response) throws IOException, IOException {
        String filePath = "C:/upload/free/" + fileName;
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
