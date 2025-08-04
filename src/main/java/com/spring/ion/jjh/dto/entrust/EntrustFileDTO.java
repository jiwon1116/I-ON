package com.spring.ion.jjh.dto.entrust;

import lombok.Data;

@Data
public class EntrustFileDTO {
    private long id;
    private long board_id;
    private String originalFileName;
    private String storedFileName;
}
