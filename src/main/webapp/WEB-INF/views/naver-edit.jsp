<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>

<style>
:root {
	--brand: #F2AC28;
	--bg: #F7F7F7;
	--text: #222;
	--muted: #8A8A8A;
	--card: #ffffff;
	--line: #EAEAEA;
	--radius: 18px;
	--shadow: 0 12px 28px rgba(0, 0, 0, .08);
}

* {
	box-sizing: border-box
}

body {
	margin: 0;
	background: var(--bg);
	color: var(--text);
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
		"Noto Sans KR", Helvetica, Arial, "Apple SD Gothic Neo",
		"Malgun Gothic", sans-serif;
}

.wrap {
	min-height: 100vh;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: flex-start;
	padding: 48px 18px;
}

.title {
	text-align: center;
	margin-bottom: 22px;
}

.title h1 {
	font-size: 28px;
	margin: 0 0 10px;
	font-weight: 800;
}

.title p {
	margin: 0;
	color: var(--muted);
	font-size: 15px;
}

.card {
	width: 100%;
	max-width: 720px;
	background: var(--card);
	border-radius: var(--radius);
	padding: 36px;
	box-shadow: var(--shadow);
}

.field {
	margin-bottom: 30px;
}

.field label {
	display: block;
	font-size: 16px;
	font-weight: 700;
	margin-bottom: 10px;
}

.input, select {
	width: 100%;
	height: 56px;
	border: 1px solid var(--line);
	background: #fff;
	border-radius: 14px;
	padding: 0 16px;
	font-size: 16px;
	outline: none;
	transition: border .15s, box-shadow .15s;
}

.input::placeholder {
	color: #bdbdbd;
	font-size: 15px;
}

.input:focus, select:focus {
	border-color: var(--brand);
	box-shadow: 0 0 0 4px rgba(242, 172, 40, .16);
}

.row {
	display: flex;
	gap: 14px;
}

.row>* {
	flex: 1;
}

.message {
	margin: 8px 2px 0;
	font-size: 14px;
	min-height: 20px;
}

.actions {
	display: flex;
	gap: 12px;
	align-items: center;
}

.btn {
	width: 100%;
	height: 56px;
	border: none;
	border-radius: 14px;
	background: var(--brand);
	color: #111;
	font-size: 17px;
	font-weight: 800;
	cursor: pointer;
	transition: transform .05s ease, filter .2s ease;
	box-shadow: 0 10px 18px rgba(242, 172, 40, .28);
}

.btn:active {
	transform: translateY(1px)
}

.btn:hover {
	filter: brightness(0.98)
}

.btn-secondary {
	display: inline-flex;
	justify-content: center;
	align-items: center;
	height: 56px;
	padding: 0 22px;
	border-radius: 14px;
	text-decoration: none;
	background: #fff;
	color: #333;
	border: 1px solid var(--line);
	font-weight: 800;
	font-size: 16px;
	transition: background .15s, box-shadow .15s;
	white-space: nowrap;
	min-width: 90px;
}

.btn-secondary:hover {
	background: #fafafa;
	box-shadow: 0 6px 12px rgba(0, 0, 0, .05);
}

@media ( max-width :480px) {
	.card {
		padding: 26px;
		max-width: 100%;
	}
	.input, select, .btn, .btn-secondary {
		height: 54px;
		font-size: 16px;
	}
	.title h1 {
		font-size: 24px;
	}
}
</style>
</head>
<body>

	<c:if test="${not empty editError}">
		<script>alert('${editError}');</script>
	</c:if>

	<div class="wrap">
		<div class="title">
			<h1>회원 정보 수정</h1>
			<p>변경할 정보를 입력한 뒤 저장하세요</p>
		</div>

		<div class="card">
			<form action="/naver-edit" method="post">
				<div class="field">
					<label for="edit-nickname">닉네임</label> <input class="input" type="text" id="edit-nickname" name="nickname" value="${member.nickname}" placeholder="닉네임은 2~12 자리의 한글, 영어, 숫자만 가능합니다." required />
					<p id="nickname-message" class="message"></p>
				</div>

				<div class="field">
					<label for="reg-city">지역</label>
					<div class="row">
						<select class="input" name="city" id="reg-city" required>
							<option value="">시/도 선택</option>
						</select> <select class="input" name="district" id="reg-district" required disabled>
							<option value="">시/군/구 선택</option>
						</select>
					</div>
				</div>

				<input type="hidden" name="_method" value="patch" /> <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

				<div class="actions">
					<button class="btn" type="submit">수정하기</button>
					<a class="btn-secondary" href="/mypage/">취소</a>
				</div>
			</form>
		</div>
	</div>

	<script>
        const districtMap = {
            "서울특별시": ["강남구","강동구","강북구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구","은평구","종로구","중구","중랑구"],
            "부산광역시": ["강서구","금정구","기장군","남구","동구","동래구","부산진구","북구","사상구","사하구","서구","수영구","연제구","영도구","중구","해운대구"],
            "대구광역시": ["남구","달서구","달성군","동구","북구","서구","수성구","중구"],
            "인천광역시": ["강화군","계양구","남동구","동구","미추홀구","부평구","서구","연수구","옹진군","중구"],
            "광주광역시": ["광산구","남구","동구","북구","서구"],
            "대전광역시": ["대덕구","동구","서구","유성구","중구"],
            "울산광역시": ["남구","동구","북구","울주군","중구"],
            "세종특별자치시": ["세종시"],
            "경기도": ["가평군","고양시 덕양구","고양시 일산동구","고양시 일산서구","과천시","광명시","광주시","구리시","군포시","김포시","남양주시","동두천시","부천시","성남시 분당구","성남시 수정구","성남시 중원구","수원시 권선구","수원시 영통구","수원시 장안구","수원시 팔달구","시흥시","안산시 단원구","안산시 상록구","안성시","안양시 동안구","안양시 만안구","양주시","양평군","여주시","연천군","오산시","용인시 기흥구","용인시 수지구","용인시 처인구","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시"],
            "강원특별자치도": ["강릉시","고성군","동해시","삼척시","속초시","양구군","양양군","영월군","원주시","인제군","정선군","철원군","춘천시","태백시","평창군","홍천군","화천군","횡성군"],
            "충청북도": ["괴산군","단양군","보은군","영동군","옥천군","음성군","제천시","증평군","진천군","청주시 상당구","청주시 서원구","청주시 청원구","청주시 흥덕구","충주시"],
            "충청남도": ["계룡시","공주시","금산군","논산시","당진시","보령시","부여군","서산시","서천군","아산시","연기군","예산군","천안시 동남구","천안시 서북구","청양군","태안군","홍성군"],
            "전북특별자치도": ["고창군","군산시","김제시","남원시","무주군","부안군","순창군","완주군","익산시","임실군","장수군","전주시 덕진구","전주시 완산구","정읍시","진안군"],
            "전라남도": ["강진군","고흥군","곡성군","광양시","구례군","나주시","담양군","목포시","무안군","보성군","순천시","신안군","여수시","영광군","영암군","완도군","장성군","장흥군","진도군","함평군","해남군","화순군"],
            "경상북도": ["경산시","경주시","고령군","구미시","군위군","김천시","문경시","봉화군","상주시","성주군","안동시","영덕군","영양군","영주시","영천시","예천군","울릉군","울진군","의성군","청도군","청송군","칠곡군","포항시 남구","포항시 북구"],
            "경상남도": ["거제시","거창군","고성군","김해시","남해군","밀양시","사천시","산청군","양산시","의령군","진주시","창녕군","창원시 마산합포구","창원시 마산회원구","창원시 성산구","창원시 의창구","창원시 진해구","통영시","하동군","함안군","함양군","합천군"],
            "제주특별자치도": ["서귀포시","제주시"]
        };

        const citySelect = document.getElementById('reg-city');
        const districtSelect = document.getElementById('reg-district');

        for (const city in districtMap) {
            const option = document.createElement('option');
            option.value = city;
            option.textContent = city;
            citySelect.appendChild(option);
        }

        const memberCity = '${member.city}';
        const memberDistrict = '${member.district}';

        function initializeRegion() {
            if (memberCity) { citySelect.value = memberCity; }
            if (memberCity) {
                const districts = districtMap[memberCity];
                while (districtSelect.firstChild) { districtSelect.removeChild(districtSelect.firstChild); }
                const defaultOption = document.createElement('option');
                defaultOption.value = ""; defaultOption.textContent = "시/군/구 선택";
                districtSelect.appendChild(defaultOption);
                if (districts) {
                    for (const district of districts) {
                        const option = document.createElement('option');
                        option.value = district; option.textContent = district;
                        districtSelect.appendChild(option);
                    }
                }
                districtSelect.disabled = false;
                if (memberDistrict) { districtSelect.value = memberDistrict; }
            }
        }

        citySelect.addEventListener('change', (event) => {
            while (districtSelect.firstChild) { districtSelect.removeChild(districtSelect.firstChild); }
            const defaultOption = document.createElement('option');
            defaultOption.value = ""; defaultOption.textContent = "시/군/구 선택";
            districtSelect.appendChild(defaultOption);
            districtSelect.disabled = true;
            const selectedCity = event.target.value;
            if (selectedCity) {
                const districts = districtMap[selectedCity];
                for (const district of districts) {
                    const option = document.createElement('option');
                    option.value = district; option.textContent = district;
                    districtSelect.appendChild(option);
                }
                districtSelect.disabled = false;
            }
        });

        window.onload = initializeRegion;

        let isNicknameChanged = false;
        let isNicknameValid = true;
        const currentNickname = '${member.nickname}';
        const nicknameMessage = $('#nickname-message');
        let getNicknameRegExp = /^[a-zA-Z0-9가-힣]{2,12}$/;

        $('#edit-nickname').on('input', function() {
            nicknameMessage.text('');
            isNicknameChanged = ($(this).val() !== currentNickname);
            isNicknameValid = ($(this).val() === currentNickname);
        });

        $('#edit-nickname').on('blur', function() {
            const nickname = $(this).val();
            if (!nickname.trim()) {
                isNicknameValid = false; return;
            }
            if (nickname === currentNickname) {
                nicknameMessage.text(''); isNicknameValid = true; return;
            }
            if (!getNicknameRegExp.test(nickname)) {
                nicknameMessage.text('닉네임은 2~12 자리의 한글, 영어, 숫자만 가능합니다.').css('color', 'red');
                isNicknameValid = false;
            } else {
                checkDuplicateNickname(nickname);
            }
        });

        function checkDuplicateNickname(nickname) {
            if (!nickname.trim()) {
                nicknameMessage.text('').css('color', '');
                isNicknameValid = false; return;
            }
            $.ajax({
                url: '/checkDuplicateNicknameForEdit',
                type: 'GET',
                data: { nickname: nickname },
                success: function(isDuplicate) {
                    if (isDuplicate) {
                        nicknameMessage.text('이미 사용 중인 닉네임입니다.').css('color', 'red');
                        isNicknameValid = false;
                    } else {
                        nicknameMessage.text('사용 가능한 닉네임입니다.').css('color', 'green');
                        isNicknameValid = true;
                    }
                }
            });
        }

        $('form').on('submit', function(e) {
            if (isNicknameChanged && !isNicknameValid) {
                alert('입력하신 정보들을 다시 확인해주세요.'); e.preventDefault(); return;
            }
            if (!isNicknameChanged) {
                alert('수정된 정보가 없습니다.'); e.preventDefault(); return;
            }
            if (!confirm('정말 회원 정보 수정을 진행하시겠습니까? 30일에 한 번씩만 수정이 가능합니다.')) {
                e.preventDefault(); return;
            }
        });
    </script>
</body>
</html>
