package com.spring.ion.psw.service;

import com.spring.ion.psw.repository.Info_LikeRepository;
import com.spring.ion.yjw.repository.FlagLikeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class Info_LikeService {
private final Info_LikeRepository infoLikeRepository;
    // 좋아요 토글
    public boolean toggleLike(Long findId, String memberId) {

        boolean exists = infoLikeRepository.exists(findId, memberId);
        if (exists) {
            infoLikeRepository.delete(findId, memberId); // 이미 눌렀으면 취소
            return false; // 이제 안 누른 상태
        } else {
            infoLikeRepository.insert(findId, memberId); // 안 눌렀으면 등록
            return true; // 이제 누른 상태
        }
    }


    public int getLikeCount(Long findId) {
        return infoLikeRepository.count(findId);
    }

    public boolean isLiked(Long findId, String memberId) {
        return infoLikeRepository.exists(findId, memberId);
    }
}
