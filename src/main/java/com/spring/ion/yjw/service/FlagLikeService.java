package com.spring.ion.yjw.service;

import com.spring.ion.yjw.repository.FlagLikeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FlagLikeService {
    private final FlagLikeRepository flagLikeRepository;

    // 좋아요 토글
    public boolean toggleLike(Long postId, String memberId) {
        boolean exists = flagLikeRepository.exists(postId, memberId);
        if (exists) {
            flagLikeRepository.delete(postId, memberId); // 이미 눌렀으면 취소
            return false; // 이제 안 누른 상태
        } else {
            flagLikeRepository.insert(postId, memberId); // 안 눌렀으면 등록
            return true; // 이제 누른 상태
        }
    }


    public int getLikeCount(Long postId) {
        return flagLikeRepository.count(postId);
    }

    public boolean isLiked(Long postId, String memberId) {
        return flagLikeRepository.exists(postId, memberId);
    }
}
