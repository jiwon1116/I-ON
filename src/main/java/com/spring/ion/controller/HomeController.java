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

    @GetMapping("/entrust")
    public String entrust(){
        return "entrust";
    }




    @GetMapping("/info")
    public String info(){
        return "psw/info";
    }

    @GetMapping("/map")
    public String map(){
        return "map";
    }

    @GetMapping("/miss")
    public String miss(){
        return "miss";
    }

    @GetMapping("/mypage")
    public String mypage(){
        return "mypage";
    }

}
