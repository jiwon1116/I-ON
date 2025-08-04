package com.spring.ion.jjh.controller.entrust;

import com.spring.ion.jjh.dto.PageDTO;
import com.spring.ion.jjh.dto.entrust.EntrustCommentDTO;
import com.spring.ion.jjh.dto.entrust.EntrustDTO;
import com.spring.ion.jjh.dto.entrust.EntrustFileDTO;
import com.spring.ion.jjh.service.entrust.EntrustCommentService;
import com.spring.ion.jjh.service.entrust.EntrustLikeService;
import com.spring.ion.jjh.service.entrust.EntrustService;
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
@RequestMapping("/entrust")
@RequiredArgsConstructor
public class EntrustController {
    private final EntrustService entrustService;
    private final EntrustCommentService entrustCommentService;
    private final EntrustLikeService entrustLikeService;

    @GetMapping
    public String paging(Model model, @RequestParam(value = "page", required = false, defaultValue = "1") int page) {
        // 현재 페이지에 해당하는 게시글 목록 가져오기
        List<EntrustDTO> pagingList = entrustService.pagingList(page);

        // 페이징에 필요한 정보 계산(전체 페이지수, 현재 페이지, 시작 페이지 등)
        PageDTO pageDTO = entrustService.pagingParam(page);

        for (EntrustDTO post : pagingList) {
            int likeCount = entrustLikeService.getLikeCount(post.getId());
            post.setLike_count(likeCount);
        }

        model.addAttribute("entrustboardList", pagingList);
        model.addAttribute("paging", pageDTO);

        return "jjh/entrust/entrust";
    }

    @GetMapping("/write")
    public String writeForm() {
        return "jjh/entrust/write";
    }

    @PostMapping("/write")
    public String write(
            @ModelAttribute EntrustDTO entrustDTO,
            @RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles
    ) {
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

    @GetMapping("/search")
    public String searchResult(@RequestParam(value = "searchContent", required = false) String searchContent, Model model) {
        List<EntrustDTO> entrustboardList;

        if (searchContent != null && !searchContent.isEmpty()) {
            entrustboardList = entrustService.search(searchContent);
        } else {
            entrustboardList = entrustService.allEntrustList();
        }

        model.addAttribute("entrustboardList", entrustboardList);
        return "jjh/entrust/entrust";
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
            return "redirect:/entrust";
        } else {
            return "jjh/entrust/update";
        }
    }


    @GetMapping("/delete")
    public String delete(EntrustDTO entrustDTO) {
        long clickId = entrustDTO.getId();
        EntrustDTO entrust = entrustService.findById(clickId);

        if (entrust != null) {
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
