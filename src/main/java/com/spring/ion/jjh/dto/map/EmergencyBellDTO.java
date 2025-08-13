package com.spring.ion.jjh.dto.map;

import lombok.Data;

@Data
public class EmergencyBellDTO {
        private String id;
        private String locationName;
        private String roadAddress;
        private String jibunAddress;
        private double latitude;
        private double longitude;
        private String linkType;
        private String policeLinked;
        private String agencyPhone;
}
