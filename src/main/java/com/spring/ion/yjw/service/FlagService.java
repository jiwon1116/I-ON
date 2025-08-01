package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.FlagPostDTO;
import com.spring.ion.yjw.repository.FlagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FlagService {
    private final FlagRepository flagRepository;



    public int write(FlagPostDTO flag_postDTO) {
        return flagRepository.write(flag_postDTO);
    }
}

