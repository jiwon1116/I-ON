package com.spring.ion.jjh.service.entrust;

import com.spring.ion.jjh.repository.entrust.EntrustLikeRepository;
import com.spring.ion.jjh.repository.entrust.EntrustRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EntrustLikeService {
    private final EntrustLikeRepository entrustLikeRepository;
    private final EntrustRepository entrustRepository;

    // 좋아요 토글
    public boolean toggleLike(Long postId, String memberId) {
        boolean exists = entrustLikeRepository.exists(postId, memberId);
        if (exists) {
            entrustLikeRepository.delete(postId, memberId); // 이미 눌렀으면 취소
            entrustRepository.decreaseLikeCount(postId); // 좋아요 수 감소
            return false; // 이제 안 누른 상태
        } else {
            entrustLikeRepository.insert(postId, memberId); // 안 눌렀으면 등록
            entrustRepository.increaseLikeCount(postId); // 좋아요 수 증가
            return true; // 이제 누른 상태
        }
    }


    public int getLikeCount(Long postId) {
        return entrustLikeRepository.count(postId);
    }

    public boolean isLiked(Long postId, String memberId) {
        return entrustLikeRepository.exists(postId, memberId);
    }
}
