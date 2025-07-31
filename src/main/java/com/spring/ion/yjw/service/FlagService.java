package com.spring.ion.yjw.service;

import com.spring.ion.yjw.dto.FlagDTO;
import com.spring.ion.yjw.repository.FlagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FlagService {
    private final FlagRepository flagRepository;


    public List<FlagDTO> findAll() {
        return flagRepository.findAll();
    }

    public int save(FlagDTO flagDTO) {
        return flagRepository.save(flagDTO);
    }
}
