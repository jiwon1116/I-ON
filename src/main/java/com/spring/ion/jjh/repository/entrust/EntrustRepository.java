package com.spring.ion.jjh.repository.entrust;

import com.spring.ion.jjh.dto.entrust.EntrustDTO;
import com.spring.ion.jjh.dto.entrust.EntrustFileDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class EntrustRepository {
    private final SqlSessionTemplate sql;

    public List<EntrustDTO> allEntrustList() {
        return sql.selectList("Entrust.allEntrustList");
    }

    public int write(EntrustDTO EntrustDTO) {
        return sql.insert("Entrust.write", EntrustDTO);
    }

    public EntrustDTO findById(long clickId) {
        return sql.selectOne("Entrust.findById", clickId);
    }

    public void delete(long clickId) {
        sql.delete("Entrust.delete", clickId);
    }

    public int update(EntrustDTO EntrustDTO) {
        return sql.update("Entrust.update", EntrustDTO);
    }

    public List<EntrustDTO> pagingList(Map<String, Integer> pagingParams) {
        return sql.selectList("Entrust.pagingList", pagingParams);
    }

    public int boardCount() {
        return sql.selectOne("Entrust.boardCount");
    }

    public void updateViewCount(long clickId) {
        sql.update("Entrust.updateViewCount", clickId);
    }

    public void saveFile(EntrustFileDTO fileDTO) {
        sql.insert("Entrust.saveFile", fileDTO);
    }

    public List<EntrustFileDTO> findFileById(long clickId) {
        return sql.selectList("Entrust.findFileById", clickId);
    }

    public void deleteFileById(long id) {
        sql.delete("Entrust.deleteFileById", id);
    }

    public List<EntrustDTO> search(String searchContent) {
        return sql.selectList("Entrust.search", searchContent);
    }

    public void increaseLikeCount(Long postId) {
        sql.update("Entrust.increaseLikeCount", postId);
    };

    public void decreaseLikeCount(Long postId) {
        sql.update("Entrust.decreaseLikeCount", postId);
    };

}
