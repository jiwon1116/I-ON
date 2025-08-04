package com.spring.ion.jjh.dto.miss;

import lombok.Data;

@Data
public class MissFileDTO {
    private long id;
    private long board_id;
    private String originalFileName;
    private String storedFileName;
}
