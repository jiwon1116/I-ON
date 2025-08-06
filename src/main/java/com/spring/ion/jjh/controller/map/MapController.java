package com.spring.ion.jjh.controller.map;

import com.spring.ion.jjh.dto.map.EmergencyBellDTO;
import org.apache.poi.ss.usermodel.Cell;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/map")
public class MapController {

    private List<EmergencyBellDTO> cachedList = null;

    @GetMapping("/emergencybell")
    public ResponseEntity<?> getEmergencyBellMarkers() {
        try {
            // classpath 기준 경로
            ClassPathResource resource = new ClassPathResource("src/main/webapp/resources/data/emergencybell.json");

            // 파일 내용을 문자열로 읽음
            byte[] jsonData = StreamUtils.copyToByteArray(resource.getInputStream());
            String json = new String(jsonData, StandardCharsets.UTF_8);

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(json);

        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("{\"error\": \"JSON 파일 로딩 실패\"}");
        }
    }

    // 셀에서 문자열 가져오기
    private String getString(Cell cell) {
        if (cell == null) return "";

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                return String.valueOf(cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }

    // 셀에서 double 가져오기
    private double getDouble(Cell cell) {
        if (cell == null) return 0.0;

        switch (cell.getCellType()) {
            case NUMERIC:
                return cell.getNumericCellValue();
            case STRING:
                try {
                    return Double.parseDouble(cell.getStringCellValue().trim());
                } catch (NumberFormatException e) {
                    System.err.println("잘못된 숫자 형식: " + cell.getStringCellValue());
                    return 0.0;
                }
            default:
                return 0.0;
        }
    }

}
