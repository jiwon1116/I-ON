package com.spring.ion.jjh.service.free;

import com.spring.ion.jjh.dto.free.FreeDTO;
import com.spring.ion.jjh.repository.free.FreeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FreeService {
    private final FreeRepository freeRepository;
//    public List<FreeDTO> allFreeList() {
//        return freeRepository.allFreeList();
//    }

    public int write(FreeDTO freeDTO) {
        return freeRepository.write(freeDTO);
    }
}
