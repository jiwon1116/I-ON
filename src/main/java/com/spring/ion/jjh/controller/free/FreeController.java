package com.spring.ion.jjh.controller.free;

import com.spring.ion.jjh.dto.free.FreeDTO;
import com.spring.ion.jjh.service.free.FreeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/free")
@RequiredArgsConstructor
public class FreeController {
    private final FreeService freeService;

    @GetMapping
    public String free() {
        return "jjh/free/free";
    }

    @GetMapping("/write")
    public String writeForm() {
        return "jjh/free/write";
    }

    @PostMapping("/write")
    public String write(FreeDTO freeDTO) {
        int result = freeService.write(freeDTO);
        System.out.println("글 작성 결과: " + result);
        System.out.println(freeDTO);

        if (result > 0) {
            return "redirect:/free";
        } else {
            return "jjh/free/write";
        }
    }

}
