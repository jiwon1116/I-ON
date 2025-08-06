package com.spring.ion.jjh.controller.map;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.ion.jjh.dto.map.EmergencyBellDTO;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/map")
public class MapController {

    private final List<EmergencyBellDTO> cachedList;

    public MapController() throws IOException {
        // JSON을 읽어 초기화
        ClassPathResource resource = new ClassPathResource("data/emergencybell.json");
        byte[] jsonData = StreamUtils.copyToByteArray(resource.getInputStream());

        ObjectMapper mapper = new ObjectMapper();
        cachedList = Arrays.asList(mapper.readValue(jsonData, EmergencyBellDTO[].class));
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
}
