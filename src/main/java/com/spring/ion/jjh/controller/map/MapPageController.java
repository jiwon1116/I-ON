package com.spring.ion.jjh.controller.map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/map")
public class MapPageController {
    @GetMapping("/crime")
    public String crimeMap() {
        return "jjh/crimeMap";
    }
}
