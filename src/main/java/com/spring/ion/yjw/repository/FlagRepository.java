package com.spring.ion.yjw.repository;

import com.spring.ion.yjw.dto.FlagFileDTO;
import com.spring.ion.yjw.dto.FlagPostDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;


@Repository
@RequiredArgsConstructor
public class FlagRepository {
    private final SqlSessionTemplate sql;
    @Autowired
    private JdbcTemplate jdbcTemplate;


    public int write(FlagPostDTO flagPostDTO) {
        return sql.insert("Flag.write", flagPostDTO);
    }

    public List<FlagPostDTO> findAll() {
        return sql.selectList("Flag.findAll");
    }

    public FlagPostDTO findById(int id) {
        return sql.selectOne("Flag.findById",id);
    }

    public int update(FlagPostDTO flagPostDTO) {
        return sql.update("Flag.update",flagPostDTO);
    }

    public void delete(int id) {
         sql.delete("Flag.delete",id);
    }

    public List<FlagPostDTO> pagingList(Map<String, Integer> pagingParams) {
        return sql.selectList("Flag.pagingList", pagingParams);
    }

    public int flagCount() {
        return sql.selectOne("Flag.flagCount");
    }


    public List<FlagPostDTO> search(String keyword) {
        return sql.selectList("Flag.search", keyword);
    }

    public void increaseViewCount(int id) {
        sql.update("Flag.increaseViewCount", id);
    }

    public void increaseLikeCount(int id) {
        sql.update("Flag.increaseLikeCount", id);
    }


    public boolean hasLiked(Long postId, Long memberId) {
        String sql = "SELECT COUNT(*) FROM flag_like WHERE post_id = ? AND member_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, postId, memberId);
        return count != null && count > 0;
    }

    public void insertLike(Long postId, Long memberId) {
        String sql = "INSERT INTO flag_like (post_id, member_id) VALUES (?, ?)";
        jdbcTemplate.update(sql, postId, memberId);
    }

    public void saveFile(FlagFileDTO flagFileDTO) {
        sql.insert("Flag.saveFile", flagFileDTO);
    }

    public List<FlagFileDTO> findFilesByBoardId(int id) {
        return sql.selectList("Flag.findFilesByBoardId", id);
    }

    public void deleteFileById(Long fileId) {
        sql.delete("Flag.deleteFileById", fileId);
    }
}
