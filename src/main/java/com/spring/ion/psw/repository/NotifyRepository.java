package com.spring.ion.psw.repository;

import com.spring.ion.psw.dto.NotifyDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class NotifyRepository {
    private final SqlSessionTemplate sql;

    // 알림저장
    public void saveNotify(NotifyDTO notify) {
        sql.insert("Notify.saveNotify", notify);
    }

    //  해당 닉네임의 알림 가져오기
    public List<NotifyDTO> findAllByNotify(String nickname) {
        return sql.selectList("Notify.findAllByNotify",nickname);
    }

    public void deleteById(Long id) {
        sql.delete("Notify.deleteById",id);
    }

}
