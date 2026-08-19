<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    request.setCharacterEncoding("euc-kr");

    String inquiryId = request.getParameter("inquiry_id");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String userId = "", productId = "", subject = "", text = "", answer = "";

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR",
            "multi",
            "abcd"
        );

        String sql = "SELECT user_id, product_id, inquiry_subject, inquiry_text, manager_answer " +
                     "FROM inquiry WHERE inquiry_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(inquiryId));

        rs = pstmt.executeQuery();
        if (rs.next()) {
            userId = rs.getString("user_id");
            productId = rs.getString("product_id");
            subject = rs.getString("inquiry_subject");
            text = rs.getString("inquiry_text");
            answer = rs.getString("manager_answer") != null ? rs.getString("manager_answer") : "";
        }

        rs.close();
        pstmt.close();
        conn.close();

    } catch(Exception e) {
        e.printStackTrace();
    }
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
		table {
			width: 1440px;
			font-size: 18px;
			font-family: 'GmarketSansTTFLight';
			border-collapse: collapse;
			margin-top: 40px;
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
		  textarea {
			width: 100%;
			height: 300px;
			font-size: 24px;
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
<div class="title"><a href="manager_inquiry.jsp">문의관리</a> > 문의 답변 중</div>

<table>
	<form method="post" action="manager_inquiry_answer_save.jsp">
		<input type="hidden" name="inquiry_id" value="<%= inquiryId %>">

		<tr>
		  <td style="width: 60%; text-align: left;"><%= subject %></td>
		  <td style="width: 20%;"><%= userId %></td>
		  <td style="width: 20%;">상품번호 : <%= productId %></td>
		</tr>
		<tr>
		  <td colspan="3" style="text-align: left; height: 150px;"><%= text %></td>
		</tr>
		<tr>
		  <td colspan="3">
			<textarea name="manager_answer"><%= answer %></textarea>
		  </td>
		</tr>
		<tr>
		  <td colspan="3">
			<button type="submit" style="width: 200px; height: 50px; font-size: 20px; margin-top: 10px;">저장</button>
		  </td>
		</tr>
	</form>
</table>
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