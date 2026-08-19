<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.net.URLEncoder" %>
<%@ page import="java.util.*, java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>

<%
request.setCharacterEncoding("euc-kr");

String writer = "관리자";
String title = "", content = "", imageName = "", regDate = "";

String itemIdParam = request.getParameter("item_id");
int itemId = 0;
if (itemIdParam != null && itemIdParam.matches("\\d+")) {
    itemId = Integer.parseInt(itemIdParam);
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr",
        "multi", "abcd"
    );

    //  조회수 증가 제거됨

    //  해당 글 내용만 조회
    String sql = "SELECT item_title, item_content, image_name, reg_date FROM sub4_items WHERE item_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, itemId);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        title = rs.getString("item_title");
        content = rs.getString("item_content");
        imageName = rs.getString("image_name");
        regDate = new SimpleDateFormat("yyyy.MM.dd").format(rs.getTimestamp("reg_date"));
    } else {
        System.out.println("해당 item_id의 항목이 없습니다.");
    }

} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>


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
      font-family: 'RixInooAriDuriPro';
      src: url('fonts/RixInooAriDuri_Pro Regular.otf') format('opentype');
      font-weight: normal;
      font-style: normal;
    }
  body {
    margin: 0;
    padding: 0;
    background-color: #ffffff;
    font-family: 'GmarketSansTTFLight';
  }
 .return-link-wrapper {
  width: 100%;
  text-align: center;
  margin-top: 30px;
}

.return-link-text {
  font-size: 34px;
  font-family: 'GmarketSansTTFMedium';
  color: #444;
  text-decoration: none; /* 밑줄 제거 */
}


  .detail-wrapper {
    width: 1500px;
    margin: 60px auto;
    background-color: #f1f6ed;
    padding: 50px;
    border-radius: 20px;
    box-sizing: border-box;
  }

  .label-title {
    font-family: 'GmarketSansTTFMedium';
    font-size: 40px;
    margin-bottom: 25px;
  }

  .row {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
  }

  .input-box {
    flex: 1;
    height: 97px;
    border: none;
    border-radius: 6px;
    background-color: #ffffff;
    padding: 0 20px;
    font-size: 34px;
    box-sizing: border-box;
    font-family: 'GmarketSansTTFLight';
  }

  .content-box {
    background-color: #ffffff;
    border-radius: 10px;
    padding: 30px;
    min-height: 600px;
    box-sizing: border-box;
  }

 .image-box {
  width: 100%;
  max-width: 280px;
  height: auto;
  border-radius: 5px;
  margin-bottom: 30px;
  display: block;
}


  .placeholder-text {
	  font-size: 28px;
	  color: #333;
	  font-family: 'GmarketSansTTFLight';
	  line-height: 1.2;       /* 줄 간격 좁히기 */
	  white-space: normal;    /* <br> 태그 쓸 거면 pre-wrap 제거 */
	}


    .navbar {
			display: flex;
			justify-content: space-between;
			align-items: center;
			padding: 80px 150px;
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
			gap: 90px;
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
</style>

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

<div class="return-link-wrapper">
  <a href="sub4.jsp?category=<%= URLEncoder.encode("키움백과", "euc-kr") %>" class="return-link-text">
    키움백과
  </a>
</div>

<div class="detail-wrapper">
  <div class="label-title"><%= title != null ? title : "제목 없음" %></div>

  <div class="row">
    <input type="text" class="input-box" readonly value="<%= regDate %>">
    <input type="text" class="input-box" readonly value="<%= writer %>">
  </div>

  <div class="content-box">
    <% if (imageName != null && !imageName.trim().equals("")) { %>
      <img src="/uploads/<%= imageName %>" class="image-box" alt="첨부 이미지">
    <% } %>

    <div class="placeholder-text">
	  <%= content != null ? content.replaceAll("\n", "<br>") : "내용이 없습니다." %>
	</div>


  </div>
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
        <span><a href="footerp">개인정보처리방침</a> | <a href="#">이용약관</a></span>
    </div>
</footer>
<!--<script>
  function removeFile(e) {
    e.stopPropagation();
    const input = document.getElementById('imageFile');
    document.getElementById('file-name').innerText = '파일을 선택하세요';
    document.getElementById('file-remove').style.display = 'none';
    input.value = '';
  }

  document.addEventListener("DOMContentLoaded", function () {
    const input = document.getElementById("imageFile");
    input.addEventListener("change", function () {
      if (input.files.length > 0) {
        document.getElementById("file-name").innerText = input.files[0].name;
        document.getElementById("file-remove").style.display = "inline";
      }
    });
  });
</script>-->
<script>
window.onpageshow = function(event) {
  if (event.persisted || performance.getEntriesByType("navigation")[0].type === "back_forward") {
    location.href = "sub4.jsp?category=" + encodeURIComponent("키움백과");
  }
};
</script>

