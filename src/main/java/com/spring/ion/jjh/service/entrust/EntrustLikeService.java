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

    public boolean toggleLike(Long postId, String memberId) {
        boolean exists = entrustLikeRepository.exists(postId, memberId);
        if (exists) {
            entrustLikeRepository.delete(postId, memberId);
            entrustRepository.decreaseLikeCount(postId);
            return false;
        } else {
            entrustLikeRepository.insert(postId, memberId);
            entrustRepository.increaseLikeCount(postId);
            return true;
        }
    }


    public int getLikeCount(Long postId) {
        return entrustLikeRepository.count(postId);
    }

    public boolean isLiked(Long postId, String memberId) {
        return entrustLikeRepository.exists(postId, memberId);
    }
}
