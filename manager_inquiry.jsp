<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder" %>
<%
    request.setCharacterEncoding("euc-kr");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    int currentPage = 1;
    int recordsPerPage = 6;
    int totalRecords = 0;
    int totalPages = 0;

    String keyword = request.getParameter("keyword");
    boolean hasKeyword = (keyword != null && !keyword.trim().equals(""));

    String pageParam = request.getParameter("page");
    if (pageParam != null && pageParam.matches("\\d+")) {
        currentPage = Integer.parseInt(pageParam);
    }

    int startIndex = (currentPage - 1) * recordsPerPage;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR",
            "multi",
            "abcd"
        );

        // 1) 전체 문의 수 조회 (검색 적용)
		String countSql = "SELECT COUNT(*) FROM inquiry";
		if (hasKeyword) {
			countSql += " WHERE user_id LIKE ? OR inquiry_subject LIKE ?";
		}

		pstmt = conn.prepareStatement(countSql);

		if (hasKeyword) {
			pstmt.setString(1, "%" + keyword + "%");
			pstmt.setString(2, "%" + keyword + "%");
		}

		rs = pstmt.executeQuery();
		if (rs.next()) {
			totalRecords = rs.getInt(1);
		}
		rs.close();
		pstmt.close();

		totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

		// 2) 문의 조회 (검색 적용 + 페이징)
		String sql = "SELECT inquiry_id, user_id, product_id, inquiry_subject, inquiry_text, inquiry_ymd, inquiry_pswd, status, manager_answer " +
					 "FROM inquiry";
		if (hasKeyword) {
			sql += " WHERE user_id LIKE ? OR inquiry_subject LIKE ?";
		}
		sql += " ORDER BY inquiry_id DESC LIMIT ?, ?";

		pstmt = conn.prepareStatement(sql);

		if (hasKeyword) {
			pstmt.setString(1, "%" + keyword + "%");
			pstmt.setString(2, "%" + keyword + "%");
			pstmt.setInt(3, startIndex);
			pstmt.setInt(4, recordsPerPage);
		} else {
			pstmt.setInt(1, startIndex);
			pstmt.setInt(2, recordsPerPage);
		}

		rs = pstmt.executeQuery();

%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자모드</title>
    <style>
      a {
         text-decoration: none;
         color: inherit;  /* 상위 요소의 색상 그대로 */
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
            width: 100%;
            max-width: 1920px; /* 화면 크기에 맞춰 자동 조정 */
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

      /*푸터*/
       .footer {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 1920px;
            height: 283px;
            padding: 0 150px; /* 왼쪽과 오른쪽 패딩 조정 */
            background-color: #60af46;
         margin-top: 109px;
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
		.title {
			margin-top: 200px;
			width: 1100px;
			font-size: 32px;
			font-family: 'GmarketSansTTFMedium';
			text-align: left;
		}
		.search {
			position: relative;
			width: 600px;
			margin-bottom: 80px;
		}

		.search input{
			width: 100%;
			height: 74px;
			border: 1px solid #000;
			border-radius: 8px;
			margin-top: 60px;
			padding-right: 55px;
			padding-left: 15px;
			font-size: 18px;
			box-sizing: border-box;
			font-family: 'GmarketSansTTFLight';
		}

		.search img {
			position: absolute;
			right: 17px;
			top: 73%;
			transform: translateY(-50%);
			cursor: pointer;
		}
		table {
			width: 1440px;
			font-size: 18px;
			font-family: 'GmarketSansTTFLight';
			border-collapse: collapse;
		}
		table tr:nth-child(odd) {
			background-color: #eaffea; /* 연한 연두색 */
		  }
		  table tr:nth-child(even) {
			background-color: #ffffff; /* 흰색 */
		  }
		  table td {
			border: 1px solid #ccc;
			padding: 8px;
			text-align: center;
			height: 60px;
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
        font-size: 20px;
        margin-bottom: 109px;
        display: inline-block;
        width: 40px;
        height: 40px;
        line-height: 26px;
        text-align: center;
        border-radius: 50%;
        transition: 0.3s ease-in-out;
    }
    .pagination a.active {
        font-weight: bold;
        background-color: #7ab863;
        color: white;
        border: 1px solid #7ab863;
    }
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
	table button {
		width: 130px;
		height: 40px;
		border: none;
		border-radius: 8px;
		background-color: #f4a900;
		color: #fff;
		font-size: 18px;
		font-family: 'GmarketSansTTFLight';
		cursor: pointer;
	}
</style>
<script>
    function confirmDelete() {
        return confirm("이 문의를 정말로 지우시겠습니까?");
    }
</script>
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
<div class="title"><a href="manager_inquiry.jsp">문의관리</a></div>

<div class="search">
  <form method="get" action="manager_review.jsp">
    <input type="text" name="keyword" id="inquirySearchInput" placeholder="검색어를 입력하세요"
           value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
    <button type="submit" style="position: absolute; right: 17px; top: 73%; transform: translateY(-50%); background: none; border: none;">
      <img src="images/Search.png" alt="검색">
    </button>
  </form>
</div>

<table>
    <tr>
        <td>문희번호</td>
        <td>작성자 아이디</td>
        <td>상품번호</td>
        <td>제목</td>
        <td>문의내용</td>
        <td>작성날짜</td>
        <td>비밀번호</td>
		<td>답변상태</td>
		<td>관리자 답변</td>
		<td>삭제</td>
		<td>답변</td>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("inquiry_id") %></td>
        <td><%= rs.getString("user_id") %></td>
        <td><%= rs.getString("product_id") %></td>
		<td><%= rs.getString("inquiry_subject") %></td>
        <td><%= rs.getString("inquiry_text") %></td>
        <td><%= rs.getString("inquiry_ymd") %></td>
        <td><%= rs.getString("inquiry_pswd") %></td>
		<td>
		<%
			String status = rs.getString("status");
			String statusColor = "black";  // 기본값

			if ("답변대기".equals(status)) {
				statusColor = "#f4a900"; // 노란색
			} else if ("답변완료".equals(status)) {
				statusColor = "#7ab863"; // 초록색
			}
		%>
		<span style="color: <%= statusColor %>; font-weight: bold;"><%= status %></span>
		</td>
		<td><%= rs.getString("manager_answer") %></td>
		<td>
			<form method="post" action="manager_inquiry_delete.jsp" onsubmit="return confirmDelete();">
				<input type="hidden" name="inquiry_id" value="<%= rs.getInt("inquiry_id") %>">
				<button type="submit">삭제</button>
			</form>
		</td>
		<td>
			<form method="get" action="manager_inquiry_answer.jsp">
				<input type="hidden" name="inquiry_id" value="<%= rs.getInt("inquiry_id") %>">
				<button type="submit">답변</button>
			</form>
		</td>
    </tr>
<%
    }

    rs.close();
    pstmt.close();
    conn.close();

    } catch(Exception e) {
        e.printStackTrace();
    }
%>
</table>

<!-- 페이지네이션 -->
<div class="pagination" style="text-align:center; margin-top:30px;">
<%
    if (totalPages > 0) {
        if (currentPage == 1) {
%>
    <a class="disabled">&lt;</a>
<%
        } else {
%>
    <a href="manager_review.jsp?page=<%= currentPage - 1 %><%= hasKeyword ? "&keyword=" + URLEncoder.encode(keyword, "euc-kr") : "" %>">&lt;</a>
<%
        }

        for (int i = 1; i <= totalPages; i++) {
%>
    <a href="manager_review.jsp?page=<%= i %><%= hasKeyword ? "&keyword=" + URLEncoder.encode(keyword, "euc-kr") : "" %>"
       class="<%= (i == currentPage) ? "active" : "" %>"><b><%= i %></b></a>
<%
        }

        if (currentPage == totalPages) {
%>
    <a class="disabled">&gt;</a>
<%
        } else {
%>
    <a href="manager_review.jsp?page=<%= currentPage + 1 %><%= hasKeyword ? "&keyword=" + URLEncoder.encode(keyword, "euc-kr") : "" %>">&gt;</a>
<%
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
         <span><a href="footer_policy.jsp">개인정보처리방침</a> | <a href="footer_terms.jsp">이용약관</a></span>
      </div>
   </footer>

</body>
</html>