package com.spring.ion.jjh;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EmergencybellConversion {

    public static void main(String[] args) {
        String excelPath = "src/main/resources/data/emergencybell.xlsx";
        String jsonPath = "src/main/resources/data/emergencybell.json";

        List<Map<String, Object>> result = new ArrayList<>();

        try (InputStream is = new FileInputStream(excelPath);
             Workbook workbook = new XSSFWorkbook(is)) {

            Sheet sheet = workbook.getSheetAt(0);

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null || row.getCell(7) == null || row.getCell(8) == null) continue;

                Map<String, Object> marker = new HashMap<>();
                marker.put("id", getString(row.getCell(0)));
                marker.put("locationName", getString(row.getCell(4)));
                marker.put("roadAddress", getString(row.getCell(5)));
                marker.put("jibunAddress", getString(row.getCell(6)));
                marker.put("latitude", getDouble(row.getCell(7)));
                marker.put("longitude", getDouble(row.getCell(8)));
                marker.put("linkType", getString(row.getCell(9)));
                marker.put("policeLinked", getString(row.getCell(10)));
                marker.put("agencyPhone", getString(row.getCell(17)));

                result.add(marker);
            }

            // JSON으로 저장
            ObjectMapper mapper = new ObjectMapper();
            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(jsonPath), result);
            System.out.println("✅ JSON 파일 생성 완료: " + jsonPath);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String getString(Cell cell) {
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

    private static double getDouble(Cell cell) {
        if (cell == null) return 0.0;

        switch (cell.getCellType()) {
            case NUMERIC:
                return cell.getNumericCellValue();
            case STRING:
                try {
                    return Double.parseDouble(cell.getStringCellValue().trim());
                } catch (NumberFormatException e) {
                    System.err.println("⚠️ 잘못된 숫자 형식: " + cell.getStringCellValue());
                    return 0.0;
                }
            default:
                return 0.0;
        }
    }
}
