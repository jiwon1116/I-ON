package com.spring.ion.yjw.dto;

import lombok.Data;

import java.util.List;

@Data
public class FlagFileDTO {
    private List<FlagFileDTO> files;
    private long id;
    private long board_id;
    private String originalFileName;
    private String storedFileName;
}
