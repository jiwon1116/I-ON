package com.spring.ion.jjh.controller.map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.ion.jjh.dto.map.EmergencyBellDTO;
import com.spring.ion.jjh.dto.map.OffenderDTO;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/map")
public class MapController {

    private final List<EmergencyBellDTO> cachedList;
    private final List<OffenderDTO> offenderList;

    public MapController() throws IOException {
        ClassPathResource emergencyResource = new ClassPathResource("data/emergencybell.json");
        byte[] emergencyData = StreamUtils.copyToByteArray(emergencyResource.getInputStream());
        ObjectMapper mapper = new ObjectMapper();
        cachedList = Arrays.asList(mapper.readValue(emergencyData, EmergencyBellDTO[].class));

        ClassPathResource offenderResource = new ClassPathResource("data/offender.json");
        byte[] offenderData = StreamUtils.copyToByteArray(offenderResource.getInputStream());
        offenderList = Arrays.asList(mapper.readValue(offenderData, OffenderDTO[].class));
    }

    @GetMapping("/emergencybell")
    public ResponseEntity<List<EmergencyBellDTO>> getMarkersByBounds(
            @RequestParam double swLat,
            @RequestParam double swLng,
            @RequestParam double neLat,
            @RequestParam double neLng) {

        List<EmergencyBellDTO> filtered = cachedList.stream()
                .filter(m -> m.getLatitude() >= swLat && m.getLatitude() <= neLat)
                .filter(m -> m.getLongitude() >= swLng && m.getLongitude() <= neLng)
                .collect(Collectors.toList());

        return ResponseEntity.ok(filtered);
    }

    @GetMapping("/safehouse")
    public ResponseEntity<String> getSafehouseByBounds(
            @RequestParam double minX,
            @RequestParam double minY,
            @RequestParam double maxX,
            @RequestParam double maxY) {

        try {
            String esntlId = "10000828";
            String authKey = "825af222ef8e4965";
            int pageUnit = 100;
            int maxPage = 5;
            List<String> filteredItems = new ArrayList<>();

            ObjectMapper mapper = new ObjectMapper();

            for (int pageIndex = 1; pageIndex <= maxPage; pageIndex++) {
                String params = "esntlId=" + URLEncoder.encode(esntlId, "UTF-8")
                        + "&authKey=" + URLEncoder.encode(authKey, "UTF-8")
                        + "&pageIndex=" + pageIndex
                        + "&pageUnit=" + pageUnit
                        + "&minX=" + minX
                        + "&minY=" + minY
                        + "&maxX=" + maxX
                        + "&maxY=" + maxY
                        + "&writngTrgetDscds=09";

                URL url = new URL("https://www.safe182.go.kr/api/lcm/safeMap.do");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setDoOutput(true);

                OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream(), "UTF-8");
                wr.write(params);
                wr.flush();

                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                StringBuilder result = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    result.append(line);
                }

                wr.close();
                br.close();

                JsonNode root = mapper.readTree(result.toString());

                if (!root.has("result") || !"00".equals(root.get("result").asText())) {
                    break;
                }

                JsonNode list = root.get("list");
                if (list == null || !list.isArray() || list.size() == 0) break;

                for (JsonNode item : list) {
                    if (item.has("cl") && "09".equals(item.get("cl").asText())) {
                        filteredItems.add(item.toString());
                    }
                }

                if (list.size() < 100) break;
            }

            String jsonResult = "{ \"result\": \"00\", \"list\": [" + String.join(",", filteredItems) + "] }";

            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(jsonResult);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .header("Content-Type", "application/json")
                    .body("{\"error\":\"safehouse fetch failed\"}");
        }
    }

    @GetMapping("/offender")
    public ResponseEntity<List<OffenderDTO>> getOffendersByBounds(
            @RequestParam double swLat,
            @RequestParam double swLng,
            @RequestParam double neLat,
            @RequestParam double neLng) {

        List<OffenderDTO> filtered = offenderList.stream()
                .filter(o -> o.getLa() >= swLat && o.getLa() <= neLat)
                .filter(o -> o.getLo() >= swLng && o.getLo() <= neLng)
                .collect(Collectors.toList());

        return ResponseEntity.ok(filtered);
    }

}
