<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
</head>
<body>
    <c:if test="${not empty editError}">
        <script>
            alert('${editError}');
        </script>
    </c:if>
    <form action="/edit" method="post" onsubmit="return confirm('정말 회원 정보를 수정하시겠습니까?\n30일에 한 번씩만 수정이 가능합니다.');">
                    <div>
                        <label for="edit-password">비밀번호:</label>
                        <input type="password" id="edit-password" name="password" placeholder="변경 시에만 입력해주세요." />
                    </div>
                    <div>
                        <label for="edit-nickname">닉네임:</label>
                        <input type="text" id="edit-nickname" name="nickname" value="${member.nickname}"/>
                    </div>
                    <div>
                        <label for="edit-region">지역:</label>
                        <select name="region" id="edit-region" required>
                            <option value="서울특별시" <c:if test="${member.region eq '서울특별시'}">selected</c:if>>서울특별시</option>
                            <option value="부산광역시" <c:if test="${member.region eq '부산광역시'}">selected</c:if>>부산광역시</option>
                            <option value="대구광역시" <c:if test="${member.region eq '대구광역시'}">selected</c:if>>대구광역시</option>
                            <option value="인천광역시" <c:if test="${member.region eq '인천광역시'}">selected</c:if>>인천광역시</option>
                            <option value="광주광역시" <c:if test="${member.region eq '광주광역시'}">selected</c:if>>광주광역시</option>
                            <option value="대전광역시" <c:if test="${member.region eq '대전광역시'}">selected</c:if>>대전광역시</option>
                            <option value="울산광역시" <c:if test="${member.region eq '울산광역시'}">selected</c:if>>울산광역시</option>
                            <option value="세종특별자치시" <c:if test="${member.region eq '세종특별자치시'}">selected</c:if>>세종특별자치시</option>
                            <option value="경기도" <c:if test="${member.region eq '경기도'}">selected</c:if>>경기도</option>
                            <option value="강원특별자치도" <c:if test="${member.region eq '강원특별자치도'}">selected</c:if>>강원특별자치도</option>
                            <option value="충청북도" <c:if test="${member.region eq '충청북도'}">selected</c:if>>충청북도</option>
                            <option value="충청남도" <c:if test="${member.region eq '충청남도'}">selected</c:if>>충청남도</option>
                            <option value="전북특별자치도" <c:if test="${member.region eq '전북특별자치도'}">selected</c:if>>전북특별자치도</option>
                            <option value="전라남도" <c:if test="${member.region eq '전라남도'}">selected</c:if>>전라남도</option>
                            <option value="경상북도" <c:if test="${member.region eq '경상북도'}">selected</c:if>>경상북도</option>
                            <option value="경상남도" <c:if test="${member.region eq '경상남도'}">selected</c:if>>경상남도</option>
                            <option value="제주특별자치도" <c:if test="${member.region eq '제주특별자치도'}">selected</c:if>>제주특별자치도</option>
                        </select>
                    </div>

                    <input type="hidden" name="_method" value="patch" />
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit">수정하기</button>
                    <a href="/myPage/">마이페이지</a>
                </form>
</body>
</html>