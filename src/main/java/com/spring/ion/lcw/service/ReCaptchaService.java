package com.spring.ion.lcw.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Map;

@Service
public class ReCaptchaService {
    private final String SECRET_KEY = "6LfdKZgrAAAAAL5CoSNv01MelOYG_Hm5awPR1xCE";
    private final String VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";

    public boolean verify(String reCaptchaResponse) {
        RestTemplate restTemplate = new RestTemplate();

        String url = VERIFY_URL + "?secret=" + SECRET_KEY + "&response=" + reCaptchaResponse;

        Map<String, Object> response = restTemplate.postForObject(url, null, Map.class);

        Boolean success = (Boolean) response.get("success");
        return success != null && success;
    }
}