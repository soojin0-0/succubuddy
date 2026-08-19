<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<html>
<head>
<title>이용약관</title>
  <style>
   @font-face {
      font-family: 'GmarketSansTTFMedium';
      src: url('fonts/GmarketSansTTFMedium.ttf') format('truetype');
    }
    @font-face {
      font-family: 'GmarketSansTTFBold';
      src: url('fonts/GmarketSansTTFBold.ttf') format('truetype');
    }
    @font-face {
      font-family: 'GmarketSansTTFLight';
      src: url('fonts/GmarketSansTTFLight.ttf') format('truetype');
    }
    @font-face {
      font-family: 'RixInooAriDuriPro';
      src: url('fonts/RixInooAriDuri_Pro Regular.otf') format('opentype');
      font-weight: normal;
      font-style: normal;
    }

    .terms-wrapper {
      width: 1500px;
      margin: 0 auto;
      padding: 30px;
      color: #333;
    }

    .terms-wrapper h2 {
      font-family: 'GmarketSansTTFMedium';
      font-size: 32px;
      text-align: center;
      margin-bottom: 40px;
    }

    .terms-wrapper h5 {
      font-family: 'GmarketSansTTFMedium';
      font-size: 24px;
      margin-bottom: 15px;
      text-align: left;
    }

    .terms-wrapper p {
      font-family: 'GmarketSansTTFLight';
      font-size: 20px;
      text-align: left;
      line-height: 1.8;
    }
	.navbar {
			display: flex;
			justify-content: space-between;
			align-items: center;
			padding: 82px 150px;
			width: 1920px;
			margin: 0 auto;
			margin-bottom: 20px; /* 네비게이션 아래 여백 추가 */
		}

		.logo {
			display: block;
			width: 300px;
			height: 56px;
			margin-left: -30px;
			margin-right: 20px;
		}

		.nav-menu {
			display: flex;
			align-items: center;
			gap: 80px;
		}

		.nav-menu a {
			text-decoration: none;
			color: black;
			font-size: 26px;
			font-weight: 550;
			font-family: 'GmarketSansTTFMedium';
			margin-top: 12px;
		}

		.nav-icons {
			display: flex;
			align-items: center;
			gap: 35px; /* 아이콘 및 로그인 간격 */
			margin-top: 10px; /* 아이콘과 로그인 위치 조정 */
			margin-left: 33px;
		}

		/* 아이콘 크기 조정 */
		.nav-icons img {
			width: 40px;
			height: 40px;
		}

		/* 로그아웃 링크 스타일 */
		.nav-login {
			text-decoration: none;
			font-size: 24px;
			font-family: 'GmarketSansTTFMedium';
			color: black;
			margin-top:10px;
		}
		.footer {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 1920px;
            height: 283px;
            padding: 0 150px; /* 왼쪽과 오른쪽 패딩 조정 */
            background-color: #60af46;
        }

        .footer-left,
        .footer-right {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .footer-left {
            font-size: 45px;
            font-family: 'RixInooAriDuriPro'; /* Medium font 적용 */
            margin-left: 35px;
			color: #ffffff;
        }

        .footer-right {
            font-size: 16px;
            color: #ffffff;
            margin-left: 177px;
            font-family: 'GmarketSansTTFLight'; /* Light font 적용 */
        }

        .footer-right span {
            margin-bottom: 10px;
        }

        .footer-right a {
            text-decoration: none;
            color: #ffffff;
        }
  </style>
</head>
<body>

<header class="navbar">
		<a href="main.jsp">
		<img src="images/logo.png" alt="SuccuBuddy Logo" class="logo">
		</a>
		<nav class="nav-menu">
			<a href="sub1.jsp">다육 세트</a>
			<a href="sub2.jsp">다육 단품</a>
			<a href="sub3.jsp">맞춤 다육 추천</a>
			<a href="sub4.jsp">다육 탐구 생활</a>
			<a href="sub5.jsp">고객센터</a>
		</nav>
		<div class="nav-icons">
			<a href="mypage.jsp"><img src="images/Person.png" alt="사용자"></a>
			<a href="shopping_list.jsp"><img src="images/cart.png" alt="장바구니"></a>
			<a href="logout.jsp" class="nav-login">로그아웃</a> 
		</div>
	</header>


  <div class="terms-wrapper">
    <h2>이용약관</h2>

    <h5>제1조 (목적)</h5>
    <p>이 약관은 Succubuddy(이하 ‘회사’)가 운영하는 웹사이트(http://localhost:8080/succu/main.html) 및 관련 서비스(이하 ‘succubuddy’)의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임, 이용 절차 등을 규정함을 목적으로 합니다.</p>
	<h5>제2조 (정의)</h5>
    <p>본 약관에서 사용하는 용어의 정의는 다음과 같습니다.</p>
    <p>1. 'succubuddy'라 함은 회사가 다육식물 관련 정보, 콘텐츠, 커뮤니티, 실제 정보 등을 제공하기 위해 운영하는 웹사이트를 말합니다.</p>
    <p>2. ‘이용자’란 본 약관에 따라 회사가 제공하는 서비스를 이용하는 자를 말합니다.</p>
    <p>3. ‘회원’이란 회사에 개인정보를 제공하여 회원 등록을 하고 회사의 정보를 지속적으로 제공받으며 서비스를 계속적으로 이용할 수 있는 자를 말합니다.</p>
    <p>4. ‘콘텐츠’란 회사 또는 회원이 웹사이트를 통해 게시하거나 제공하는 텍스트, 이미지, 영상 등의 모든 형태를 말합니다.</p>

    <h5>제3조 (약관 등의 명시와 설명 및 개정)</h5>
    <p>회사는 이 약관의 내용과 상호, 영업소 소재지, 연락처 등을 이용자가 쉽게 확인할 수 있도록 사이트 초기화면 또는 연결화면에 게시합니다.</p>
    <p>회사는 관련 법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있으며, 개정 시 사전 공지합니다.</p>
    <p>단, 관련 법령에 명확히 반하지 않을 경우 이용자에게 최혜 조건을 적용하며, 개정약관 시행일 이후에도 서비스를 계속 이용하는 경우에는 변경에 동의한 것으로 간주합니다.</p>
	
	<h5>제4조 (서비스의 제공 및 변경)</h5>
    <p>회사는 다음과 같은 서비스를 제공합니다.</p>
    <p>① 다육식물 관련 정보 및 콘텐츠 제공<br>
    ② 커뮤니티 게시판 운영<br>
    ③ 이용자 계정 생성 및 회원 정보 처리<br>
    ④ 기타 회사가 정하는 서비스</p>
    <p>회사는 기술적 사유나 정책적 판단 등 불가피한 사유가 발생할 경우 제공 서비스를 변경할 수 있으며, 이 경우 사전 공지합니다.</p>

    <h5>제5조 (서비스의 중단)</h5>
    <p>회사는 시스템 오류, 유지보수, 고객 불가피한 사유가 발생할 경우 일시적으로 서비스를 제공을 중단할 수 있습니다.<br>
    외부적인 문제로 서비스를 중지하는 사태가 불가피하며, 불가피한 경우 사전 고지를 할 수 없습니다.</p>

    <h5>제6조 (회원가입)</h5>
    <p>이용자는 회사가 정한 절차에 따라 이용계약을 신청하고 회사는 이에 대해 승낙함으로써 회원가입이 완료됩니다.</p>
    <p>회사는 다음 각 호의 경우 이용계약의 체결을 거부하거나 해지할 수 있습니다.</p>
    <p>① 등록 내용에 허위, 누락, 오기가 있는 경우<br>
    ② 기타 회원으로 등록하는 것이 회사의 기술상 현저히 지장이 있다고 판단되는 경우</p>
	
	<h5>제7조 (회원 탈퇴 및 자격 상실)</h5>
    <p>회원은 언제든지 회사에 이메일이나 또는 문의를 통해 회원 탈퇴를 요청할 수 있으며, 회사는 지체 없이 처리합니다.<br>
    회사는 회원이 다음 각 호에 해당하는 경우, 사전 통보 후 회원자격을 제한하거나 상실시킬 수 있습니다.</p>
    <p>① 허위 정보를 등록한 경우<br>
    ② 타인의 권리를 침해하거나 커뮤니티를 훼손시키는 경우<br>
    ③ 법령을 위반한 행위를 위반하는 경우</p>

    <h5>제8조 (회원의 ID 및 비밀번호에 대한 의무)</h5>
    <p>다만 비밀번호에 대한 관리책임은 회원에게 있으며, 이를 제3자에게 제공해서는 안 됩니다.<br>
    회원은 자신의 ID 및 비밀번호가 도용되었음을 인지한 경우 즉시 회사에 통보하고 회사의 안내에 따라야 합니다.</p>

    <h5>제9조 (이용자의 의무)</h5>
    <p>이용자는 다음 행위를 하여서는 안 됩니다.</p>
    <p>① 타인의 개인정보 도용<br>
    ② 허위 정보의 등록<br>
    ③ 회사 또는 제3자의 저작권, 상표권 등 권리 침해<br>
    ④ 커뮤니티에서 비속어, 욕설, 도배, 혐오 표현<br>
    ⑤ 기타 관계 법령에 위반되거나 공서양속에 반하는 행위</p>
	
	<h5>제10조 (게시물의 관리)</h5>
    <p>이용자가 작성한 게시물이 본 약관에 위반되거나 타인의 권리를 침해한다고 판단될 경우, 회사는 해당 게시물을 사전통지 없이 삭제하거나 게시를 제한할 수 있습니다.<br>
    회사는 회원이 게시물 관련 다툼에 연루된 경우, 이를 삭제하거나 제한할 수 있습니다.</p>
    <p>① 타인 비방, 욕설, 명예훼손 등 불법 정보<br>
    ② 상업적 광고 및 도배성 글<br>
    ③ 미풍양속 또는 윤리적 문제의 내용<br>
    ④ 기타 커뮤니티 목적에서 벗어나는 경우</p>

    <h5>제11조 (저작권의 귀속 및 이용제한)</h5>
    <p>회사가 작성한 콘텐츠 및 저작물에 대한 저작권은 회사에 있습니다.<br>
    이용자 생성 콘텐츠는 저작권이 본인에게 있으며 회사는 서비스 운영 및 홍보 목적으로 이를 사용할 수 있습니다.</p>
    <p>이용자는 회사의 서면 동의 없이 사이트의 자료를 복제, 전송, 출판, 배포, 방송 기타 방법으로 이용하거나 제3자에게 이용하게 하여서는 안 됩니다.</p>
	
	<h5>제12조 (책임의 제한)</h5>
    <p>회사는 천재지변, 불가항력 또는 이용자의 귀책사유로 인한 서비스 이용 장애에 대해 책임을 지지 않습니다.<br>
    회사는 이용자가 게시물로 정보, 자료, 사실의 신뢰도, 정확성 등에 대한 책임을 지지 않습니다.<br>
    회사는 이용자가 고의 또는 과실로 이용자의 저장자료 손실로 인한 피해가 발생한 경우에도 책임을 지지 않습니다.</p>

    <h5>제13조 (분쟁해결)</h5>
    <p>회사는 이용자 간 분쟁을 원만하게 해결하기 위해 성실히 협의합니다.<br>
    분쟁이 해결되지 않을 경우, 관할 법원은 회사 본사 소재지를 관할 법원으로 합니다.</p>

    <h5>제14조 (약관의 효력 및 해석)</h5>
    <p>본 약관은 게시시부터 효력을 가집니다.<br>
    본 약관에 명시되지 않은 사항은 관계법령 및 상관례에 따릅니다.</p>

    <h5>[부칙]</h5>
    <p>이 약관은 2025년 5월 20일부터 시행합니다.</p>

  </div>

  <footer class="footer">
    <div class="footer-left">
        <span class="brand-name">succubuddy</span>
    </div>
    <div class="footer-right">
	<br>
        <span>주소 : 충청남도 천안시 서북구 성환읍 대학로 91 | EMAIL : succubuddy@naver.com</span>
        <span>TEL : 070-022-2026 | &copy; 2025 succubuddy. All Rights Reserved.</span>
		<br>
       <span><a href="footer_policy.jsp">개인정보처리방침</a> | <a href="footer_terms.jsp">이용약관</a></span>
    </div>
</footer>
</body>
</html>
