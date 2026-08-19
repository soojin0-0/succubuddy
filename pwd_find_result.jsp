<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.util.*" %>

<%
    request.setCharacterEncoding("euc-kr");

    String username = request.getParameter("username");
    String userid = request.getParameter("userid");
    String email = request.getParameter("email");

    String DB_URL = "jdbc:mysql://localhost:3306/succu";
    String DB_ID = "multi";
    String DB_PASSWORD = "abcd";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String userPwd = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        String sql = "SELECT password FROM user WHERE username = ? AND user_id = ? AND email = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, userid);
        pstmt.setString(3, email);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            userPwd = rs.getString("password");
        }
    } catch (Exception e) {
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }

    if (userPwd == null) {
        response.sendRedirect("pwd_find.jsp?error=1");
    } else {
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기 결과</title>

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
            margin: 0;
            width: 1920px;
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
  
        p {
            font-family: 'GmarketSansTTFLight';
        }

        h2 {
            font-family: 'GmarketSansTTFMedium';
			font-size: 32px;
            text-align: center;
            margin-bottom: 49px; /* 제목 아래 간격 증가 */
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

        .container {
            width: 600px;
            margin: 100px auto;
            text-align: center;
        }

         /* 설명 부분 */
        .result-description {
            font-size: 20px;
            margin-bottom: 75px;
            font-family: 'GmarketSansTTFLight';
        }
		/* 결과 부분 */
        .result-highlight {
            font-size: 32px;
            margin-bottom: 25px;
            font-family: 'GmarketSansTTFLight';
        }
        .highlight {
            color: #7ab863;
            font-weight: bold;
        }

        .btn-login {
            width: 566px;
            height: 61px;
            background-color: #7ab863;
            color: white;
            font-size: 24px;
            font-family: 'GmarketSansTTFMedium';
            border: none;
            border-radius: 8px;
            cursor: pointer;
            margin-top: 70px; /* 버튼 위 여백 증가 */
        }

        .btn-login:hover {
            background-color: #5a9b47;
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


    <div class="container">
        <h2>비밀번호 찾기 결과</h2>
        <p class="result-description">입력하신 정보와 일치하는 비밀번호는 다음과 같습니다.</p>
        <p class="result-highlight"><strong><%= username.substring(0, 1) + "*" %>님의 비밀번호는 <span class="highlight"><%= userPwd %></span>입니다</strong></p>

        <form action="login.jsp">
            <button type="submit" class="btn-login">로그인하기</button>
        </form>
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
            <span><a href="#">개인정보처리방침</a> | <a href="#">이용약관</a></span>
        </div>
    </footer>

</body>
</html>
<%
    }
%>
