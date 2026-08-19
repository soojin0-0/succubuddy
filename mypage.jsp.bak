<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
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
  
        p {
            font-family: 'GmarketSansTTFLight';
        }

        h2 {
            font-family: 'GmarketSansTTFBold';
        }

        h6 {
            font-family: 'GmarketSansTTFMedium';
        }

		/* 로그아웃 링크 스타일 */
		.nav-logout {
			text-decoration: none;
			font-size: 24px;
			font-family: 'GmarketSansTTFMedium';
			color: black;
			margin-top:10px;
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

	/* 마이페이지 */
	.mypage {
		width: 1100px;
		height: 278px;
		margin-top: 30px;
	}
	.title {
		font-size: 28px;
		width: 1100px;
		height: 70px;
		font-family: 'GmarketSansTTFMedium';
	}
	.title td {
		border: none;
		border-bottom: 2px solid #000;
		padding-left: 5px;
		padding-bottom: 10px;
	}
	.detail {
		float: left;
		margin-top: 24px;
		margin-left: 40px;
		margin-bottom: 50px;
		font-family: 'GmarketSansTTFMedium';
		white-space: nowrap; /* 줄바꿈 방지 */
	}
	.id {
		font-size: 40px;
		font-weight: bold;
		padding-bottom: 20px;
		padding-right: 105px;
	}
	.info {
		font-size: 28px;
	}
	.info a {
		color: #3a3a3a;
	}
	.detail2 {
		height: 230px;
		border-radius: 8px;
		padding-top: 10px;
		background-color: #f5f5f5;
		white-space: nowrap; /* 줄바꿈 방지 */
	}

	/* 주문/배송 조회 */
	.search {
		width: 1100px;
		margin-top: 64px;
		margin-bottom: 64px;
	}
	.title2 {
		width: 1100px;
		height: 70px;
		border-collapse: collapse;
		font-family: 'GmarketSansTTFMedium';
	}
	.title2 td {
		border: none;
		border-bottom: 2px solid #000;
		padding-left: 5px;
		padding-bottom: 10px;
	}
	.title2 td:nth-child(1) {
		width: 1100px;
		font-size: 28px;
	}
	.title2 td:nth-child(2) {
		width: 80px;
		font-size: 22px;
	}
	.delivery {
		margin-top: 24px;
		text-align: center;
		font-family: 'GmarketSansTTFMedium';
	}
	.delivery .status-count {
		font-size: 40px;
		transition: color 0.3s ease;
		color: black; /* 기본색 */
	}

	.delivery .green {
		color: #7ab863; /* 상태 있을 때 초록색 */
	}

	.delivery tr:nth-child(1) {
		font-size: 60px;
	}
	.delivery tr:first-child td {
		padding-bottom: 20px;
	}
	.delivery td:nth-child(1), .delivery td:nth-child(3), .delivery td:nth-child(5), .delivery td:nth-child(7), .delivery td:nth-child(9) {
		width: 120px;
	}
	.delivery td:nth-child(2), .delivery td:nth-child(4), .delivery td:nth-child(6), .delivery td:nth-child(8) {
		width: 60px;
	}
	.review {
		float: left;
		margin-bottom: 156px;
		margin-left: 399px;
		font-family: 'GmarketSansTTFMedium';
	}
	.review table {
		border-collapse: collapse;
		width: 510px;
	}
	.review td{
		border-bottom: 2px solid #000;
		height: 60px;
	}
	.inquiry {
		float: left;
		margin-left: 80px;
		font-family: 'GmarketSansTTFMedium';
	}
	.inquiry table {
		border-collapse: collapse;
		width: 510px;
	}
	.inquiry td{
		border-bottom: 2px solid #000;
		height: 60px;
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
			<a href="shopping_list.jsp"><img src="images/cart.png" alt="장바구니"></a>
			<a href="logout.jsp"><img src="images/logout.png" alt="로그아웃"></a> 
		</div>
	</header>

<%
    // userId 변수 선언
    String userId = (String) session.getAttribute("sid");

    // 로그인 체크
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 다른 변수들도 함께 선언 (try-catch 외부)
    String userName = "";
    int userCoupons = 0;
    int userPoints = 0;
    int userFavorites = 0;

    try {
        // DB 연결 정보
        String DB_URL = "jdbc:mysql://localhost:3306/succu";
        String DB_ID = "multi";
        String DB_PASSWORD = "abcd";

        Class.forName("org.gjt.mm.mysql.Driver");
        Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        // 회원 기본 정보 조회
        String sqlUser = "SELECT username FROM user WHERE user_id = ?";
        PreparedStatement pstmtUser = con.prepareStatement(sqlUser);
        pstmtUser.setString(1, userId); // userId 사용 가능
        ResultSet rsUser = pstmtUser.executeQuery();

        if (rsUser.next()) {
            userName = rsUser.getString("username");
        }
        rsUser.close();
        pstmtUser.close();

        // 보유 쿠폰 개수 조회
        String sqlCoupons = "SELECT COUNT(*) FROM coupon WHERE user_id = ?";
        PreparedStatement pstmtCoupons = con.prepareStatement(sqlCoupons);
        pstmtCoupons.setString(1, userId); // userId 사용 가능
        ResultSet rsCoupons = pstmtCoupons.executeQuery();

        if (rsCoupons.next()) {
            userCoupons = rsCoupons.getInt(1);
        }
        rsCoupons.close();
        pstmtCoupons.close();

        // 보유 포인트 조회
        String sqlPoints = "SELECT points FROM point WHERE user_id = ?";
        PreparedStatement pstmtPoints = con.prepareStatement(sqlPoints);
        pstmtPoints.setString(1, userId); // userId 사용 가능
        ResultSet rsPoints = pstmtPoints.executeQuery();

        if (rsPoints.next()) {
            userPoints = rsPoints.getInt("points");
        }
        rsPoints.close();
        pstmtPoints.close();

        // 관심상품 개수 조회
        String sqlFavorite = "SELECT COUNT(*) FROM favorite WHERE user_id = ?";
		PreparedStatement pstmtFavorite = con.prepareStatement(sqlFavorite);
		pstmtFavorite.setString(1, userId);
		ResultSet rsFavorite = pstmtFavorite.executeQuery();

		if (rsFavorite.next()) {
		userFavorites = rsFavorite.getInt(1);
		}
		rsFavorite.close();
		pstmtFavorite.close();

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류 발생: " + e.getMessage());
    }
%>
<center>
<!-- 마이페이지 -->
<div class="mypage">
	<table class="title">
		<tr>
			<td>마이페이지</td>
		</tr>
	</table>

	<table class="detail">
		<tr>
			<td rowspan="2">
				<img src="images/user.png" width="150" height="150" alt="프로필 이미지">
			</td>
			<td style="padding-left: 61px;">
				<p class="id"><%= userName %></p>
				<p class="info"><a href="mypage_info.jsp">회원정보 ></a></p>
			</td>
			<td>
				<table class="detail2">
					<tr>
						<td style="padding-left: 90px; font-size: 24px;"><a href="myCoupon.jsp">쿠폰</a></td>
						<td style="padding-left: 80px; font-size: 24px;"><a href="">포인트</a></td>
						<td style="padding-left: 80px; padding-right: 100px; font-size: 24px;"><a href="myFavorite.jsp">관심상품</a></td>
					</tr>
					<tr>
						<td style="padding-left: 93px; font-size: 28px;"><font style="font-size: 35px;"><b><a href="myCoupon.jsp" style="color: #7ab863"><%= userCoupons %></b></a></font>개</td>
						<td style="padding-left: 93px; font-size: 28px;"><font style="color: #7ab863; font-size: 35px;"><b><%= userPoints %></b></font>P</td>
						<td style="padding-left: 102px; font-size: 28px;"><font style="color: #7ab863; font-size: 35px;"><b><%= userFavorites %></b></font>개</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>

<!-- 주문/배송 조회 -->
<%
    int 주문접수 = 0, 결제완료 = 0, 배송준비중 = 0, 배송중 = 0, 배송완료 = 0;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR",
            "multi", "abcd"
        );

        //  order_detail 기준 상태별 주문 수 조회
        String sql = "SELECT od.status, COUNT(*) AS cnt " +
                     "FROM order_detail od " +
                     "JOIN orders o ON od.order_id = o.order_id " +
                     "WHERE o.user_id = ? " +
                     "GROUP BY od.status";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId); // 현재 로그인된 사용자 ID
        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            String status = rs.getString("status");
            int count = rs.getInt("cnt");

            switch (status) {
                case "주문접수": 주문접수 = count; break;
                case "결제완료": 결제완료 = count; break;
                case "배송준비중": 배송준비중 = count; break;
                case "배송중": 배송중 = count; break;
                case "배송완료": 배송완료 = count; break;
            }
        }

        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<script>
    console.log("주문 상태별: 주문접수: <%= 주문접수 %>, 결제완료: <%= 결제완료 %>, 배송준비중: <%= 배송준비중 %>, 배송중: <%= 배송중 %>, 배송완료: <%= 배송완료 %>");
</script>
<div class="search">
	<table class="title2">
		<tr>
			<td>주문/배송 조회</td>
			<td><a href="my_order_tracking.jsp">더보기</a></td>

		</tr>
	</table>

	<!-- 숫자 반영 -->
	<table class="delivery">
		<tr>
			<td class="status-count <%= 주문접수 > 0 ? "green" : "" %>"><%= 주문접수 %></td>
			<td style="font-size: 40px;">></td>
			<td class="status-count <%= 결제완료 > 0 ? "green" : "" %>"><%= 결제완료 %></td>
			<td style="font-size: 40px;">></td>
			<td class="status-count <%= 배송준비중 > 0 ? "green" : "" %>"><%= 배송준비중 %></td>
			<td style="font-size: 40px;">></td>
			<td class="status-count <%= 배송중 > 0 ? "green" : "" %>"><%= 배송중 %></td>
			<td style="font-size: 40px;">></td>
			<td class="status-count <%= 배송완료 > 0 ? "green" : "" %>"><%= 배송완료 %></td>
		</tr>
		<tr>
			<td style="font-size: 18px;">주문접수</td>
			<td></td>
			<td style="font-size: 18px;">결제완료</td>
			<td></td>
			<td style="font-size: 18px;">배송준비중</td>
			<td></td>
			<td style="font-size: 18px;">배송중</td>
			<td></td>
			<td style="font-size: 18px;">배송완료</td>
		</tr>
	</table>


</div>

<!-- 리뷰 -->
<div class="review">
    <table>
        <tr>
            <td style="width: 535px; font-size: 28px;">리뷰</td>
            <td style="width: 80px; font-size: 18px; text-align: right; padding-right: 10px;"><a href="myReview.jsp">더보기</a></td>
        </tr>

<%
    // 리뷰 조회용 DB 연결
    Connection conReview = null;
    PreparedStatement pstmtReview = null;
    ResultSet rsReview = null;

    try {
        // DB 연결 정보
        String DB_URL = "jdbc:mysql://localhost:3306/succu";
        String DB_ID = "multi";
        String DB_PASSWORD = "abcd";

        Class.forName("org.gjt.mm.mysql.Driver");
        conReview = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        // 사용자가 작성한 최신 리뷰 4개 조회 (날짜 형식 변환)
        String sqlReview = "SELECT review_text, DATE_FORMAT(review_ymd, '%Y-%m-%d') AS review_date FROM review WHERE user_id = ? ORDER BY review_ymd DESC LIMIT 4";
        pstmtReview = conReview.prepareStatement(sqlReview);
        pstmtReview.setString(1, userId);
        rsReview = pstmtReview.executeQuery();

        if (!rsReview.isBeforeFirst()) { // 리뷰가 없을 경우
%>
        <tr>
            <td colspan="2" style="text-align: center; font-size: 18px;">작성한 리뷰가 없습니다.</td>
        </tr>
<%
        }

        while (rsReview.next()) {
            String content = rsReview.getString("review_text");
            String date = rsReview.getString("review_date"); // 변환된 날짜 가져오기
%>
        <tr>
            <td style="padding-left: 20px; font-size: 18px; font-family: 'GmarketSansTTFLight';">
				<div style="max-width: 340px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
					<%= content %>
				</div>
			</td>
			<td style="font-size: 18px; font-family: 'GmarketSansTTFLight'; width: 160px; text-align: right; padding-right: 20px; white-space: nowrap;">
				<%= date %>
			</td>

        </tr>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<tr><td colspan='2' style='color: red;'>리뷰를 불러오는 중 오류 발생: " + e.getMessage() + "</td></tr>");
    } finally {
        // 리소스 닫기
        try {
            if (rsReview != null) rsReview.close();
            if (pstmtReview != null) pstmtReview.close();
            if (conReview != null) conReview.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
    </table>
</div>


<!-- 문의 -->
<div class="inquiry">
    <table>
        <tr>
            <td style="width: 535px; font-size: 28px;">문의</td>
            <td style="width: 80px; font-size: 18px; text-align: right; padding-right: 10px;"><a href="myInquiry.jsp">더보기</a></td>
        </tr>

<%
    // 문의 조회용 DB 연결
    Connection conInquiry = null;
    PreparedStatement pstmtInquiry = null;
    ResultSet rsInquiry = null;

    try {
        // DB 연결 정보
        String DB_URL = "jdbc:mysql://localhost:3306/succu";
        String DB_ID = "multi";
        String DB_PASSWORD = "abcd";

        Class.forName("org.gjt.mm.mysql.Driver");
        conInquiry = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        // 수정된 SQL (테이블명 및 컬럼명 정확하게 반영)
        String sqlInquiry = "SELECT inquiry_subject, DATE_FORMAT(inquiry_ymd, '%Y-%m-%d') AS inquiry_date FROM inquiry WHERE user_id = ? ORDER BY inquiry_ymd DESC LIMIT 4";
        pstmtInquiry = conInquiry.prepareStatement(sqlInquiry);
        pstmtInquiry.setString(1, userId);
        rsInquiry = pstmtInquiry.executeQuery();

        if (!rsInquiry.isBeforeFirst()) { // 문의가 없을 경우
%>
        <tr>
            <td colspan="2" style="text-align: center; font-size: 18px;">작성한 문의가 없습니다.</td>
        </tr>
<%
        }

        while (rsInquiry.next()) {
            String subject = rsInquiry.getString("inquiry_subject"); // 문의 제목 가져오기
            String date = rsInquiry.getString("inquiry_date"); // 변환된 날짜 가져오기
%>
        <tr>
			<td style="padding-left: 20px; font-size: 18px; font-family: 'GmarketSansTTFLight'; width: 400px;">
			  <div style="max-width: 340px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
				<%= subject %>
			  </div>
			</td>
			<td style="font-size: 18px; font-family: 'GmarketSansTTFLight'; width: 160px; text-align: right; padding-right: 20px; white-space: nowrap;">
			  <%= date %>
			</td>
        </tr>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<tr><td colspan='2' style='color: red;'>문의 데이터를 불러오는 중 오류 발생: " + e.getMessage() + "</td></tr>");
    } finally {
        // 리소스 닫기
        try {
            if (rsInquiry != null) rsInquiry.close();
            if (pstmtInquiry != null) pstmtInquiry.close();
            if (conInquiry != null) conInquiry.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
    </table>
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
