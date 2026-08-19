<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<html>
<head>
<title>개인정보</title>
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
    .privacy-section {
      width: 1500px;
      margin: 0 auto;
      padding: 30px;
      color: #444;
    }

    .privacy-section h5 {
      font-family: 'GmarketSansTTFMedium';
      font-size: 24px;
      margin-bottom: 20px;
      text-align: left;
    }

    .privacy-section p {
      font-family: 'GmarketSansTTFLight';
      font-size: 20px;
      margin-bottom: 15px;
      text-align: left;
      line-height: 1.8;
    }
	  .privacy-title {
    font-family: 'GmarketSansTTFMedium';
    font-size: 32px;
    color: #222;
    margin-left: 30px;
    margin-top: 50px;
    margin-bottom: 30px;
    text-align: center;
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


  <div class="privacy-section">
  	<h2 class="privacy-title">개인정보처리방침</h2>

    <h5>제1조 (개인정보의 처리 목적)</h5>
    <p>Succubuddy는 다음의 목적을 위하여 개인정보를 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.</p>

    <p><span class="item-title">1. 홈페이지 회원가입 및 관리</span>
    회원 가입 의사 확인, 회원제 서비스 제공, 본인 식별 및 인증, 회원 자격 유지 및 관리, 서비스 부정 이용 방지, 고지·통지, 민원 처리 등을 위해 개인정보를 처리합니다.</p>

    <p><span class="item-title">2. 고객 문의 및 민원 처리</span>
    문의한 고객의 신원 확인, 요청 사항 확인 및 결과 통보를 위한 개인정보를 처리합니다.</p>

    <p><span class="item-title">3. 재화 또는 서비스 제공</span>
    상품 배송, 콘텐츠 제공, 맞춤 서비스 제공, 본인 인증, 요금 결제 및 정산 등을 위해 개인정보를 처리합니다.</p>

    <p><span class="item-title">4. 마케팅 및 광고에의 활용</span>
    신규 서비스 및 이벤트 안내, 맞춤형 콘텐츠 제공, 이용자 서비스 분석 및 통계 등을 위해 개인정보를 활용합니다.</p>

    <p><span class="item-title">5. 이상행위 탐지 및 서비스 개선</span>
    비정상적인 접근 탐지 및 사용자 맞춤형 서비스 개선을 위한 통계 및 분석에 개인정보를 사용합니다.</p>

	<h5>제2조 (개인정보의 처리 및 보유 기간)</h5>
    
    <p>① Succubuddy는 법령에 따른 개인정보 보유·이용기간 또는 이용자로부터 동의받은 기간 내에서 개인정보를 보유 및 처리합니다.</p>

    <p>② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.<br>
    회원가입 및 관리: 수집일로부터 5년</p>

    <p>관련 법령 기준:<br>
    표시/광고에 관한 기록: 6개월<br>
    계약 또는 청약철회, 대금결제 및 재화 등의 공급에 관한 기록: 5년<br>
    소비자 불만 또는 분쟁처리에 관한 기록: 3년<br>
    신용정보 수집 및 이용 기록: 3년</p>

    <p>※ 탈퇴 및 목적 달성 후에는 지체 없이 파기합니다. 단, 부정 이용 방지 등을 위하여 6개월간 구매 인증 정보는 별도 보관될 수 있습니다.</p>

	<h5>제3조 (개인정보의 제3자 제공)</h5>
    <p>Succubuddy는 원칙적으로 개인정보를 외부에 제공하지 않습니다. 다만, 법령에 따른 예외 사유에 해당할 경우에는 이용자의 동의를 받아 제공할 수 있습니다.</p>

    <h5>제4조 (개인정보처리 위탁)</h5>
    <p>Succubuddy는 원활한 서비스 제공을 위하여 일부 업무를 외부에 위탁할 수 있으며, 위탁 시에는 관련 법령에 따라 수탁자에 대한 관리·감독을 철저히 합니다.<br>
    위탁 내용 변경 시 본 방침을 통해 공개합니다.</p>

    <h5>제5조 (이용자 및 법정대리인의 권리와 행사 방법)</h5>
    <p>① 이용자는 언제든지 자신의 개인정보에 대해 열람, 정정, 삭제, 처리정지를 요구할 수 있습니다.</p>
    <p>② 이러한 요구는 서면, 이메일 등을 통해 가능하며, Succubuddy는 지체 없이 조치합니다.</p>
    <p>③ 법정대리인을 통한 요청 시 위임장을 제출해야 합니다.</p>
    <p>④ 정정·삭제 요청이 불가능한 경우는 법령에 따라 수집된 개인정보에 해당될 수 있습니다.</p>

	<h5>제6조 (처리하는 개인정보 항목)</h5>
    <p>필수항목: 이름, 아이디, 비밀번호, 주소, 전화, 휴대전화, 이메일, 성별, 생년월일<br>
    자동 수집 항목: 접속 로그, 쿠키, IP, 디바이스 정보, 광고 ID, UUID 등</p>

    <h5>제7조 (개인정보의 파기)</h5>
    <p>① 개인정보가 불필요하게 된 경우 지체 없이 파기합니다.</p>
    <p>② 전자적 파일은 복구가 불가능한 방법으로, 출력물은 분쇄 또는 소각 방식으로 파기합니다.</p>

    <h5>제8조 (개인정보의 안전성 확보 조치)</h5>
    <p>접근 권한 최소화 및 내부 점검<br>
    해킹 방지를 위한 기술적 보호<br>
    물리적 보안 및 접근통제 시스템 운영</p>

    <h5>제9조 (쿠키의 사용 및 거부)</h5>
    <p>① 사용자 맞춤형 서비스를 제공하기 위해 쿠키를 사용할 수 있습니다.</p>
    <p>② 사용자는 웹 브라우저 설정을 통해 쿠키 저장을 거부할 수 있으며, 이 경우 일부 서비스 이용이 어려울 수 있습니다.</p>

    <h5>제10조 (개인정보 보호책임자)</h5>
    <p>개인정보 보호책임자: 김수진<br>
    이메일: kim@succubuddy.com<br>
    문의사항 발생 시 해당 책임자에게 연락 주시기 바랍니다.</p>

	<h5>제11조 (개인정보 열람청구)</h5>
    <p>담당자: 김수진<br>
    이메일: kim@succubuddy.com</p>

    <h5>제12조 (권익침해 구제방법)</h5>
    <p>정보주체는 아래 기관에 개인정보 침해에 대한 피해구제, 상담 등을 요청할 수 있습니다.<br>
    개인정보분쟁조정위원회: 1833-6972<br>
    개인정보침해신고센터: 118<br>
    대검찰청: 1301<br>
    경찰청 사이버수사국: 182</p>

    <h5>제13조 (개인정보 처리방침 변경)</h5>
    <p>본 개인정보 처리방침은 2025년 5월 27일부터 적용됩니다. 변경사항은 홈페이지 공지를 통해 안내됩니다.</p>

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
