package com.spring.ion.yjw.service;

import com.spring.ion.yjw.repository.FlagLikeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FlagLikeService {
    private final FlagLikeRepository flagLikeRepository;

    // 좋아요 토글
    public boolean toggleLike(Long post_id, String memberId) {
        boolean exists = flagLikeRepository.exists(post_id, memberId);
        if (exists) {
            flagLikeRepository.delete(post_id, memberId); // 이미 눌렀으면 취소
            return false; // 이제 안 누른 상태
        } else {
            flagLikeRepository.insert(post_id, memberId); // 안 눌렀으면 등록
            return true; // 이제 누른 상태
        }
    }


    public int getLikeCount(Long post_id) {
        return flagLikeRepository.count(post_id);
    }

    public boolean isLiked(Long post_id, String memberId) {
        return flagLikeRepository.exists(post_id, memberId);
    }
}
