package com.spring.ion.psw.repository;

import com.spring.ion.psw.dto.NotifyDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class NotifyRepository {
    private final SqlSessionTemplate sql;

    // 댓글 알림저장
    public void saveNotify(NotifyDTO notify) {
        sql.insert("Notify.saveNotify", notify);
    }
}
