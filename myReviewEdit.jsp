<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이리뷰 수정</title>
    <style>
		a {
			text-decoration: none;
			color: black;
		}
        @font-face {
            font-family: 'GmarketSansTTFMedium';
            src: url('/fonts/GmarketSansTTFMedium.ttf') format('truetype');
        }
        
        @font-face {
            font-family: 'GmarketSansTTFBold';
            src: url('/fonts/GmarketSansTTFBold.ttf') format('truetype');
        }
        
        @font-face {
            font-family: 'GmarketSansTTFLight';
            src: url('/fonts/GmarketSansTTFLight.ttf') format('truetype');
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
			font-family: 'GmarketSansTTFMedium';
			margin-top: 200px;
			border-collapse: collapse; /* 테두리 겹침 방지 */
		}

		.title td {
			border: none;
			border-bottom: 2px solid #000;
			padding-left: 5px;
			padding-bottom: 10px;
		}
		.title td:nth-child(1), .title td:nth-child(3) {
			width: 150px;
		}
		.title td:nth-child(2) {
			text-align: center;
		}

		.container {
			width: 1200px;
			height: 800px;
			border-bottom: 2px solid #000;
			margin-bottom: 80px;
		}
		.detail1 table {
			width: 1100px;
			height: 130px;
			margin-left: 50px;
			margin-right: 50px;
			font-size: 28px;
			font-family: 'GmarketSansTTFMedium';
		}
		.detail1 td:nth-child(1) {
			width: 250px;
		}
		.detail1 td:nth-child(2) {
			text-align: right;
		}
		.detail2 {
			width: 1100px;
			height: 530px;
			margin-left: 50px;
			margin-right: 50px;
			background-color: #f5f5f5;
			text-align: left;
			padding: 20px;
			font-size: 24px;
			font-family: 'GmarketSansTTFMedium';
		}
		.detail2 textarea {
			background-color: #f5f5f5;
			border: none;
			font-size: 28px;
			font-family: 'GmarketSansTTFMedium';
		}
		.detail3 table {
			width: 1100px;
			height: 130px;
			margin-left: 50px;
			margin-right: 50px;
			font-size: 28px;
			font-family: 'GmarketSansTTFMedium';
		}
		.detail3 td:nth-child(1) {
			width: 120px;
		}
		.detail3 input {
			width: 125px;
			height: 40px;
			background-color: #f5f5f5;
			border-radius: 8px;
			border: none;
		}
		.btn button {
			width: 244px;
			height: 61px;
			border-radius: 8px;
			font-family: 'GmarketSansTTFMedium';
			font-size: 24px;
			margin-bottom: 80px;
			margin-left: 40px;
			margin-right: 40px;
		}
		#update {
			background-color: #7ab863;
			color: #fff;
			border: none;
		}
		#delete {
			background-color: #fff;
			color: #7ab863;
			border: 1px solid #7ab863;
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
        
<%
request.setCharacterEncoding("euc-kr");
int review_id = Integer.parseInt(request.getParameter("review_id"));

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String review_text = "";
int review_score = 0;
String review_ymd = "";
String product_id = "";
String product_name = "";

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

    String sql = "SELECT review_text, review_score, DATE_FORMAT(review_ymd, '%Y-%m-%d') AS review_date, product_id FROM review WHERE review_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, review_id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        review_text = rs.getString("review_text");
        review_score = rs.getInt("review_score");
        review_ymd = rs.getString("review_date");
		product_id = rs.getString("product_id");
    }

    rs.close();
    pstmt.close();

    // 2. product 테이블에서 상품 이름 조회
    String productSql = "SELECT name FROM product WHERE product_id = ?";
    pstmt = conn.prepareStatement(productSql);
    pstmt.setString(1, product_id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        product_name = rs.getString("name");
    }

} catch (Exception e) {
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>
<table class="title">
            <tr>
                <td>문의</td>
                <td><font style="color: #f4a900;"><%= product_name %></font> 상품에 대한 리뷰 수정입니다.</td>
                <td></td>
            </tr>
        </table>
<form method="post" action="reviewUpdate.jsp">
	<input type="hidden" name="review_id" value="<%= review_id %>">
	<input type="hidden" name="review_score" id="reviewScore" value="<%= review_score %>">

	<div class="container">
		<!-- 별점 영역 -->
		<div class="detail1">
			<table>
				<tr>
					<td>
						<div class="rating">
							<% for (int i = 1; i <= 5; i++) { %>
								<img src="images/<%= (i <= review_score) ? "stargreen.png" : "starnone.png" %>" 
									 width="40px" height="40px" 
									 class="star" data-value="<%= i %>">
							<% } %>
						</div>
					</td>
					<td><%= review_ymd %></td>
				</tr>
			</table>
		</div>

		<!-- 리뷰 텍스트 수정 영역 -->
		<div class="detail2">
			<textarea name="review_text" style="width:100%; height:100%; font-size:24px;"><%= review_text %></textarea>
		</div>

		<!-- 비밀번호 입력 -->
		<div class="detail3">
			<table>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="review_pswd" required></td>
				</tr>
			</table>
		</div>
	</div>

	<!-- 버튼 -->
	<div class="btn">
		<button type="submit" id="update">등록</button>
		<button type="button" id="delete" onclick="history.back()">취소</button>
	</div>
</form>

<script>
	const stars = document.querySelectorAll(".star");
	const scoreInput = document.getElementById("reviewScore");

	stars.forEach((star, index) => {
		star.addEventListener("click", function () {
			const score = index + 1;
			scoreInput.value = score;

			stars.forEach((s, i) => {
				s.src = i < score ? "images/stargreen.png" : "images/starnone.png";
			});
		});
	});
</script>
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