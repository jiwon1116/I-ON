package com.spring.ion.yjw.dto;

import lombok.Data;

@Data
public class FlagFileDTO {
    private long id; // 파일 아이디
    private long board_id; // 파일이 첨부된 게시글 아이디
    private String originalFileName; // 사용자가 업로드한 원래 파일명
    private String fileName; // 서버에 저장된 고유한 파일명 (UUID)
}
