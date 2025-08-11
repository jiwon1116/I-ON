package com.spring.ion.lcw.service;

import com.spring.ion.lcw.dto.MemberDTO;
import com.spring.ion.lcw.repository.MemberRepository;
import com.spring.ion.lcw.security.InfoChangeRestrictionException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    public MemberDTO findById(Long id) {
        return memberRepository.findById(id);
    }

    public MemberDTO findByUserId(String userId) {
        return memberRepository.findByUserId(userId);
    }

    public MemberDTO findByNickname(String nickname) {
        return memberRepository.findByNickname(nickname);
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

        if (memberDTO.getCity() != null && !memberDTO.getCity().isEmpty()) {
            currentMember.setCity(memberDTO.getCity());
        }

        if (memberDTO.getDistrict() != null && !memberDTO.getDistrict().isEmpty()) {
            currentMember.setDistrict(memberDTO.getDistrict());
        }

        currentMember.setInfoUntil(LocalDateTime.now().plusDays(30));

        memberRepository.edit(currentMember);
    }

    public void updateProfileImg(String userId, String profileImg) {
        memberRepository.updateProfileImg(userId, profileImg);
    }

    @Transactional
    public void banUser(String userId, LocalDateTime banUntil) {
        MemberDTO member = memberRepository.findByUserId(userId);
        if (member == null) {
            throw new IllegalArgumentException("해당 회원을 찾을 수 없습니다.");
        }
        member.setEnabled(false);  // enabled를 false로 설정하여 회원 정지
        member.setBanUntil(banUntil);  // 정지 기간 설정
        memberRepository.updateMemberBan(member);  // DB에 반영
    }

    @Transactional
    public void unbanUser(String userId) {
        MemberDTO member = memberRepository.findByUserId(userId);
        if (member == null) {
            throw new IllegalArgumentException("해당 회원을 찾을 수 없습니다.");
        }
        member.setEnabled(true);  // enabled를 true로 설정하여 회원 정지 해제
        memberRepository.unban(member);  // DB에 반영
    }
}
