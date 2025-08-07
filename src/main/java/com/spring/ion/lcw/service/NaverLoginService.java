package com.spring.ion.lcw.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@Service
public class NaverLoginService {

    private final String clientId = "tDu0Knn2MBz39f7vATkw";
    private final String clientSecret = "gKiLwY5moh";
    private final String redirectUri = "http://localhost:8080/auth/naver/callback";

    private final ObjectMapper objectMapper = new ObjectMapper();

    public String getAccessToken(String code, String state) throws IOException {
        String tokenApiUrl = "https://nid.naver.com/oauth2.0/token";
        String postData = "grant_type=authorization_code" +
                "&client_id=" + clientId +
                "&client_secret=" + clientSecret +
                "&code=" + code +
                "&state=" + state;

        URL url = new URL(tokenApiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = postData.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            br.close();

            JsonNode jsonNode = objectMapper.readTree(sb.toString());
            return jsonNode.get("access_token").asText();
        }
        return null;
    }

    public JsonNode getUserProfile(String accessToken) throws IOException {
        String profileApiUrl = "https://openapi.naver.com/v1/nid/me";
        URL url = new URL(profileApiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            br.close();
            return objectMapper.readTree(sb.toString());
        }
        return null;
    }
}