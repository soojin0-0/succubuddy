<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이리뷰</title>
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

		/*푸터*/
       .footer {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 1920px;
            height: 283px;
            padding: 0 150px; /* 왼쪽과 오른쪽 패딩 조정 */
            background-color: #60af46;
			margin-top: 50px;
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

		/* 포인트 */
		.title {
			font-size: 28px;
			width: 1200px;
			height: 70px;
			margin-bottom: 40px;
			font-family: 'GmarketSansTTFMedium';
		}

		.title td {
			border: none;
			border-bottom: 2px solid #000;
			padding-left: 5px;
			padding-bottom: 10px;
		}

		/* 조회 폼 */
		.container {
            width: 1100px;
            display: flex;
            align-items: center;
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
			margin-bottom: 70px;
        }
        .content {
            flex-grow: 1;
            padding: 20px;
        }
        .options {
            display: flex;
            gap: 10px;
            justify-content: flex-start;
            margin-bottom: 20px;
        }
        .option-btn {
			width: 140px;
			height: 40px;
			font-size: 18px;
            border: none;
            border-radius: 5px;
            background-color: #f2f2f2;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
			margin-right: 20px;
			font-family: 'GmarketSansTTFLight';
        }
		.date-range span {
			font-family: 'GmarketSansTTFLight';
		}
        .option-btn.active {
            background-color: #7ab863;
            color: white;
        }
        .date-range {
            display: flex;
            gap: 20px;
			align-items: center;
        }
		.date-group {
            display: flex;
            align-items: center;
            gap: 5px;
			font-size: 18px;
        }
		#yearStart, #yearEnd {
			width: 90px;
			height: 40px;
			font-family: 'GmarketSansTTFLight';
		}
		#monthStart, #monthEnd {
			width: 70px;
			height: 40px;
			font-family: 'GmarketSansTTFLight';
		}
        select {
            padding: 10px;
            border: none;
			background-color: #f2f2f2;
            border-radius: 5px;
			font-size: 18px;
        }
        .query-btn {
            width: 200px;
            height: 220px;
            background-color: #7ab863;
            color: white;
            border: none;
            font-size: 24px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            border-top-right-radius: 10px;
            border-bottom-right-radius: 10px;
			font-family: 'GmarketSansTTFMedium';
        }
		.container2 {
			width: 1440px;
			height: 410px;
		}
		.history {
			width: 1200px;
			border-collapse: collapse; /* 테두리 겹침 방지 */
			font-family: 'GmarketSansTTFLight';
			font-size: 24px;
		}
		.history td {
			text-align: center;
			border-bottom: 1px solid #000;
			height: 80px;
		}
		.history td:first-child {
			width: 150px;
		}
		.history td:nth-child(2) {
			width: auto;
		}
		.medium {
			font-family: 'GmarketSansTTFMedium';
		}
		/* 페이지네이션 */
        .pagination {
            display: flex;
            justify-content: center;
			text-align: center;
            gap: 10px;
			font-size: 24px;
			font-family: 'GmarketSansTTFLight';
        }

		.pagination a {
            padding: 8px 15px;
            color: black;
            font-size: 24px;
			margin-bottom: 109px;

			display: inline-block;
			width: 40px;
			height: 40px;
			line-height: 26px;
			text-align: center;
			border-radius: 50%;
			transition: 0.3s ease-in-out; /* 부드러운 효과 */
        }
		.pagination a.active {
			font-weight: bold;
			background-color: #7ab863;
			color: white;
			border: 1px solid #7ab863;
		}

		/* 이전, 다음 버튼 */
		.pagination a:hover {
			background-color: #ddd;
			border-color: #999;
			transform: scale(1.1);
		}
		.pagination a.disabled {
			pointer-events: none;
			color: #ccc;
			border: none;
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

<center>
	<table class="title">
		<tr><td>리뷰</td></tr>
	</table>

<script>
        function selectOption(button) {
            document.querySelectorAll('.option-btn').forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
        }

        function populateSelect(id, start, end) {
            let select = document.getElementById(id);
            select.innerHTML = "";
            for (let i = start; i <= end; i++) {
                let option = document.createElement("option");
                option.value = i;
                option.text = i;
                select.appendChild(option);
            }
        }

        function validateDate() {
            const yearStart = document.getElementById('yearStart').value;
            const monthStart = document.getElementById('monthStart').value;
            const yearEnd = document.getElementById('yearEnd').value;
            const monthEnd = document.getElementById('monthEnd').value;
            
            const startDate = new Date(yearStart, monthStart - 1, 1);
            const endDate = new Date(yearEnd, monthEnd - 1, 1);
        }

        window.onload = function() {
            populateSelect("yearStart", 2023, 2025);
            populateSelect("yearEnd", 2023, 2025);
            populateSelect("monthStart", 1, 12);
            populateSelect("monthEnd", 1, 12);
        };
    </script>

	<div class="container">
        <div class="content">
            <div class="options">
                <button class="option-btn active" onclick="selectOption(this)">1개월</button>
                <button class="option-btn" onclick="selectOption(this)">3개월</button>
                <button class="option-btn" onclick="selectOption(this)">6개월</button>
                <button class="option-btn" onclick="selectOption(this)">12개월</button>
            </div>
            <div class="date-range">
                <div class="date-group">
                    <select id="yearStart"></select>
                    <span>년</span>
                </div>
                <div class="date-group">
                    <select id="monthStart"></select>
                    <span>월</span>
                </div>
                <span> - </span>
                <div class="date-group">
                    <select id="yearEnd"></select>
                    <span>년</span>
                </div>
                <div class="date-group">
                    <select id="monthEnd"></select>
                    <span>월</span>
                </div>
            </div>
        </div>
        <button class="query-btn" onclick="validateDate()">조회</button>
    </div>

<%
	request.setCharacterEncoding("euc-kr");
	String userId = (String) session.getAttribute("sid");

	if (userId == null) {
		response.sendRedirect("login.jsp");
		return;
	}

	int currentPage = 1;
	int reviewsPerPage = 4;

	if (request.getParameter("page") != null) {
		currentPage = Integer.parseInt(request.getParameter("page"));
	}

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int totalReviews = 0;
	int totalPages = 0;
%>

<div class="container2">
	<table class="history">
		<tr class="medium">
			<td>일자</td>
			<td>내용</td>
		</tr>

<%
	try {
		Class.forName("org.gjt.mm.mysql.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

		// 전체 리뷰 수 계산
		String countSql = "SELECT COUNT(*) FROM review WHERE user_id = ?";
		pstmt = conn.prepareStatement(countSql);
		pstmt.setString(1, userId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			totalReviews = rs.getInt(1);
		}
		totalPages = (int) Math.ceil((double) totalReviews / reviewsPerPage);

		rs.close();
		pstmt.close();

		// 페이징된 리뷰 조회
		int startIndex = (currentPage - 1) * reviewsPerPage;

		String sql = "SELECT review_id, review_text, DATE_FORMAT(review_ymd, '%Y-%m-%d') AS review_date FROM review WHERE user_id = ? ORDER BY review_ymd DESC LIMIT ?, ?";

		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, userId);
		pstmt.setInt(2, startIndex);
		pstmt.setInt(3, reviewsPerPage);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			do {
				String text = rs.getString("review_text");
				String date = rs.getString("review_date");
%>
			<tr>
				<td style="white-space: nowrap;"><%= date %></td>
				<td>
				  <a href="myReviewDetail.jsp?review_id=<%= rs.getInt("review_id") %>">
					<div style="max-width: 800px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-align: center; margin: 0 auto;">
					  <%= text %>
					</div>
				  </a>
				</td>
			</tr>
<%
			} while (rs.next());
		} else {
%>
			<tr>
				<td colspan="2" style="text-align: center; background-color: #60af46; color: #000;">작성한 리뷰가 없습니다.</td>
			</tr>
<%
		}

	} catch (Exception e) {
%>
		<tr>
			<td colspan="2" style="color: red;">리뷰를 불러오는 중 오류 발생: <%= e.getMessage() %></td>
		</tr>
<%
	} finally {
		try { if (rs != null) rs.close(); } catch (Exception e) {}
		try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
		try { if (conn != null) conn.close(); } catch (Exception e) {}
	}
%>
	</table>
</div>

<!-- 페이지네이션 -->
<div class="pagination" style="text-align:center; margin-top:30px;">
	<!-- 항상 < 표시 -->
	<%
		if (currentPage == 1) {
	%>
		<a class="disabled">&lt;</a>
	<%
		} else {
	%>
		<a href="myInquiry.jsp?page=<%= currentPage - 1 %>">&lt;</a>
	<%
		}

		for (int i = 1; i <= totalPages; i++) {
			if (i == currentPage) {
	%>
		<a href="myInquiry.jsp?page=<%= i %>" class="active"><b><%= i %></b></a>
	<%
			} else {
	%>
		<a href="myInquiry.jsp?page=<%= i %>"><%= i %></a>
	<%
			}
		}

		if (currentPage == totalPages || totalPages == 0) {
	%>
		<a class="disabled">&gt;</a>
	<%
		} else {
	%>
		<a href="myInquiry.jsp?page=<%= currentPage + 1 %>">&gt;</a>
	<%
		}
	%>
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