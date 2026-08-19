<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.net.URLEncoder" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<%@ page contentType="text/html; charset=euc-kr" %>


<!DOCTYPE html>
<html>
<head>
  <meta charset="euc-kr">
  <title>다육탐구생활</title>
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
         width: 100%;
         margin: 0 auto;
         margin-bottom: 20px; /* 네비게이션 아래 여백 추가 */
		 position: fixed;
		 top: 0;
		 left: 0;
		 z-index: 999;

		/* 반투명 배경 + 블러 처리 */
		  background-color: rgba(255, 255, 255, 0.8); /* 반투명 흰색 */
		  backdrop-filter: blur(8px); /* 뒷배경 블러 효과 */
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

.container-title {
      text-align: center;
      margin: 40px 0 30px;
      font-size: 34px;
	  font-family: 'GmarketSansTTFMedium';
	  padding-top: 220px;
    }

    .form-wrapper {
      width: 1440px;
      margin: 60px auto;
      padding: 40px;
      background-color: #f1f6ed;
      border-radius: 20px;
      box-sizing: border-box;
    }
    h2 {
      font-family: 'GmarketSansTTFBold';
      font-size: 40px;
     margin-top: -10px;
      margin-bottom: 30px;
    }

    .form-row {
      display: flex;
      gap: 20px;
      margin-bottom: 20px;
     width: 100%;
     box-sizing: border-box;
    }
    .form-input {
      font-family: 'GmarketSansTTFLight';
      font-size: 30px;
      padding: 10px 30px;
      border-radius: 10px;
      border: none;
    }
    .form-input {
      height: 80px;
      width: 50%;
    }

	.img-textarea {
		background-color: white; 
		width: 100%; 
		border-radius: 10px; 
		padding-left: 20px; 
		margin-bottom: 20px;
	}
	.img-textarea #contentField {
	width: 100%;
	background: none;
	border: none;
	white-space: pre-line;
	font-size: 25px;
	font-family: 'GmarketSansTTFLight';
	padding-bottom: 30px;
	}
	#contentField table {
	  border-collapse: collapse;
	}
	#contentField table td {
	  height: 25px;
	  padding-top: 5px;
	  padding-bottom: 5px;
	}
	#contentField table td:nth-child(1) {
	  width: 20%;
	  padding-left: 10px;
	}
	.line{
	  border-bottom: 1px solid #000;
	}
    .btn {
     width: 200px;
     height: 80px;
      border-radius: 33px;
      border: none;
      margin: 5px;
      background-color: #60af46;
      color: white;
      font-size: 30px;
      cursor: pointer;
     font-weight: bold;
    }
    .file-upload-wrapper {
      height: 80px;
      background-color: #ffffff;
      padding: 0 25px;
      display: flex;
      align-items: center;
      box-sizing: border-box;
      cursor: pointer;
     border-radius: 10px;
    }
   .file-upload-wrapper span {
     width: 49%;
   }
    .file-icon {
      width: 40px;
      height: 40px;
      margin-right: 10px;
    }
    .file-remove {
      width: 18px;
      height: 18px;
      cursor: pointer;
    }
    #edit-file-name {
      flex-grow: 1;
      font-size: 30px;
      font-family: 'GmarketSansTTFLight';
      color: #000;
    }

  .pagination {
    text-align: center;
    margin-top: 60px;
	margin-bottom: 60px;
  }
  .pagination a {
    margin: 0 5px;
   text-decoration: none;
   font-size: 30px;
   line-height: 1;
   vertical-align: middle;
   margin-left: 20px;
   margin-right: 20px;
   color: black;
  }
  .pagination .active-page {
    background-color: #5cbf3a;
   color: white;
   padding: 6px 12px;
   border-radius: 10px;
   font-size: 30px;
   line-height: 1;         /* 기본값으로 줄임 */
   display: inline-block;  /* inline-block으로 중앙 정렬 가능 */
   vertical-align: middle; /* 주변 텍스트와 수직 정렬 맞추기 */
  }

/* 댓글 */
  .background {
	background-color: #fff;
	border-radius: 15px;
  }
  .comment {
    width: 90%;
	margin: 0 auto;
    display: flex;
    flex-direction: column;
  }
  .comment-header {
	padding-top: 40px;
	border-bottom: 1px solid #bcbcbc;
	width: 100%;
  }
  .comment-id table {
    width: 100%;
  }
  .comment-id table td {
	padding-top: 10px;
	padding-bottom: 10px;
  }
  .comment-id table td:nth-child(1) {
    width: 80%;
	font-size: 30px;
    font-family: 'GmarketSansTTFMedium';
	padding-left: 60px;
  }
  .comment-id table td:nth-child(2) {
    width: 10%;
  }
  .comment-id table td:nth-child(3) {
	width: 10%;
  }
  .comment-id table img {
	cursor: pointer;
  }
  .comment-text-detail table {
	width: 100%;
  }
  .comment-text-detail table td {
	font-size: 24px;
	font-family: 'GmarketSansTTFLight';
	padding-left: 60px;
  }
  .comment-ymd table {
    width: 100%;
  }
  .comment-ymd table td:nth-child(1) {
    width: 80%;
	font-size: 24px;
	font-family: 'GmarketSansTTFLight';
	padding-left: 60px;
	color: #b0b0b0;
  }
  .comment-ymd table td:nth-child(2) {
  	padding-top: 5px;
	padding-bottom: 40px;
  }
  .comment-ymd button {
	width: 50%;
	height: 45px;
	font-size: 24px;
	color: #fff;
	font-family: 'GmarketSansTTFBold';
	background-color: #f4a900;
	border: none;
	border-radius: 23px;
	cursor: pointer;
  }

  .reply-section {
	width: 90%;
	margin: 0 auto;
    display: flex;
    flex-direction: column;
  }
  .reply {
	border-bottom: 1px solid #bcbcbc;
  }
  .reply-id table {
	width: 100%;
  }
  .reply-id td {
	padding-bottom: 10px;
  }
  .reply-id table td:nth-child(1) {
	width: 10%;
	padding-left: 40px;
	padding-top: 40px;
  }
  .reply-id table td:nth-child(2) {
	width: 10%;
	padding-top: 60px;
	font-size: 28px;
	font-family: 'GmarketSansTTFMedium';
	color: #60af46;
	padding-right: 40px;
  }
  .reply-id table td:nth-child(3) {
  	width: auto;
	padding-top: 60px;
  }
  .reply-id table button {
	padding: 5px 30px;
	background-color: #fff;
	color: #60af46;
	border: 1px solid #60af46;
	border-radius: 16px;
	font-size: 18px;
	font-family: 'GmarketSansTTFLight';
  }
  .reply-id table td:nth-child(4) {
	width: 10%;
	padding-top: 60px;
  }
  .reply-id table img {
	cursor: pointer;
  }

  /* 작성자가 아닐 때 */
  .reply-id2 table {
	width: 100%;
  }
  .reply-id2 td {
	padding-bottom: 10px;
  }
  .reply-id2 table td:nth-child(1) {
	width: 10%;
	padding-left: 40px;
	padding-top: 40px;
  }
  .reply-id2 table td:nth-child(2) {
	width: 10%;
	padding-top: 60px;
	font-size: 28px;
	font-family: 'GmarketSansTTFMedium';
	padding-right: 40px;
  }
  .reply-id2 table td:nth-child(3) {
  	width: auto;
	padding-top: 60px;
  }
  .reply-id2 table td:nth-child(4) {
	width: 10%;
	padding-top: 60px;
  }

  .reply-text-detail table {
	width: 100%;
  }
  .reply-text-detail table td:nth-child(1) {
	width: 10%;
  }
  .reply-text-detail table td:nth-child(2) {
	width: 90%;
	font-size: 24px;
	font-family: 'GmarketSansTTFLight';
  }
  .reply-ymd table {
	width: 100%;
  }
  .reply-ymd table td:nth-child(1) {
	width: 10%;
  }
  .reply-ymd table td:nth-child(2) {
	width: 70%;
	font-size: 24px;
	font-family: 'GmarketSansTTFLight';
	color: #b0b0b0;
  }
  .reply-ymd table td:nth-child(3) {
	width: 20%;
	padding-top: 40px;
	padding-bottom: 40px;
  }
  .comment-form {
	width: 90%;
	margin: 0 auto;
    display: flex;
    flex-direction: column;
  }
  .comment-form table {
	width: 100%;
	margin: 0 auto;
	border-collapse: separate; /* 테두리 겹침 방지 */
	border-spacing: 0;
	margin-bottom: 60px;
  }
  .comment-form table td:nth-child(1) {
	width: 80%;
  }
  .comment-form table td:nth-child(2) {
	text-align: center;
  }
  .comment-form #loginUser {
    font-size: 28px;
	font-family: 'GmarketSansTTFMedium';
	padding-left: 40px;
	padding-top: 20px;
	padding-bottom: 20px;
  }
  .comment-form button {
	width: 50%;
	height: 45px;
	font-size: 24px;
	color: #fff;
	font-family: 'GmarketSansTTFBold';
	background-color: #f4a900;
	border: none;
	border-radius: 23px;
	cursor: pointer;
  }
  .comment-form table textarea {
	width: 100%;
	font-size: 24px;
	font-family: 'GmarketSansTTFLight';
	padding-left: 40px;
	padding-top: 20px;
	line-height: 1.2;
	box-sizing: border-box;
	height: 200px;
	border: none;
	resize: none;
	background: none;
  }
  .comment-write {
	width: 90%;
	margin: 0 auto;
    display: flex;
    flex-direction: column;
	border-bottom: 1px solid #bcbcbc;
  }
  .comment-write table {
	width: 100%;
	padding-top: 40px;
	margin-bottom: 40px;
	border-collapse: separate; /* 테두리 겹침 방지 */
	border-spacing: 0;
  }
  .comment-write td {
	padding-bottom: 10px;
  }
  .comment-write table td:nth-child(1) {
    width: 10%;
	padding-left: 60px;
  }
  .comment-write table td:nth-child(2) {
	width: 60%;
	font-size: 24px;
	font-family: 'GmarketSansTTFMedium';
	padding-bottom: 20px;
  }
  .comment-write table td:nth-child(3) {
  	width: 20%;
	text-align: center;
  }
  .comment-write table button {
	width: 40%;
	height: 40px;
	font-size: 18px;
	color: #fff;
	font-family: 'GmarketSansTTFBold';
	background-color: #f4a900;
	border: none;
	border-radius: 23px;
	cursor: pointer;
  }
  .comment-write table textarea {
	width: 100%;
	font-size: 24px;
	font-family: 'GmarketSansTTFLight';
	line-height: 1.2;
	box-sizing: border-box;
	height: 170px;
	border: none;
	resize: none;
	background: none;
	padding-top: 20px;
	padding-left: 40px;
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
         <a href="sub4.jsp">다육탐구생활</a>
         <a href="sub5.jsp">고객센터</a>
      </nav>
      <div class="nav-icons">
         <a href="mypage.jsp"><img src="images/Person.png" alt="사용자"></a>
         <a href="shopping_list.jsp"><img src="images/cart.png" alt="장바구니"></a>
         <a href="logout.jsp" class="nav-login">로그아웃</a> 
      </div>
   </header>
<div class="container-title" onclick="window.location.href='sub4_share.jsp';" style="cursor: pointer;">사계절 관리 방법</div>

<div class="form-wrapper">
  <!-- 제목 -->
  <h2>
    <input class="form-input" id="titleInput" name="newTitle" readonly
           value="가을"
           style="font-family: 'GmarketSansTTFBold'; font-size: 40px; background-color: #f1f6ed; border: none;">
  </h2>

  <!-- 작성일, 작성자 -->
  <div class="form-row">
    <input type="text" value="2025.04.09" readonly class="form-input">
    <input type="text" value="관리자" readonly class="form-input">
  </div>

    <!-- 카테고리, 파일 -->
    <div class="form-row" id="editToggleRow" style="display: none; gap: 20px;">
      <input type="text" value="" class="form-input" readonly style="width: 50%;">
      <div class="file-upload-wrapper" style="width: 50%; cursor: pointer;" onclick="document.getElementById('editImageFile').click();">
        <img src="images/Attach.png" class="file-icon">
        <span id="edit-file-name">파일을 선택하세요</span>
        <img src="images/cross.png" class="file-remove" id="edit-file-remove" onclick="removeEditFile(event)">
        <input type="file" id="editImageFile" name="image" accept="image/*" style="display: none;" onchange="updateEditFileName(this)">
      </div>
    </div>

    <!-- 이미지 출력 + 내용 -->
	<div class="img-textarea">

		

	  <div id="contentField">
		[특징]

		9~11월로 여름 스트레스에서 회복하고 다시 활발히 자라기 시작하는 계절
		분갈이와 가지치기, 삽목에도 좋은 시즌


		X 관리 포인트 X

		<table>
		  <tr>
		    <td class="line">항목</td>
			<td class="line">설명</td>
		  <tr>
		  <tr>
		    <td>햇빛</td>
			<td>서서히 강한 빛을 다시 받아도 OK. 일조량을 늘리면서 성장 촉진</td>
		  </tr>
		  <tr>
		    <td>물주기</td>
			<td>봄처럼. 흙이 마르면 듬뿍 주고, 평소보다 급수 빈도를 늘려도 괜찮음</td>
		  </tr>
		  <tr>
		    <td>분갈이</td>
			<td>늦어도 10월 초까지는 가능. 이후는 비추</td>
		  </tr>
		  <tr>
		    <td>삽목</td>
			<td>이 시기 삽목 성공률 최고!</td>
		  </tr>
		  <tr>
		    <td>비료</td>
			<td>가볍게 추가 가능 (2~3주 간격 소량)</td>
		  </tr>
		</table>
		→ TIP
		가을은 다육을 풍성하게 키울 '두 번째 골든타임'입니다. 햇빛과 통풍만 잘 챙기면, 튼튼한 겨울 대비가 가능합니다.
	  </div>

	</div>
  </form>
  </div>
</div>
</div>
</center>

<script>
function updateEditFileName(input) {
  const fileName = input.files.length > 0 ? input.files[0].name : '파일을 선택하세요';
  document.getElementById('edit-file-name').textContent = fileName;
}
function removeEditFile(event) {
  event.stopPropagation();
  const input = document.getElementById('editImageFile');
  input.value = '';
  document.getElementById('edit-file-name').textContent = '파일을 선택하세요';
}
function handleEdit() {
  const pw = document.getElementById("pwInput").value;
  if (!pw) {
    alert("비밀번호를 입력해주세요.");
    return;
  }
  document.getElementById("editPwHidden").value = pw;
  document.getElementById("titleInput").removeAttribute("readonly");
  document.getElementById("titleInput").focus();
  document.getElementById("contentField").removeAttribute("readonly");
  document.getElementById("editToggleRow").style.display = "flex";
  document.getElementById("editBtn").style.display = "none";
  document.getElementById("saveBtn").style.display = "inline-block";
}
function handleSubmitEdit() {
  document.getElementById("finalTitle").value = document.getElementById("titleInput").value;
  document.getElementById("finalContent").value = document.getElementById("contentField").value;
  document.getElementById("realSubmit").click();
}
</script>

<!-- 댓글/대댓글 기능 스크립트 -->
<script>
// 대댓글 토글 함수
function showReplyForm(formId) {
  const form = document.getElementById(formId);
  form.style.display = (form.style.display === "none") ? "block" : "none";
}

// 댓글 본문은 항상 보이고, 대댓글 영역만 토글
function toggleReplySection(commentId) {
  const section = document.getElementById("replySection" + commentId);
  if (section) {
    section.style.display = (section.style.display === "none") ? "block" : "none";
  }
}
</script>
<!--푸터-->
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
