package com.spring.ion.psw.repository;

import com.spring.ion.psw.dto.Info_contentDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class Info_contentRepository {

    private final SqlSessionTemplate sql;
    // 모든 게시물 반환
  /*  public static List<Info_contentDTO> AllfindList() {

    }*/
}
