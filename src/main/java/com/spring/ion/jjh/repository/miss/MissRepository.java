package com.spring.ion.jjh.repository.miss;

import com.spring.ion.jjh.dto.miss.MissDTO;
import com.spring.ion.jjh.dto.miss.MissFileDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class MissRepository {
    private final SqlSessionTemplate sql;

    public List<MissDTO> allMissList() {
        return sql.selectList("Miss.allMissList");
    }

    public int write(MissDTO MissDTO) {
        return sql.insert("Miss.write", MissDTO);
    }

    public MissDTO findById(long clickId) {
        return sql.selectOne("Miss.findById", clickId);
    }

    public void delete(long clickId) {
        sql.delete("Miss.delete", clickId);
    }

    public int update(MissDTO MissDTO) {
        return sql.update("Miss.update", MissDTO);
    }

    public List<MissDTO> pagingList(Map<String, Integer> pagingParams) {
        return sql.selectList("Miss.pagingList", pagingParams);
    }

    public int boardCount() {
        return sql.selectOne("Miss.boardCount");
    }

    public void updateViewCount(long clickId) {
        sql.update("Miss.updateViewCount", clickId);
    }

    public void saveFile(MissFileDTO fileDTO) {
        sql.insert("Miss.saveFile", fileDTO);
    }

    public List<MissFileDTO> findFileById(long clickId) {
        return sql.selectList("Miss.findFileById", clickId);
    }

    public void deleteFileById(long id) {
        sql.delete("Miss.deleteFileById", id);
    }

    public List<MissDTO> search(String searchContent) {
        return sql.selectList("Miss.search", searchContent);
    }

    public void increaseLikeCount(Long postId) {
        sql.update("Miss.increaseLikeCount", postId);
    };

    public void decreaseLikeCount(Long postId) {
        sql.update("Miss.decreaseLikeCount", postId);
    };

}
