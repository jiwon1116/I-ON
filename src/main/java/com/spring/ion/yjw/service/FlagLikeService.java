package com.spring.ion.yjw.service;

import com.spring.ion.yjw.repository.FlagLikeRepository;
import com.spring.ion.yjw.repository.FlagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class FlagLikeService {
    private final FlagLikeRepository flagLikeRepository;
    private final FlagRepository flagRepository;


    public boolean toggleLike(Long post_id, String memberId) {
        boolean exists = flagLikeRepository.exists(post_id, memberId);
        if (exists) {
            flagLikeRepository.delete(post_id, memberId);
        } else {
            flagLikeRepository.insert(post_id, memberId);
        }
        flagLikeRepository.updateLikeCount(post_id);
        return !exists;
    }


    public int getLikeCount(Long post_id) {
        return flagLikeRepository.count(post_id);
    }

    public boolean isLiked(Long post_id, String memberId) {
        return flagLikeRepository.exists(post_id, memberId);
    }


}
