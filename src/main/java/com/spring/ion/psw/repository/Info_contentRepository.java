package com.spring.ion.psw.repository;

import com.spring.ion.psw.dto.Info_FileDTO;
import com.spring.ion.psw.dto.Info_contentDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class Info_contentRepository {

    public final SqlSessionTemplate sql;

    public List<Info_contentDTO> AllfindList() {
       return sql.selectList("Info.allInfoList");
    }

    //게시물 추가
    public int save(Info_contentDTO infoContentDTO) {
        return sql.insert("Info.save",infoContentDTO);
    }


    public Info_contentDTO findContext(long id) {
        return sql.selectOne("Info.find",id);
    }

    //게시물 수정
    public int update(Info_contentDTO infoContentDTO) {
        return sql.update("Info.update",infoContentDTO);
    }

    // 게시물 삭제
    public void delete(long id) {
        sql.delete("Info.delete", id);
    }

    // 조회수 증가
    public void updateHits(long id) {
        sql.update("Info.updateHits", id);
    }

    // 좋아요수 증가
    public void updateLike(long id) {
        sql.update("Info.updateLike", id);
    }

    //페이지 리스트
    public List<Info_contentDTO> pagingList(Map<String, Integer> pagingParams) {
        return sql.selectList("Info.infoPagingList", pagingParams);
    }

    public int infoCount() {
        return sql.selectOne("Info.infoCount");
    }

    //이미지 파일 저장
    public void saveFile(Info_FileDTO infoFileDTO) {
        sql.insert("Info.infoSaveFile", infoFileDTO);
    }

    //이미지 파일 가져오기
    public Info_FileDTO findFile(Long boardId) {
    return sql.selectOne("Info.findInfoFile",boardId);
    }

    // 이미지 수정
    public void update(Info_FileDTO infoFileDTO) {
        sql.insert("Info.infoUpdateFile", infoFileDTO);
    }


    //검색 전용 글 찾기
    public List<Info_contentDTO> searchPagingList(Map<String, Object> pagingParams) {
        return sql.selectList("Info.searchPagingList", pagingParams);
    }

    public int searchCount(String keyword) {
        return sql.selectOne("Info.searchCount", keyword);
    }
}

