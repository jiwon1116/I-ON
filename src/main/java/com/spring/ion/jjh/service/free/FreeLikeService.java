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

    public boolean toggleLike(Long postId, String memberId) {
        boolean exists = freeLikeRepository.exists(postId, memberId);
        if (exists) {
            freeLikeRepository.delete(postId, memberId);
            freeRepository.decreaseLikeCount(postId);
            return false;
        } else {
            freeLikeRepository.insert(postId, memberId);
            freeRepository.increaseLikeCount(postId);
            return true;
        }
    }


    public int getLikeCount(Long postId) {
        return freeLikeRepository.count(postId);
    }

    public boolean isLiked(Long postId, String memberId) {
        return freeLikeRepository.exists(postId, memberId);
    }
}
