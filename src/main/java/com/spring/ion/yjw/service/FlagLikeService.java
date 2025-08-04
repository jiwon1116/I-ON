package com.spring.ion.yjw.service;

import com.spring.ion.yjw.repository.FlagLikeRepository;
import com.spring.ion.yjw.repository.FlagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class FlagLikeService {
    private final FlagLikeRepository flagLikeRepository;
    private final FlagRepository flagRepository; // 추가


    // 좋아요 토글
    public boolean toggleLike(Long post_id, String memberId) {
        boolean exists = flagLikeRepository.exists(post_id, memberId);
        if (exists) {
            flagLikeRepository.delete(post_id, memberId);
        } else {
            flagLikeRepository.insert(post_id, memberId);
        }
        flagLikeRepository.updateLikeCount(post_id); // ← 여기로!
        return !exists;
    }



    public int getLikeCount(Long post_id) {
        return flagLikeRepository.count(post_id);
    }

    public boolean isLiked(Long post_id, String memberId) {
        return flagLikeRepository.exists(post_id, memberId);
    }



}
