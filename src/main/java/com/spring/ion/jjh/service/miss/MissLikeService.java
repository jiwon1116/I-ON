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

    public boolean toggleLike(Long postId, String memberId) {
        boolean exists = missLikeRepository.exists(postId, memberId);
        if (exists) {
            missLikeRepository.delete(postId, memberId);
            missRepository.decreaseLikeCount(postId);
            return false;
        } else {
            missLikeRepository.insert(postId, memberId);
            missRepository.increaseLikeCount(postId);
            return true;
        }
    }


    public int getLikeCount(Long postId) {
        return missLikeRepository.count(postId);
    }

    public boolean isLiked(Long postId, String memberId) {
        return missLikeRepository.exists(postId, memberId);
    }
}
