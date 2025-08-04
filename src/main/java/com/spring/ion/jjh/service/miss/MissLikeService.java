package com.spring.ion.jjh.service.miss;

import com.spring.ion.jjh.repository.miss.MissLikeRepository;
import com.spring.ion.jjh.repository.miss.MissRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MissLikeService {
    private final MissLikeRepository missLikeRepository;
    private final MissRepository missRepository;

    // 좋아요 토글
    public boolean toggleLike(Long postId, String memberId) {
        boolean exists = missLikeRepository.exists(postId, memberId);
        if (exists) {
            missLikeRepository.delete(postId, memberId); // 이미 눌렀으면 취소
            missRepository.decreaseLikeCount(postId); // 좋아요 수 감소
            return false; // 이제 안 누른 상태
        } else {
            missLikeRepository.insert(postId, memberId); // 안 눌렀으면 등록
            missRepository.increaseLikeCount(postId); // 좋아요 수 증가
            return true; // 이제 누른 상태
        }
    }


    public int getLikeCount(Long postId) {
        return missLikeRepository.count(postId);
    }

    public boolean isLiked(Long postId, String memberId) {
        return missLikeRepository.exists(postId, memberId);
    }
}
