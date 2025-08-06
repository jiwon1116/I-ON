package com.spring.ion.jjh.dto.map;

import lombok.Data;

@Data
public class EmergencyBellDTO {
        private String id; // 번호. PK
        private String locationName; // 설치위치
        private String roadAddress; // 소재지도로명주소
        private String jibunAddress; // 소재지지번주소(도로명주소 없는 경우)
        private double latitude;  // WGS84위도
        private double longitude; // WGS84경도
        private String linkType; // 연계방식
        private String policeLinked; // 경찰연계유무
        private String agencyPhone; // 관리기관전화번호
}
