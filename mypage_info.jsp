<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지 회원정보</title>
<style>
	a {
			text-decoration: none;
			color: black;
		}
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
			font-family: 'RixInooAriDuriPro';  /* 폰트 이름 지정 */
			src: url('fonts/RixInooAriDuri_Pro Regular.otf')  format('opentype'); /* OTF 파일은 'opentype' 지정 */
			font-weight: normal;
			font-style: normal;
		}
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            width: 1920px;
            max-width: 100%; /* 화면 크기에 맞춰 자동 조정 */
            overflow-x: hidden;
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


      /* 로그인 링크 스타일 */
      .nav-login {
         text-decoration: none;
         font-size: 24px;
         font-family: 'GmarketSansTTFMedium';
         color: black;
         margin-top:10px;
      }
  
        p {
            font-family: 'GmarketSansTTFLight';
        }

        h2 {
            font-family: 'GmarketSansTTFBold';
        }

        h6 {
            font-family: 'GmarketSansTTFMedium';
        }

		/*푸터*/
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
            font-size: 50px;
            font-family: 'RixInooAriDuriPro'; /* Medium font 적용 */
            margin-left: 50px;
            color: #ffffff;
        }

        .footer-right {
            font-size: 18px;
            color: #ffffff;
            margin-left: 130px;
            font-family: 'GmarketSansTTFLight'; /* Light font 적용 */
        }

        .footer-right span {
            margin-bottom: 10px;
        }

        .footer-right a {
            text-decoration: none;
            color: #ffffff;
        }

		/* 회원정보 */
		.title td {
			width: 1100px;
			height: 69px;
			padding-top: 50px;
			padding-bottom: 39px;
			font-size: 34px;
			border-bottom: 1px solid #000;
			font-family: 'GmarketSansTTFMedium';
		}
		.MyInfo {
			width: 900px;
			font-size: 24px;
			border-collapse: collapse; /* 테두리 겹침 방지 */
			margin-top: 26px;
			margin-bottom: 55px;
			font-family: 'GmarketSansTTFMedium';
		}
		.MyInfo td {
			height: 66px;
			border-bottom: 1px solid #000;
			padding-left: 65px;
		}
		.MyInfo td:nth-child(1) {
			width: 219px;
		}
		.MyInfo td:nth-child(2) {
			padding-left: 46px;
		}

		/* 버튼 */
		.reset, .update {
			width: 244px;
			height: 61px;
			border-radius: 8px;
			cursor: pointer;
			font-size: 24px;
			margin-bottom: 105px;
			font-family: 'GmarketSansTTFMedium';
		}
		.reset {
			border:none;
			color: #fff;
			background-color: #7ab863;
		}
		.reset a {
			color: #fff;
		}
		.update {
			border: 1px solid #7ab863;
			color: #7ab863;
			background-color: #fff;
			margin-left: 99px;
		}
		.update a {
			color: #7ab863;
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
         <a href="logout.jsp"><img src="images/logout.png" alt="로그아웃"></a> 
      </div>
   </header>


<%
    String userId = (String) session.getAttribute("sid");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 사용자 정보 초기화
    String username = "";
    String password = "";
    String address = "";        // 주소 (우편번호, 도로명, 상세주소 포함)
    String phone = "";          // 집전화: 02-1234-5678
    String mobilePhone = "";    // 휴대전화: 010-9876-5432
    String email = "";          // 이메일
    String gender = "";         // 성별
    String birthDate = "";      // 생년월일 (YYYY-MM-DD)
	String level = "";

    try {
        String DB_URL = "jdbc:mysql://localhost:3306/succu";
        String DB_ID = "multi";
        String DB_PASSWORD = "abcd";

        Class.forName("org.gjt.mm.mysql.Driver");
        Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        // 테이블 컬럼명에 맞게 수정
        String sql = "SELECT username, password, address, phone, mobile_phone, email, gender, birth_date, level FROM user WHERE user_id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            username = rs.getString("username");
            password = rs.getString("password");
            address = rs.getString("address");            // 예: "12345,도로명주소,상세주소"
            phone = rs.getString("phone");                // 예: "02-1234-5678"
            mobilePhone = rs.getString("mobile_phone");   // 예: "010-9876-5432"
            email = rs.getString("email");                // 예: "example@domain.com"
            gender = rs.getString("gender");              // "남자" 또는 "여자"
            birthDate = rs.getString("birth_date");       // 예: "1990-01-01"
			level = rs.getString("level");
        }

        rs.close();
        pstmt.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류 발생: " + e.getMessage());
    }

    // 주소 분리 (예: "12345,도로명주소,상세주소")
    String[] addressParts = address != null ? address.split(",") : new String[]{"", "", ""};
    String postcode = addressParts.length > 0 ? addressParts[0] : "";
    String roadAddress = addressParts.length > 1 ? addressParts[1] : "";
    String detailAddress = addressParts.length > 2 ? addressParts[2] : "";

    // 전화번호 분리 (집전화)
    String[] phoneParts = phone != null ? phone.split("-") : new String[]{"", "", ""};
    String call1 = phoneParts.length > 0 ? phoneParts[0] : "";
    String call2 = phoneParts.length > 1 ? phoneParts[1] : "";
    String call3 = phoneParts.length > 2 ? phoneParts[2] : "";

    // 휴대전화 분리
    String[] mobileParts = mobilePhone != null ? mobilePhone.split("-") : new String[]{"", "", ""};
    String cell1 = mobileParts.length > 0 ? mobileParts[0] : "";
    String cell2 = mobileParts.length > 1 ? mobileParts[1] : "";
    String cell3 = mobileParts.length > 2 ? mobileParts[2] : "";

    // 이메일 분리
    String[] emailParts = email != null ? email.split("@") : new String[]{"", ""};
    String email_name = emailParts.length > 0 ? emailParts[0] : "";
    String domain = emailParts.length > 1 ? emailParts[1] : "";

    // 생년월일 분리
    String[] birthParts = birthDate != null ? birthDate.split("-") : new String[]{"", "", ""};
    String birthYear = birthParts.length > 0 ? birthParts[0] : "";
    String birthMonth = birthParts.length > 1 ? birthParts[1] : "";
    String birthDay = birthParts.length > 2 ? birthParts[2] : "";
%>

	<center>
	<table class="title" border=0>
		<tr>
			<td>회원정보</td>
		</tr>
	</table>
	<table class="MyInfo" border=0>
		<tr>
			<td>이름</td>
			<td><%= username %></td>
		</tr>
		<tr>
			<td>아이디</td>
			<td><%= userId %></td>
		</tr>
		<tr>
			<td>비밀번호</td>
			<td><%= password %></td>
		</tr>
		<tr>
			<td style="height: 210px;">주소</td>
			<td><div class="postcode">우편번호 : <%= postcode %></div><br>
				<div class="roadAdress">도로명 : <%= roadAddress %></div><br>
				<div class="detailAddress">상세주소 : <%= detailAddress %></div></td>
		</tr>
		<tr>
			<td>전화</td>
			<td><%= call1 %> - <%= call2 %> - <%= call3 %></td>
		</tr>
		<tr>
			<td>휴대전화</td>
			<td><%= cell1 %> - <%= cell2 %> - <%= cell3 %></td>
		</tr>
		<tr>
			<td>이메일</td>
			<td><%= email_name %> @ <%= domain %></td>
		</tr>
		<tr>
			<td>성별</td>
			<td><%= gender %></td>
		</tr>
		<tr>
			<td>생년월일</td>
			<td><%= birthYear %>년 <%= birthMonth %>월 <%= birthDay %>일</td>
		</tr>
		<tr>
			<td>키우기 난이도</td>
			<td><%= level %></td>
		</tr>
	</table>

	<button type="reset" class="reset" onclick="location.href='mypage.jsp'">취소</button>
	<button type="button" class="update" onclick="location.href='myInfoUpdate.jsp'">수정</button>
</center>

	<footer class="footer">
		<div class="footer-left">
			<span class="brand-name">succubuddy</span>
		</div>
		<div class="footer-right">
		<br>
			<span>주소 : 충청남도 천안시 서북구 성환읍 대학로 91 | EMAIL : succubuddy@naver.com</span>
			<span>TEL : 070-022-2026 | &copy; 2025 succubuddy. All Rights Reserved.</span>
			<br>
			<span><a href="#">개인정보처리방침</a> | <a href="#">이용약관</a></span>
		</div>
	</footer>
</body>
</html>