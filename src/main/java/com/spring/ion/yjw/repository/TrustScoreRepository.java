package com.spring.ion.yjw.repository;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class TrustScoreRepository {
    private final SqlSessionTemplate sql;

    // 전체 댓글(모든 댓글 테이블 합)
    public int countAllCommentsByNickname(String nickname) {
        int free = sql.selectOne("trust.countFreeComments", nickname);
        int flag = sql.selectOne("trust.countFlagComments", nickname);
        int miss = sql.selectOne("trust.countMissComments", nickname);
        int entrust = sql.selectOne("trust.countEntrustComments", nickname);
        return free + flag + miss + entrust;
    }

    public int countAllReportsByNickname(String nickname) {
        return sql.selectOne("trust.countAllReportsByNickname", nickname);
    }

    public int countAllEntrustsByNickname(String nickname) {
        return sql.selectOne("trust.countAllEntrustsByNickname", nickname);
    }

    public void updateMemberTrust(String nickname, int total) {
        var param = new java.util.HashMap<String,Object>();
        param.put("nickname", nickname);
        param.put("total", total);

        sql.update("trust.updateMemberTrustScoreOnly", param);

    }


}
