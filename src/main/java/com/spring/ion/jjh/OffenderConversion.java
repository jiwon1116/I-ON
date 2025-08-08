package com.spring.ion.jjh;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.file.Paths;
import java.util.*;

public class OffenderConversion {

    private static final String REST_API_KEY = "7abd708e5736c1e347cea936f488fe1a"; // Kakao REST API Key
    private static final String SERVICE_KEY = "p0oPQuANmqzwdzInUwavDeluzrO9pz7jA2YS6%2BiOlJDt79p3%2FWsZMQ2gRBeineU4ik3UaQ54D1z7unAw5WQnqA%3D%3D"; // 공공데이터포털 인코딩된 키
    private static final ObjectMapper mapper = new ObjectMapper();
    private static final Map<String, double[]> geocodeCache = new HashMap<>();

    public static void main(String[] args) {
        try {
            List<JsonNode> enriched = new ArrayList<>();
            int page = 1;
            int totalFetched = 0;

            while (true) {
                String urlStr = "https://apis.data.go.kr/1383000/sais/SexualAbuseNoticeAddrService/getSexualAbuseNoticeAddrList"
                        + "?serviceKey=" + SERVICE_KEY
                        + "&pageNo=" + page
                        + "&numOfRows=500"
                        + "&type=json";

                URL url = new URL(urlStr);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");

                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
                br.close();

                JsonNode items = mapper.readTree(sb.toString()).at("/response/body/items/item");

                if (items == null || !items.isArray() || items.size() == 0) break;

                for (JsonNode item : items) {
                    String fullAddr = null;
                    if (item.has("roadNm")) {
                        fullAddr = item.get("ctpvNm").asText() + " " + item.get("sggNm").asText() + " " + item.get("roadNm").asText();
                    } else if (item.has("lnmAdres")) {
                        fullAddr = item.get("lnmAdres").asText();
                    }

                    if (fullAddr == null) continue;

                    try {
                        double[] coords = geocodeAddressWithCache(fullAddr);
                        if (coords == null) continue;
                        ((ObjectNode) item).put("la", coords[0]);
                        ((ObjectNode) item).put("lo", coords[1]);
                        enriched.add(item);
                    } catch (Exception e) {
                        System.err.println("❌ 지오코딩 실패: " + fullAddr);
                    }
                }

                System.out.printf("📄 페이지 %d 처리 완료 (%d건)\n", page, items.size());
                totalFetched += items.size();

                // 다음 페이지로
                page++;

                // 종료 조건: 마지막 페이지 or 최대 페이지 제한
                if (items.size() < 500 || page > 100) break;
            }

            // 결과 저장
            File output = Paths.get("src/main/resources/data/offender.json").toFile();
            mapper.writerWithDefaultPrettyPrinter().writeValue(output, enriched);
            System.out.printf("✅ offender.json 저장 완료: %d건\n", enriched.size());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 캐시 적용된 주소 → 좌표 변환
    private static double[] geocodeAddressWithCache(String fullAddress) throws IOException {
        if (geocodeCache.containsKey(fullAddress)) {
            return geocodeCache.get(fullAddress);
        }
        double[] coords = geocodeAddress(fullAddress);
        if (coords != null) {
            geocodeCache.put(fullAddress, coords);
        }
        return coords;
    }

    // 주소 → Kakao 좌표 변환
    private static double[] geocodeAddress(String fullAddress) throws IOException {
        String encodedAddr = URLEncoder.encode(fullAddress, "UTF-8");
        String apiUrl = "https://dapi.kakao.com/v2/local/search/address.json?query=" + encodedAddr;

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "KakaoAK " + REST_API_KEY);

        if (conn.getResponseCode() != 200) {
            System.err.println("⚠️ 주소 변환 실패 (" + conn.getResponseCode() + "): " + fullAddress);
            return null;
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        br.close();

        JsonNode root = mapper.readTree(sb.toString()).get("documents");
        if (root == null || !root.isArray() || root.size() == 0) {
            return null;
        }

        JsonNode first = root.get(0);
        double lng = first.get("x").asDouble();
        double lat = first.get("y").asDouble();
        return new double[]{lat, lng};
    }
}
