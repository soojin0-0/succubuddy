<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.util.*, java.text.*" %>
<%
request.setCharacterEncoding("euc-kr");

String userId = (String) session.getAttribute("sid");
if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

String range = request.getParameter("range");
String sy = request.getParameter("sy");
String sm = request.getParameter("sm");
String ey = request.getParameter("ey");
String em = request.getParameter("em");

boolean hasDateRange = sy != null && sm != null && ey != null && em != null;
String startYear = sy;
String startMonth = sm;
String endYear = ey;
String endMonth = em;

// 페이지 기본 설정
int currentPage = 1;
int inquiriesPerPage = 4;
int startIndex = 0;
if (request.getParameter("page") != null) {
	currentPage = Integer.parseInt(request.getParameter("page"));
}
startIndex = (currentPage - 1) * inquiriesPerPage;

int totalInquiries = 0;
int totalPages = 0;

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String errorMessage = null;

try {
	Class.forName("org.gjt.mm.mysql.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

	// 전체 문의 수 조회 (날짜 조건 포함)
	String countSql = "SELECT COUNT(*) FROM inquiry WHERE user_id = ?";
	if (hasDateRange) {
		countSql += " AND inquiry_ymd BETWEEN ? AND ?";
	}
	pstmt = conn.prepareStatement(countSql);
	int paramIndex = 1;
	pstmt.setString(paramIndex++, userId);
	if (hasDateRange) {
		pstmt.setString(paramIndex++, startYear + "-" + startMonth + "-01");
		pstmt.setString(paramIndex++, endYear + "-" + endMonth + "-31");
	}
	rs = pstmt.executeQuery();
	if (rs.next()) {
		totalInquiries = rs.getInt(1);
	}
	totalPages = (int) Math.ceil((double) totalInquiries / inquiriesPerPage);
	rs.close();
	pstmt.close();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이문의</title>
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
         padding: 40px 150px;
         width: 100%;
         margin: 0 auto;
         margin-bottom: 20px; /* 네비게이션 아래 여백 추가 */
		 position: fixed;
		 top: 0;
		 left: 0;
		 z-index: 999;

		/* 반투명 배경 + 블러 처리 */
		  background-color: rgba(255, 255, 255, 1); /* 반투명 흰색 */
		  backdrop-filter: blur(); /* 뒷배경 블러 효과 */
		  -webkit-backdrop-filter: blur(8px); /* 사파리 대응 */
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
			margin-top: 80px;
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
			margin-top: 200px;
		}

		.title td {
			border: none;
			border-bottom: 2px solid #000;
			padding-left: 5px;
			padding-bottom: 10px;
		}

		
		.container2 {
			width: 1440px;
			height: 410px;
			margin-top: 40px;
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
			width: 900px;
		}
		.hidtory td:nth-child(3) {
			width: 150px;
			text-align: center;
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
		/*조회 디자인*/
		.period-wrapper {
			width: 1400px;
			height: 253px;
			margin: 97px auto 0 auto;
			border: 2px solid #e0e0e0;
			border-radius: 6px;
			display: flex;
			background-color: #fff;
			overflow: hidden;

		}

		.period-form-content {
			flex: 1;
			padding: 25px;
			display: flex;
			flex-direction: column;
			justify-content: center;
			gap: 20px;
		}

		.period-form {
			display: flex;
			flex-direction: column;
			gap: 20px;
			margin-left: 87px;
		}

		.period-options {
			display: flex;
			gap: 30px;
		}

		.period-btn {
			width: 144px;
			height: 41px;
			font-size: 22px;
			padding: 0;
			border: none;
			border-radius: 4px;
			background-color: #f3f3f3;
			color: #555;
			cursor: pointer;
			font-family: 'GmarketSansTTFMedium';
			text-align: center;
			line-height: 50px;
			margin-bottom: 53px; 
		}

		.period-btn.active {
			background-color: #7ab863;
			color: #fff;
		}

		.period-range {
			display: flex;
			align-items: center;
			gap: 32px;
		}

		.period-range select {
			width: 154px;
			height: 41px;
			background-color: #f3f3f3;
			border: none;
			border-radius: 6px;
			padding: 0 12px;
			font-size: 22px;
			color: #333;
			cursor: pointer;

			/* 화살표 커스텀 */
			appearance: none;
			-webkit-appearance: none;
			-moz-appearance: none;
			background-image: url('images/arrow-big.png');  /* 큰 화살표 아이콘 */
			background-repeat: no-repeat;
			background-position: right 10px center;
			background-size: 20px 10px;  /*  이 부분으로 화살표 크기 조절 */
		}

		.period-range span {
			font-size: 22px;
			color: #333;
			font-family: 'GmarketSansTTFMedium';
			margin-left: -25px;
		}
		.date-divider {
			width: 32px;
			height: 2px;
			background-color: #333;
			margin: 0 8px;
			align-self: center;
		}

		.period-search-btn {
			width: 197px;
			height: 253px;
			background-color: #7ab863;
			color: white;
			border: none;
			font-size: 34px;
			cursor: pointer;
			border-radius: 0;
			font-family: 'GmarketSansTTFMedium';
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

<center>
	<table class="title">
		<tr><td>문의</td></tr>
	</table>

<script>
function submitRange(month) {
    const currentUrl = new URL(window.location.href);
    const currentRange = currentUrl.searchParams.get("range");

    // 같은 버튼을 다시 누른 경우 → range 제거
    if (currentRange === String(month)) {
        currentUrl.searchParams.delete("range");
    } else {
        currentUrl.searchParams.set("range", month);
    }

    // 드롭다운 값이 있으면 같이 유지
    ["sy", "sm", "ey", "em"].forEach(param => {
        const el = document.querySelector(`select[name="${param}"]`);
        if (el) currentUrl.searchParams.set(param, el.value);
    });

    window.location.href = currentUrl.toString();
}
</script>

<div class="period-wrapper">
    <!-- 왼쪽: 기간 버튼 + 날짜 선택 -->
    <div class="period-form-content">
    <form method="get" class="period-form">
        <div class="period-options">
            <button type="button" onclick="submitRange(1)" class="period-btn <%= "1".equals(range) ? "active" : "" %>">1개월</button>
            <button type="button" onclick="submitRange(3)" class="period-btn <%= "3".equals(range) ? "active" : "" %>">3개월</button>
            <button type="button" onclick="submitRange(6)" class="period-btn <%= "6".equals(range) ? "active" : "" %>">6개월</button>
            <button type="button" onclick="submitRange(12)" class="period-btn <%= "12".equals(range) ? "active" : "" %>">12개월</button>
        </div>

        <div class="period-range">
            <!-- select들 -->
            <select name="sy">
                <% for (int y = 2020; y <= Calendar.getInstance().get(Calendar.YEAR); y++) { %>
                    <option value="<%= y %>" <%= ("" + y).equals(sy) ? "selected" : "" %>><%= y %></option>
                <% } %>
            </select>
            <span>년</span>
            <select name="sm">
                <% for (int m = 1; m <= 12; m++) { %>
                    <option value="<%= m %>" <%= ("" + m).equals(sm) ? "selected" : "" %>><%= m %></option>
                <% } %>
            </select>
            <span>월</span>

            <div class="date-divider"></div> <!-- 여기 선 들어감 -->

            <select name="ey">
                <% for (int y = 2020; y <= Calendar.getInstance().get(Calendar.YEAR); y++) { %>
                    <option value="<%= y %>" <%= ("" + y).equals(ey) ? "selected" : "" %>><%= y %></option>
                <% } %>
            </select>
            <span>년</span>
            <select name="em">
                <% for (int m = 1; m <= 12; m++) { %>
                    <option value="<%= m %>" <%= ("" + m).equals(em) ? "selected" : "" %>><%= m %></option>
                <% } %>
            </select>
            <span>월</span>
        </div>
    </form>
    </div>

    <!-- 오른쪽: 조회 버튼 -->
    <form method="get">
        <button type="submit" class="period-search-btn">조회</button>
    </form>
</div>

<!-- 테이블 출력 -->
<div class="container2">
	<table class="history">
		<tr class="medium">
			<td>일자</td>
			<td>제목</td>
			<td>상태</td>
		</tr>

<%
	// 문의 목록 조회
	String sql = "SELECT inquiry_id, inquiry_subject, DATE_FORMAT(inquiry_ymd, '%Y-%m-%d') AS inquiry_date, status " +
		"FROM inquiry WHERE user_id = ?";
	if (hasDateRange) {
		sql += " AND inquiry_ymd BETWEEN ? AND ?";
	}
	sql += " ORDER BY inquiry_ymd DESC LIMIT ?, ?";
	pstmt = conn.prepareStatement(sql);
	paramIndex = 1;
	pstmt.setString(paramIndex++, userId);
	if (hasDateRange) {
		pstmt.setString(paramIndex++, startYear + "-" + startMonth + "-01");
		pstmt.setString(paramIndex++, endYear + "-" + endMonth + "-31");
	}
	pstmt.setInt(paramIndex++, startIndex);
	pstmt.setInt(paramIndex++, inquiriesPerPage);
	rs = pstmt.executeQuery();

	if (rs.next()) {
		do {
			String subject = rs.getString("inquiry_subject");
			String date = rs.getString("inquiry_date");
			String status = rs.getString("status");
%>
	<tr>
		<td style="white-space: nowrap;"><%= date %></td>
		<td>
		  <a href="myInquiryDetail.jsp?inquiry_id=<%= rs.getInt("inquiry_id") %>">
			<div style="max-width: 800px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-align: center; margin: 0 auto;">
			  <%= subject %>
			</div>
		  </a>
		</td>
		<td>
			<% if ("답변대기".equals(status)) { %>
				<span style="color: #f4a900; font-weight: bold;">답변대기</span>
			<% } else { %>
				<span style="color: #60af46; font-weight: bold;">답변완료</span>
			<% } %>
		</td>
	</tr>
<%
		} while (rs.next());
	} else {
%>
	<tr>
		<td colspan="3" style="text-align: center; background-color: #60af46; color: #000;">작성한 문의가 없습니다.</td>
	</tr>
<%
	}
} catch (Exception e) {
	errorMessage = e.getMessage();
} finally {
	try { if (rs != null) rs.close(); } catch (Exception e) {}
	try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>
	</table>
</div>

<% if (errorMessage != null) { %>
	<div style="color: red; text-align: center;">오류 발생: <%= errorMessage %></div>
<% } %>

<!-- 페이지네이션 -->
<div class="pagination" style="text-align:center; margin-top:30px;">
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