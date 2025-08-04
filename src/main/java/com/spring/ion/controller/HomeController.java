package com.spring.ion.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    @GetMapping("/")
    public String index(){
        return "index";
    }
    @GetMapping("/chat")
    public String chat(){
        return "chat";
    }

    @GetMapping("/map")
    public String map(){
        return "map";
    }

    @GetMapping("/mypage")
    public String mypage(){
        return "mypage";
    }

}
