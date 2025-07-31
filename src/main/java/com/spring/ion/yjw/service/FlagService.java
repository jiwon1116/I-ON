package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.FlagDTO;
import com.spring.ion.yjw.repository.FlagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FlagService {
    private final FlagRepository flagRepository;

    public int save(FlagDTO flagDTO) {
        return flagRepository.save(flagDTO);
    }
}
