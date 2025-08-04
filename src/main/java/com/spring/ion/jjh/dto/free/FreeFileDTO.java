package com.spring.ion.jjh.dto.free;

import lombok.Data;

@Data
public class FreeFileDTO {
    private long id;
    private long board_id;
    private String originalFileName;
    private String storedFileName;
}
