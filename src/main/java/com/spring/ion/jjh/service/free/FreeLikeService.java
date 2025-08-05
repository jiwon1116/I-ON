package com.spring.ion.jjh.service.free;

import com.spring.ion.jjh.repository.free.FreeLikeRepository;
import com.spring.ion.jjh.repository.free.FreeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FreeLikeService {
    private final FreeLikeRepository freeLikeRepository;
    private final FreeRepository freeRepository;

    // 좋아요 토글
    public boolean toggleLike(Long postId, String memberId) {
        boolean exists = freeLikeRepository.exists(postId, memberId);
        if (exists) {
            freeLikeRepository.delete(postId, memberId); // 이미 눌렀으면 취소
            freeRepository.decreaseLikeCount(postId); // 좋아요 수 감소
            return false; // 이제 안 누른 상태
        } else {
            freeLikeRepository.insert(postId, memberId); // 안 눌렀으면 등록
            freeRepository.increaseLikeCount(postId); // 좋아요 수 증가
            return true; // 이제 누른 상태
        }
    }


    public int getLikeCount(Long postId) {
        return freeLikeRepository.count(postId);
    }

    public boolean isLiked(Long postId, String memberId) {
        return freeLikeRepository.exists(postId, memberId);
    }
}
