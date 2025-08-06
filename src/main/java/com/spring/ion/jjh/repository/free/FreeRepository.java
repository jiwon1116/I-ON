package com.spring.ion.jjh.repository.free;

import com.spring.ion.jjh.dto.free.FreeDTO;
import com.spring.ion.jjh.dto.free.FreeFileDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class FreeRepository {
    private final SqlSessionTemplate sql;

    public List<FreeDTO> allFreeList() {
        return sql.selectList("Free.allFreeList");
    }

    public int write(FreeDTO freeDTO) {
        return sql.insert("Free.write", freeDTO);
    }

    public FreeDTO findById(long clickId) {
        return sql.selectOne("Free.findById", clickId);
    }

    public void delete(long clickId) {
        sql.delete("Free.delete", clickId);
    }

    public int update(FreeDTO freeDTO) {
        return sql.update("Free.update", freeDTO);
    }

    public List<FreeDTO> pagingList(Map<String, Integer> pagingParams) {
        return sql.selectList("Free.pagingList", pagingParams);
    }

    public int boardCount() {
        return sql.selectOne("Free.boardCount");
    }

    public void updateViewCount(long clickId) {
        sql.update("Free.updateViewCount", clickId);
    }

    public void saveFile(FreeFileDTO fileDTO) {
        sql.insert("Free.saveFile", fileDTO);
    }

    public List<FreeFileDTO> findFileById(long clickId) {
        return sql.selectList("Free.findFileById", clickId);
    }

    public void deleteFileById(long id) {
        sql.delete("Free.deleteFileById", id);
    }

    public void increaseLikeCount(Long postId) {
        sql.update("Free.increaseLikeCount", postId);
    };

    public void decreaseLikeCount(Long postId) {
        sql.update("Free.decreaseLikeCount", postId);
    };

    public List<FreeDTO> searchPagingList(String searchContent, int pagingStart, int pageLimit) {
        Map<String, Object> paramMap = Map.of(
                "keyword", searchContent,
                "start", pagingStart,
                "limit", pageLimit
        );
        return sql.selectList("Free.searchPagingList", paramMap);
    }

    public int searchCount(String searchContent) {
        return sql.selectOne("Free.searchCount", searchContent);
    }

    public List<FreeDTO> findAllByWriter(String userId) {
        return sql.selectList("Free.findAllByWriter", userId);
    }
}
