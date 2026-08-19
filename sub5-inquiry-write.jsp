<%@ page contentType="text/html;charset=euc-kr" %>
<%
    request.setCharacterEncoding("euc-kr");

    // 세션에서 userId 가져오기
    String userId = (String) session.getAttribute("sid");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>고객센터</title>
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


      /* 로그인 링크 스타일 */
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
		.title {
		  width: 1100px;
		  margin-top: 200px;
		  margin-bottom: 40px;
		  font-family: 'GmarketSansTTFLight';
		  font-size: 32px;
		  text-align: left;
		  color: #888;
		}
		.write {
		  font-family: 'GmarketSansTTFLight';
		  font-size: 24px;
		}
		.write table {
		  width: 1100px;
		  border-top: 1px solid #000;
		  border-bottom: 1px solid #000;
		  margin-bottom: 20px;
		}
		.write td {
		  padding: 10px;
		}
		#inquiry-subject input {
		  border: none;
		  background-color: #eee;
		  width: 800px;
		  height: 80px;
		  padding-left: 20px;
		  font-family: 'GmarketSansTTFLight';
		  font-size: 24px;
		}
		#inquiry-text textarea {
			border: none;
			background-color: #eee;
			width: 1100px;
			height: 450px;
			padding: 20px;
			font-family: 'GmarketSansTTFLight';
		    font-size: 24px;
			resize: none;
		}
		.write-btn {
			width: 1100px;
			display: flex;
			justify-content: flex-end; /* 오른쪽 정렬 */
			gap: 10px; /* 버튼 사이 간격 */
			margin-bottom: 80px;
		}

		.reset {
		  width: 180px;
		  height: 60px;
		  border: 1px solid #60af46;
		  border-radius: 15px;
		  background-color: #fff;
		  color: #60af46;
		  font-family: 'GmarketSansTTFLight';
		  font-size: 24px;
		  margin-right: 20px;
		}
		.submit {
		  width: 180px;
		  height: 60px;
		  border: none;
		  border-radius: 15px;
		  background-color: #60af46;
		  color: #fff;
		  font-family: 'GmarketSansTTFLight';
		  font-size: 24px;
		}
		#inquiry-pswd input {
		  border: none;
		  background-color: #eee;
		  width: 400px;
		  height: 80px;
		  padding-left: 20px;
		  font-family: 'GmarketSansTTFLight';
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
<div class="title">
  <a href="sub5-inquiry.jsp">고객센터</a> > 문의작성
</div>

<form action="sub5-inquiry-save.jsp" method="post">
<div class="write">
<table>
  <tr>
  	<td id="inquiry-subject" style="width: 800px;">
      <input type="text" name="inquiry_subject" placeholder="제목을 작성하세요." required>
    </td>
	<td>
      <%= userId %>
      <input type="hidden" name="user_id" value="<%= userId %>"> <!-- 사용자 아이디도 넘김 -->
    </td>
  </tr>
  <tr>
    <td id="inquiry-text" colspan="2">
      <textarea name="inquiry_text" placeholder="문의 내용을 작성하세요." required></textarea>
    </td>
  </tr>
  <tr>
    <td id="inquiry-pswd">
	  <input name="inquiry_pswd" type="password" placeholder="비밀번호를 입력하세요.">
	</td>
  </tr>
</table>
</div>

<div class="write-btn">
  <button type="button" class="reset" onclick="history.back()">취소</button>
  <button type="submit" class="submit">등록</button>
</div>
</form>
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
