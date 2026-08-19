<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>초보자</title>
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
			padding: 80px 130px;
			width: 1920px;
			margin: 0 auto;
			margin-bottom: 20px; /* 네비게이션 아래 여백 추가 */
		}

		.logo {
			display: block;
			width: 300px;
			height: 56px;
			margin-left: -10px;
			margin-right: 20px;
		}

		.nav-menu {
			display: flex;
			align-items: center;
			gap: 63px;
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

		/* 로그인 링크 스타일 */
		.nav-logout {
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

		/* 푸터 */
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
		
		/* 타이틀 */
		.title {
			margin-top: 60px;
			margin-bottom: 50px;
			font-size: 38px;
			font-family: 'GmarketSansTTFMedium';
		}
		.level {
			font-size: 28px;
			margin-bottom: 120px;
			font-family: 'GmarketSansTTFLight';
		}

		/* 상품 */
		.product-grid {
			display: flex;
			flex-wrap: wrap;
			gap: 45px;
			justify-content: flex-start;
			max-width: 1440px;
			margin: 0 auto;
			margin-bottom: 120px;
		}

		.product-card {
			width: calc(33.33% - 20px); /* 3등분 */
			max-width: 450px;
			text-align: left; /* 왼쪽 정렬 */
		}

		.product-card img { 
			width: 450px;
			height: 450px;
			object-fit: cover; /* 이미지 비율 유지 */
			display: block;
			margin-bottom: 10px;
		}

		.product-name, .product-price {
			text-align: left;
		}

		.product-name { 
			font-size: 28px;
			margin-top: 20px;
			margin-bottom: 12px;
			font-family: 'GmarketSansTTFMedium';
		}

		.product-price {
			font-size: 24px;
			margin-bottom: 30px;
			font-family: 'GmarketSansTTFLight';
		}
</style>
</head>
<body>
    <header class="navbar">
		<a href="main.jsp"><img src="images/logo.png" alt="SuccuBuddy Logo" class="logo"></a>
		<nav class="nav-menu">
			<a href="sub1.jsp">다육 박스</a>
			<a href="sub2.jsp">다육 하나</a>
			<a href="sub3.jsp">맞춤 다육 추천</a>
			<a href="sub4.jsp">이벤트 및 프로모션</a>
			<a href="sub5.jsp">고객센터</a>
		</nav>

<%
    String sid = (String) session.getAttribute("sid"); // 세션에서 ID 가져오기

    if (sid == null) { // 로그인되지 않았을 경우
%>
        <script>
            alert("[로그인이 필요합니다]");
            location.href = "login.jsp"; // 로그인 페이지로 이동
        </script>
<%
        return; // 아래 코드 실행 방지
    }
%>
<%
    String loggedInUser = (String) session.getAttribute("sid");
    if (loggedInUser != null) {
        out.println("<script>console.log('로그인된 유저 ID: " + loggedInUser + "');</script>");
    } else {
        out.println("<script>console.log('세션이 없음 (로그인 필요)');</script>");
    }
%>

		<div class="nav-icons">
			<a href="mypage.jsp"><img src="images/Person.png" alt="사용자"></a>
			<a href="shopping_list.jsp"><img src="images/Shopping Bag.png" alt="장바구니"></a>
			<a href="login.jsp" class="nav-logout">로그아웃</a> 
		</div>
	</header>

<center>
<div class="title">초보자</div>
<div class="level"><a href="sub1.jsp">다육 박스</a> &nbsp;&nbsp; <a href="Nonoob.jsp">중·상급자</a></div>

<div class="product-grid">
        <%
            // DB 연결 설정
            Connection conn = null;
            PreparedStatement psmt = null;
            ResultSet rs = null;
            String query = "SELECT id, name, price FROM succu_experience WHERE noob = 'O'";

            try {
                Class.forName("org.gjt.mm.mysql.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");
                psmt = conn.prepareStatement(query);
                rs = psmt.executeQuery();

                while (rs.next()) {
                    String product_id = rs.getString("id");
                    String product_name = rs.getString("name");
					int product_price = rs.getInt("price");

                    // 이미지 경로 자동 생성
                    String image_url = "images/" + product_id + ".jpg";
        %>
        <div class="product-card">
            <a href="productDetail.jsp?product_id=<%= product_id %>">
                <img src="<%= image_url %>" alt="<%= product_name %>">
            </a>
            <div class="product-name">
                <a href="productDetail.jsp?product_id=<%= product_id %>"><%= product_name %></a>
            </div>
			<div class="product-price">
            <a href="productDetail.jsp?product_id=<%= product_id %>"><%= String.format("%,d", product_price) %>원</a>
        </div>
        </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (psmt != null) psmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
</div>
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