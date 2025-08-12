<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
  <style>
    /* ... 기존 CSS 코드 ... */
    :root{
      --brand: #F2AC28;   /* 포인트 노랑 */
      --bg: #F7F7F7;      /* 페이지 배경 */
      --text: #222;
      --muted: #8A8A8A;
      --card: #ffffff;
      --line: #EAEAEA;
      --radius: 16px;
      --shadow: 0 10px 24px rgba(0,0,0,.06);
    }
    *{box-sizing:border-box}
    body{
      margin:0; background:var(--bg); color:var(--text);
      font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Noto Sans KR", Helvetica, Arial, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
    }
    .wrap{
      min-height:100vh; display:flex; flex-direction:column; align-items:center; justify-content:flex-start;
      padding:40px 16px;
    }
    .title{
      text-align:center; margin-bottom:18px;
    }
    .title h1{
      font-size:24px; margin:0 0 8px; font-weight:800;
    }
    .title p{margin:0; color:var(--muted); font-size:14px}

    /* 스텝퍼 */
    .stepper{
      display:flex; align-items:center; gap:14px;
      justify-content:center; margin:14px 0 26px;
    }
    .step{display:flex; flex-direction:column; align-items:center; gap:6px; min-width:74px}
    .dot{
      width:32px; height:32px; border-radius:50%;
      display:grid; place-items:center; font-weight:700; font-size:14px;
      background:#fff; border:2px solid var(--line); color:#999;
      box-shadow:0 2px 6px rgba(0,0,0,.04);
    }
    .step.active .dot{border-color:var(--brand); color:#000; background:#fff}
    .label{font-size:13px; color:#666}
    .line{
      width:64px; height:2px; background:linear-gradient(90deg, var(--brand), rgba(242,172,40,.35));
      border-radius:1px; opacity:.5;
    }

    /* 카드 */
    .card{
      width:100%; max-width:580px; background:var(--card); border-radius:var(--radius);
      padding:28px; box-shadow:var(--shadow);
    }

    .field{margin-bottom:18px}
    .field label{
      display:block; font-size:15px; font-weight:600; margin-bottom:8px;
    }
    .input, select{
      width:100%; height:50px; border:1px solid var(--line); background:#fff;
      border-radius:12px; padding:0 14px; font-size:15px; outline:none;
      transition:border .15s, box-shadow .15s;
    }
    .input::placeholder{color:#bdbdbd}
    .input:focus, select:focus{
      border-color:var(--brand);
      box-shadow:0 0 0 4px rgba(242,172,40,.15);
    }

    /* 성별 라디오 */
    .gender-row{display:flex; align-items:center; gap:26px}
    .radio{
      display:flex; align-items:center; gap:8px; cursor:pointer; user-select:none;
    }
    .radio input{
      appearance:none; width:18px; height:18px; border-radius:50%;
      border:2px solid #CFCFCF; display:inline-block; position:relative;
      outline:none; transition:all .15s;
      background:#fff;
    }
    .radio input:checked{
      border-color:var(--brand);
      box-shadow:inset 0 0 0 5px var(--brand);
    }

    /* 지역 2열 */
    .row{display:flex; gap:12px}
    .row > *{flex:1}

    /* 버튼 */
    .btn{
      width:100%; height:52px; border:none; border-radius:12px;
      background:var(--brand); color:#111; font-size:16px; font-weight:700;
      cursor:pointer; transition:transform .05s ease, filter .2s ease;
      box-shadow:0 8px 16px rgba(242,172,40,.28);
    }
    .btn:active{transform:translateY(1px)}
    .btn:hover{filter:brightness(0.98)}

    /* 알림 */
    .toast{
      width:100%; max-width:580px; background:#fff3cd; color:#664d03;
      border:1px solid #ffecb5; border-radius:12px; padding:12px 14px;
      margin-bottom:16px;
    }

    @media (max-width:480px){
      .line{width:40px}
      .card{padding:22px}
    }
  </style>
</head>
<body>
<div class="wrap">

  <c:if test="${not empty registerError}">
      <div class="toast">${registerError}</div>
  </c:if>

  <div class="title">
    <h1>아이온 통합 회원가입</h1>
    <p>회원정보를 정확히 입력해주세요</p>
  </div>

  <div class="stepper" aria-label="가입 단계">
    <div class="step active">
      <div class="dot">1</div>
      <div class="label">회원가입</div>
    </div>
    <div class="line"></div>
    <div class="step">
      <div class="dot">2</div>
      <div class="label">자녀 정보 설정</div>
    </div>
    <div class="line"></div>
    <div class="step">
      <div class="dot">3</div>
      <div class="label">사용 준비 완료</div>
    </div>
  </div>

  <div class="card">
    <form action="/register" method="post">
      <div class="field">
        <label for="reg-userId">아이디</label>
        <input class="input" type="text" id="reg-userId" name="userId" placeholder="Value" required />
        <p id="userId-message" class="message"></p>
      </div>

      <div class="field">
        <label for="reg-password">비밀번호</label>
        <input class="input" type="password" id="reg-password" name="password" placeholder="Value" required />
      </div>

      <div class="field">
        <label for="reg-nickname">닉네임</label>
        <input class="input" type="text" id="reg-nickname" name="nickname" placeholder="Value" required />
        <p id="nickname-message" class="message"></p>
      </div>

      <div class="field">
        <label>성별</label>
        <div class="gender-row">
          <label class="radio">
            <input type="radio" name="gender" value="M" checked />
            <span>남</span>
          </label>
          <label class="radio">
            <input type="radio" name="gender" value="F" />
            <span>여</span>
          </label>
        </div>
      </div>

      <div class="field">
        <label>지역</label>
        <div class="row">
          <select class="input" name="city" id="reg-city" required>
            <option value="">시/도 선택</option>
          </select>
          <select class="input" name="district" id="reg-district" required disabled>
            <option value="">시/군/구 선택</option>
          </select>
        </div>
      </div>

      <div class="field">
            <div class="g-recaptcha" data-sitekey="6LfdKZgrAAAAAHP9TN8ZYOJDbKMmdx7Chl1CyUWP"></div>
      </div>

      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      <button class="btn" type="submit">Sign In</button>
    </form>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script type="text/javascript">
    const districtMap = {
        "서울특별시": [
            "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구",
            "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"
        ],
        "부산광역시": [
            "강서구", "금정구", "기장군", "남구", "동구", "동래구", "부산진구", "북구", "사상구", "사하구", "서구", "수영구",
            "연제구", "영도구", "중구", "해운대구"
        ],
        "대구광역시": [
            "남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구"
        ],
        "인천광역시": [
            "강화군", "계양구", "남동구", "동구", "미추홀구", "부평구", "서구", "연수구", "옹진군", "중구"
        ],
        "광주광역시": [
            "광산구", "남구", "동구", "북구", "서구"
        ],
        "대전광역시": [
            "대덕구", "동구", "서구", "유성구", "중구"
        ],
        "울산광역시": [
            "남구", "동구", "북구", "울주군", "중구"
        ],
        "세종특별자치시": [
            "세종시"
        ],
        "경기도": [
            "가평군", "고양시 덕양구", "고양시 일산동구", "고양시 일산서구", "과천시", "광명시", "광주시", "구리시", "군포시",
            "김포시", "남양주시", "동두천시", "부천시", "성남시 분당구", "성남시 수정구", "성남시 중원구", "수원시 권선구", "수원시 영통구", "수원시 장안구", "수원시 팔달구",
            "시흥시", "안산시 단원구", "안산시 상록구", "안성시", "안양시 동안구", "안양시 만안구", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시 기흥구",
            "용인시 수지구", "용인시 처인구", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"
        ],
        "강원특별자치도": [
            "강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"
        ],
        "충청북도": [
            "괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "증평군", "진천군", "청주시 상당구", "청주시 서원구", "청주시 청원구", "청주시 흥덕구", "충주시"
        ],
        "충청남도": [
            "계룡시", "공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "연기군", "예산군", "천안시 동남구", "천안시 서북구", "청양군", "태안군", "홍성군"
        ],
        "전북특별자치도": [
            "고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "장수군", "전주시 덕진구", "전주시 완산구", "정읍시", "진안군"
        ],
        "전라남도": [
            "강진군", "고흥군", "곡성군", "광양시", "구례군", "나주시", "담양군", "목포시", "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "영암군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"
        ],
        "경상북도": [
            "경산시", "경주시", "고령군", "구미시", "군위군", "김천시", "문경시", "봉화군", "상주시", "성주군", "안동시", "영덕군", "영양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시 남구", "포항시 북구"
        ],
        "경상남도": [
            "거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군", "양산시", "의령군", "진주시", "창녕군", "창원시 마산합포구", "창원시 마산회원구", "창원시 성산구", "창원시 의창구", "창원시 진해구", "통영시", "하동군", "함안군", "함양군", "합천군"
        ],
        "제주특별자치도": [
            "서귀포시", "제주시"
        ]
    };

    const citySelect = document.getElementById('reg-city');
    const districtSelect = document.getElementById('reg-district');

    for (const city in districtMap) {
        const option = document.createElement('option');
        option.value = city;
        option.textContent = city;
        citySelect.appendChild(option);
    }

    citySelect.addEventListener('change', (event) => {
        while (districtSelect.firstChild) {
            districtSelect.removeChild(districtSelect.firstChild);
        }

        const defaultOption = document.createElement('option');
        defaultOption.value = "";
        defaultOption.textContent = "시/군/구 선택";
        districtSelect.appendChild(defaultOption);

        districtSelect.disabled = true;
        const selectedCity = event.target.value;
        if (selectedCity) {
            const districts = districtMap[selectedCity];
            for (const district of districts) {
                const option = document.createElement('option');
                option.value = district;
                option.textContent = district;
                districtSelect.appendChild(option);
            }
            districtSelect.disabled = false;
        }
    });

    let isUserIdValid = false;
    let isNicknameValid = false;

    const userIdMessage = $('#userId-message');
    const nicknameMessage = $('#nickname-message');

    $('#reg-userId').on('blur', function() {
        checkDuplicateUserId($(this).val());
    });

    $('#reg-nickname').on('blur', function() {
        checkDuplicateNickname($(this).val());
    });


    function checkDuplicateUserId(userId) {
        if (!userId.trim()) {
            userIdMessage.text('').css('color', '');
            isUserIdValid = false;
            return;
        }

        $.ajax({
            url: '/checkDuplicateUserId',
            type: 'GET',
            data: { userId: userId },
            success: function(isDuplicate) {
                if (isDuplicate) {
                    userIdMessage.text('이미 사용 중인 아이디입니다.').css('color', 'red');
                    isUserIdValid = false;
                } else {
                    userIdMessage.text('사용 가능한 아이디입니다.').css('color', 'green');
                    isUserIdValid = true;
                }
            }
        });
    }

    function checkDuplicateNickname(nickname) {
        if (!nickname.trim()) {
            nicknameMessage.text('').css('color', '');
            isNicknameValid = false;
            return;
        }

        $.ajax({
            url: '/checkDuplicateNickname',
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
        if (!confirm('회원가입을 진행하시겠습니까?')) {
            e.preventDefault();
            return;
        }

        if (!isUserIdValid || !isNicknameValid) {
            alert('아이디 또는 닉네임 중복을 확인해주세요.');
            e.preventDefault();
            return;
        }
    });

</script>
</body>
</html>