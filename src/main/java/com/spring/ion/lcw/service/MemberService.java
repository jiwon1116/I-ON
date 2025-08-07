package com.spring.ion.lcw.service;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.repository.MemberRepository;
import com.spring.ion.lcw.security.InfoChangeRestrictionException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    public MemberDTO findByUserId(String userId){
        return memberRepository.findByUserId(userId);
    }

    public void save(MemberDTO memberDTO) {
        memberRepository.save(memberDTO);
    }

    @Transactional
    public void delete(String username) {
        memberRepository.delete(username);
    }

    public void edit(MemberDTO currentMember, MemberDTO memberDTO) {

        if (currentMember.getInfoUntil() != null && currentMember.getInfoUntil().isAfter(LocalDateTime.now())) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH시 mm분");
            String errorMessage = "회원정보는 30일에 한 번씩만 변경하실 수 있습니다. 변경 가능 시간: " + currentMember.getInfoUntil().format(formatter);
            throw new InfoChangeRestrictionException(errorMessage);
        }
        if (memberDTO.getPassword() != null && !memberDTO.getPassword().isEmpty()) {
            String encodedPassword = passwordEncoder.encode(memberDTO.getPassword());
            currentMember.setPassword(encodedPassword);
        }

        if (memberDTO.getNickname() != null && !memberDTO.getNickname().isEmpty()) {
            currentMember.setNickname(memberDTO.getNickname());
        }

        if (memberDTO.getRegion() != null && !memberDTO.getRegion().isEmpty()) {
            currentMember.setRegion(memberDTO.getRegion());
        }

        currentMember.setInfoUntil(LocalDateTime.now().plusDays(30));

        memberRepository.edit(currentMember);
    }

        // 회원 이미지 수정
        public void updateProfileImg(String userId, String profileImg) {
            memberRepository.updateProfileImg(userId, profileImg);
        }


}
