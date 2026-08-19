<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>다육하나-소형</title>
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

		/* 로그아웃 링크 스타일 */
		.nav-logout {
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


.header-wrap {
  text-align: center;
}

/* 타이틀 */
.title {
	margin-top: 60px;
	margin-bottom: 50px;
	font-size: 38px;
	font-family: 'GmarketSansTTFMedium';
	text-align: center;
}

.title a {
  display: block;
  text-align: center;
}

/* 카테고리 */
.level {
  height: 80px;
  display: flex;             /* 가로 정렬을 위한 flexbox */
  justify-content: center;   /* 가운데 정렬 */
  align-items: center;       /* 수직 정렬 */
  gap: 12px;                 /* 항목 간 간격 */
  font-size: 30px;
  font-family: 'GmarketSansTTFLight';
}

.level a {
  display: inline-block;
  width: 75px;
  height: 75px;
  line-height: 80px;
  text-align: center;
  border-radius: 50%;
  text-decoration: none;
  font-size: 28px;
  color: #000;
  background-color: transparent;
  transition: all 0.2s;
  white-space: nowrap;        /* 줄바꿈 방지 */
}

.level a.selected {
  background-color: #60af46;
  color: white;
}

/* 종류 구분 부분 */
.Crassulaceae, .Cactaceae, .Asphodelaceae, .Euphorbiaceae, .Agavaceae {
  display: block;
  text-align: center;
  margin-top: 100px;
}

.section-title {
  display: flex;
  justify-content: center; /* 가로 가운데 정렬 */
  align-items: center;
  gap: 12px; /* 아이콘과 텍스트 간격 */
  margin-bottom: 90px;
  margin-left: 254px;
  margin-right: 254px;
}

.section-title img {
  width: 80px;
  height: auto;
}

.section-title span {
  font-size: 60px;
  font-family: 'GmarketSansTTFBold';
  color: #60af46;
  white-space: nowrap;
}

.section-title .line {
  flex-grow: 1;
  height: 2px;
  background-color: #60af46;
  margin-left: 20px;    /* 텍스트와 선 사이 */
}

.explain {
	font-family: 'GmarketSansTTFLight';
	font-size: 30px;
	text-align: center;
	padding-bottom: 10px;
}
.sample {
  margin-top: 80px;
  margin-bottom: 120px;
  margin-left: 240px;
  margin-right: 240px;
  display: flex;
  gap: 80px;
  align-items: flex-start;
}

.sample img {
  border: 3px solid #60af46;
}

.sample-explain {
  margin-left: 20px;
  display: flex;
  flex-direction: column;
  gap: 60px;
}

/* 설명 박스 */
.explain-box {
  position: relative;
  width: 930px;                /* 가로 고정 */
  height: 190px;               /* 세로 고정 */
  border: 2px solid #60af46;
  border-radius: 94.5px;       /* 모서리 둥글기 고정 */
  padding: 40px 100px 30px 100px;
  background-color: #fff;
  box-sizing: border-box;
  overflow: visible; /* 중요! 라인 안 끊기게 */
}

/* 제목 + 라인 */
.explain-header {
  position: absolute;
  top: -19px;
  left: 94px;
  display: flex;
  align-items: center;
  background-color: #fff;
  padding: 0 40px;
  height: 35px; /* 높이 축소 */
  box-sizing: border-box;
  width: 150px;
}

/* 제목 텍스트 */
.explain-header .title {
  font-size: 24px;
  font-family: 'GmarketSansTTFMedium';
  color: #60af46;
  white-space: nowrap;
  margin-left: -30px;
}

/* 본문 리스트 */
.explain-list {
  list-style-type: disc;
  padding-left: 20px;
  font-size: 20px;
  font-family: 'GmarketSansTTFLight';
  color: #333;
  line-height: 1.6;
  margin-top: 20px;
  text-align: left;
}


/* 상품 */
.product {
  display: grid;
  grid-template-columns: repeat(4, 1fr); /* 최대 4개 가로 정렬 */
  gap: 50px;                              /* 상품 간 간격 */
  padding: 0 155px;                       /* 좌우 여백 */
  justify-items: center;   /* 상품 가운데 정렬 */
  margin-top: 
}
.productDetail {
	text-align: left;
}
.productDetail img {
	width: 350px;
	height: 350px;
}
.productDetail #name {
	font-size: 28px;
	font-family: 'GmarketSansTTFMedium';
	margin-top: 50px;
	margin-bottom: 24px;
}
.productDetail #price {
	font-size: 24px;
	font-family: 'GmarketSansTTFLight';
</style>
</head>
<body>
    <header class="navbar">
		<a href="main.jsp"><img src="images/logo.png" alt="SuccuBuddy Logo" class="logo"></a>
		<nav class="nav-menu">
			<a href="sub1.jsp">다육 세트</a>
			<a href="sub2.jsp">다육 단품</a>
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
			<a href="logout.jsp" class="nav-logout">로그아웃</a> 
		</div>
	</header>

<div class="header-wrap">
<div class="title">
	<a href="sub2.jsp">다육 단품</a>
</div>
<div class="level">
	<a href="sub2_small.jsp" class="selected">소형</a>
	<a href="sub2_medium.jsp">중형</a>
	<a href="sub2_large.jsp">대형</a>
</div>
</div>

<!-- 돌나물과 -->
<div class="Crassulaceae">
	<div class="section-title">
		<img src="images/C001.png">
		<span>돌나물</span>
		<div class="line"></div>
	</div>

	<div class="explain">주로 잎이 두껍고 로제트 형태를 이루고, 번식이 쉬운 것이 특징이며</div>
	<div class="explain">온대 및 열대 지역에서 주로 서식하고, 실내에서 키우기 좋은 식물</div>

	<div class="sample">
		<a href="product_detail.jsp?product_id=s002" class="productDetail">
			<img src="images/s002.jpg">
			<div id="name">로라</div>
			<div id="price">20,000원</div>
		</a>

		<div class="sample-explain">
		  <!-- 구조적 특징 박스 -->
		  <div class="explain-box">
			<div class="explain-header">
			  <span class="title">구조적 특징</span>
			  <div class="line"></div>
			</div>
			<ul class="explain-list">
			  <li>잎이 두툼하고 통통하여 수분 저장 능력이 뛰어나 가뭄에 강하다</li>
			  <li>로제트 형태(장미 모양 잎 배열)가 많고 로라, 제옥 등이 대표적이다</li>
			  <li>줄기가 짧거나 거의 없으며 일부는 줄기가 길어져 덩굴 형태로 자라기도 한다</li>
			</ul>
		  </div>

		  <!-- 성장 및 번식 박스 -->
		  <div class="explain-box">
			<div class="explain-header">
			  <span class="title">성장 및 번식</span>
			  <div class="line"></div>
			</div>
			<ul class="explain-list">
			  <li>잎꽂이, 줄기꽃이로 번식이 쉽고 잎 하나만 떨어져도 뿌리를 내릴 수 있다</li>
			  <li>햇볕이 충분해야 건강하게 자랄 수 있어 햇빛이 부족하면 웃자람 발생한다</li>
			</ul>
		  </div>
		</div>

	</div><!-- sample -->
</div> <!-- Crassulaceae -->
<%

Connection con = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    String DB_URL = "jdbc:mysql://localhost:3306/succu";
    String DB_ID = "multi";
    String DB_PASSWORD = "abcd";

    Class.forName("org.gjt.mm.mysql.Driver");
    con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

	String sql = "SELECT p.product_id, p.name, p.price " +
				 "FROM product p " +
				 "JOIN species s ON p.product_id = s.product_id " +
				 "WHERE s.category_name = 1 AND s.family_name = '돌나물과' " +
				 "AND p.product_id != 's002'";


    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();

%>

<!-- 출력 결과 -->
<div class="product">
<%
    while (rs.next()) {
        String productId = rs.getString("product_id");
        String name = rs.getString("name");
        int price = rs.getInt("price");
%>
    <a href="product_detail.jsp?product_id=<%= productId %>" class="productDetail">
        <img src="images/<%= productId %>.jpg">
        <div id="name"><%= name %></div>
        <div id="price"><%= String.format("%,d", price) %>원</div>
    </a>
<%
    } // while 끝
%>
</div>
 <!-- .product 끝 -->

<%
    } catch (Exception e) {
        out.println("에러: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>

<!-- 백합과 -->
<div class="Asphodelaceae">
	<div class="section-title">
		<img src="images/C003.png">
		<span>백합</span>
		<div class="line"></div>
	</div>

	<div class="explain">대체로 로제트 형태를 띠고 있고, 선인장과 달리 잎이 있으며</div>
	<div class="explain">다육식물 중에서도 공기 정화 능력이 뛰어난 종류가 많은 식물</div>

	<div class="sample">
		<a href="product_detail.jsp?product_id=s001" class="productDetail">
			<img src="images/s001.jpg">
			<div id="name">하월시아 옵투사</div>
			<div id="price">20,000원</div>
		</a>

		<div class="sample-explain">
		  <!-- 구조적 특징 박스 -->
		  <div class="explain-box">
			<div class="explain-header">
			  <span class="title">구조적 특징</span>
			  <div class="line"></div>
			</div>
			<ul class="explain-list">
			  <li>잎이 가늘고 길며 끝이 뾰족한 경우가 많다</li>
			  <li>일부 종은 줄기가 없이 땅에서 바로 잎이 퍼진다</li>
			  <li>반그늘에서도 잘 자란다</li>
			</ul>
		  </div>

		  <!-- 성장 및 번식 박스 -->
		  <div class="explain-box">
			<div class="explain-header">
			  <span class="title">성장 및 번식</span>
			  <div class="line"></div>
			</div>
			<ul class="explain-list">
			  <li>잎꽂이나 줄기꽂이로 번식 가능하다</li>
			  <li>햇빛이 부족해도 비교적 잘 견딘다</li>
			</ul>
		  </div>
		</div>

	</div><!-- sample -->
</div> <!-- asphodelaceae -->

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