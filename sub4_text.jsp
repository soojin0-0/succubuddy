<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.net.URLEncoder" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%
request.setCharacterEncoding("euc-kr");

String loginId = (String) session.getAttribute("sid");
String diaryIdParam = request.getParameter("diary_id");

int diaryId = 0;
if (diaryIdParam != null && diaryIdParam.matches("\\d+")) {
    diaryId = Integer.parseInt(diaryIdParam);
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String writer = "", category = "", title = "", content = "", imageName = "", regDate = "", password = "", status = "나눔중";
String roadAddress = "";
boolean isOwner = false;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr", "multi", "abcd");

    pstmt = conn.prepareStatement("SELECT * FROM sub4_write WHERE diary_id = ?");
	pstmt.setInt(1, diaryId);

    rs = pstmt.executeQuery();

    if (rs.next()) {
        writer = rs.getString("user_id");
        category = rs.getString("category");
        title = rs.getString("title");
        content = rs.getString("content");
        imageName = rs.getString("image_name");
        password = rs.getString("password");
        status = rs.getString("status");
        Timestamp ts = rs.getTimestamp("reg_date");
        regDate = new SimpleDateFormat("yyyy.MM.dd").format(ts);
    }
    rs.close(); pstmt.close();

    if (writer != null && !writer.equals("")) {
        pstmt = conn.prepareStatement("SELECT address FROM user WHERE user_id = ?");
        pstmt.setString(1, writer);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            String address = rs.getString("address");
            if (address.contains(",")) {
                String[] parts = address.split(",");
                if (parts.length > 1) roadAddress = parts[1];
            }
        }
        rs.close(); pstmt.close();
    }

    isOwner = loginId != null && loginId.equals(writer);

    if (conn != null) conn.close();
} catch (Exception e) {
    e.printStackTrace();
}

// 카테고리에 따른 상단 이동 처리
String categoryTitle = "나눔창고";
String returnPage = "sub4_market.jsp";

if ("궁금톡톡".equals(category)) {
    categoryTitle = "궁금톡톡";
    returnPage = "sub4_question.jsp";
}

%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="euc-kr">
  <title>다육일기 상세보기</title>
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
	  padding-top: 150px;
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
	.form-wrapper #statusBtn {
	  width: 150px;
	  height: 60px;
	  color: #fff;
	  background-color: #f4a900;
	  border-radius: 23px;
	  border: none;
	  font-family: 'GmarketSansTTFBold';
	  float: right;
	  cursor: pointer;
	}
	.form-wrapper #statusBtn:hover {
	  background-color: #e89b00; /* 좀 더 진한 주황색 계열 */
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
		padding: 20px; 
		margin-bottom: 20px;
	}
	.img-textarea textarea {
		margin: 0;
		padding: 10px;
		font-size: 30px;
		font-family: 'GmarketSansTTFLight';
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
  .pagination .disabled-page {
  color: #ccc;
  font-size: 30px;
  padding: 6px 12px;
  border-radius: 10px;
  background-color: transparent;
  display: inline-block;
  vertical-align: middle;
  cursor: default;
  margin-left: 20px;
  margin-right: 20px;
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
  .comment-text-detail textarea {
	width: 90% !important;
	height: 120px !important;
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
	margin-top: 60px;
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

  .dot-menu-container {
    position: relative;
    display: inline-block;
  }

  .dropdown-menu {
    position: absolute;
    top: 30px;
    right: 0;
    background-color: white;
    border: 1px solid #ccc;
    width: 80px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.15);
    z-index: 100;
  }

  .dropdown-item {
    padding: 10px;
    text-align: center;
    cursor: pointer;
    border-bottom: 1px solid #eee;
    font-size: 14px;
  }

  .dropdown-item:last-child {
    border-bottom: none;
  }

  .dropdown-item:hover {
    background-color: #f0f0f0;
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
<div class="container-title" onclick="loadSectionByCategory('<%= category %>')" style="cursor: pointer;">
  <a href="sub4.jsp?category=<%= URLEncoder.encode(categoryTitle, "euc-kr") %>" class="container-title" style="cursor: pointer;">
  <%= categoryTitle %>
</a>
</div>

<div class="form-wrapper">
  <!-- 제목 -->
  <h2>
    <input class="form-input" id="titleInput" name="newTitle" readonly
           value="<%= title %>"
           style="font-family: 'GmarketSansTTFBold'; font-size: 40px; background-color: #f1f6ed; border: none;">

<% if (!"궁금톡톡".equals(category)) { %>
	<button id="statusBtn"
			style="font-size:24px; padding:8px 16px; <%= isOwner ? "" : "background:#ccc;" %>"
			<%= isOwner ? "" : "disabled" %>>
		<%= status %>
	</button>
<% } %>

  </h2>

	<!-- 작성일, 작성자 + 도로명 -->
	<div class="form-row">
	  <input type="text" value="<%= regDate %>" readonly class="form-input">
	  <input type="text" readonly class="form-input"
       style="font-family: 'GmarketSansTTFLight'; font-size: 30px; text-align: left;"
       value="<%= writer %><%= !"궁금톡톡".equals(category) ? " | " + roadAddress : "" %>">

	</div>

  <!-- 수정 폼 -->
  <form id="editForm" action="sub4_textUpdate.jsp" method="post" enctype="multipart/form-data">
  <input type="hidden" name="diary_id" value="<%= diaryId %>">

    <input type="hidden" name="originalTitle" value="<%= title %>">
    <input type="hidden" id="editPwHidden" name="password">
    <input type="hidden" id="finalTitle" name="newTitle">
    <input type="hidden" id="finalContent" name="content">
    <input type="submit" id="realSubmit" style="display: none;">

    <!-- 카테고리, 파일 -->
    <div class="form-row" id="editToggleRow" style="display: none; gap: 20px;">
      <input type="text" value="<%= category %>" class="form-input" readonly style="width: 50%;">
      <div class="file-upload-wrapper" style="width: 50%; cursor: pointer;" onclick="document.getElementById('editImageFile').click();">
        <img src="images/Attach.png" class="file-icon">
        <span id="edit-file-name">파일을 선택하세요</span>
        <img src="images/cross.png" class="file-remove" id="edit-file-remove" onclick="removeEditFile(event)">
        <input type="file" id="editImageFile" name="image" accept="image/*" style="display: none;" onchange="updateEditFileName(this)">
      </div>
    </div>

    <!-- 이미지 출력 + 내용 -->
	<div class="img-textarea">
	  <% if (imageName != null && !imageName.equals("")) { %>
		<div style="width: 150px; height: 150px; overflow: hidden; margin-bottom: 15px;">
		  <img src="<%= request.getContextPath() %>/uploads/<%= imageName %>"
			 style="width: 100%; height: 100%; object-fit: cover; cursor: pointer;"
			 onclick="showImageModal(this.src)">
		</div>
	  <% } %>

	  <textarea rows="10" cols="100" name="content" id="contentField" readonly 
				style="width: 100%; border: none; resize: none; background: none;"><%= content %>
	  </textarea>

	</div>
  </form>

  <% if (isOwner) { %>
  <!-- 비밀번호 + 버튼 -->
  <div class="form-row" style="flex-direction: column; align-items: flex-end;">
    <input type="password" id="pwInput" placeholder="비밀번호 입력" class="form-input"
           style="width: 200px; height: 70px; margin-top: 10px; margin-bottom: 50px; font-size: 23px;">
    <div id="buttonWrapper">
      <button type="button" class="btn" onclick="handleDelete()">삭제</button>
      <button type="button" class="btn" id="editBtn" onclick="handleEdit()">수정</button>
      <button type="button" class="btn" id="saveBtn" onclick="handleSubmitEdit()" style="display: none;">저장</button>
    </div>
  </div>
  <% } %>

<!-- 댓글 -->
<%
  List<Map<String, String>> comments = new ArrayList<>();
  List<Map<String, String>> replies = new ArrayList<>();
  int currentPage = 1;
  int commentsPerPage = 4;
  String loginUser = (String) session.getAttribute("sid");
  String writerId = "";

  try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

	pstmt = conn.prepareStatement("SELECT user_id FROM sub4_write WHERE diary_id = ?");
	pstmt.setInt(1, diaryId);
	rs = pstmt.executeQuery();
	if (rs.next()) {
	  writerId = rs.getString("user_id");
	}

    rs.close(); pstmt.close();

    // 댓글 조회
    pstmt = conn.prepareStatement("SELECT * FROM comment WHERE diary_id = ? ORDER BY comment_id ASC");
    pstmt.setInt(1, diaryId);
    rs = pstmt.executeQuery();
    while (rs.next()) {
      Map<String, String> c = new HashMap<>();
      c.put("id", rs.getString("comment_id"));
      c.put("user", rs.getString("user_id"));
      c.put("text", rs.getString("comment_text"));
      Timestamp ts = rs.getTimestamp("comment_ymd");
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
      c.put("date", sdf.format(ts));
      c.put("is_secret", rs.getString("is_secret"));
      comments.add(c);
    }
    rs.close(); pstmt.close();

    // 대댓글 조회
    pstmt = conn.prepareStatement("SELECT * FROM reply WHERE comment_id IN (SELECT comment_id FROM comment WHERE diary_id = ?) ORDER BY reply_id ASC");
    pstmt.setInt(1, diaryId);
    rs = pstmt.executeQuery();
    while (rs.next()) {
      Map<String, String> r = new HashMap<>();
      r.put("id", rs.getString("reply_id"));
      r.put("comment_id", rs.getString("comment_id"));
      r.put("user", rs.getString("user_id"));
      r.put("text", rs.getString("reply_text"));
	  r.put("is_secret", rs.getString("is_secret"));
      Timestamp ts = rs.getTimestamp("reply_ymd");
      r.put("date", new SimpleDateFormat("yyyy.MM.dd").format(ts));
      replies.add(r);
    }
    rs.close(); pstmt.close(); conn.close();
  } catch (Exception e) { e.printStackTrace(); }

  // 페이지 계산
  String pageParam = request.getParameter("cpage");
  if (pageParam != null && !pageParam.equals("")) currentPage = Integer.parseInt(pageParam);

  List<Map<String, String>> topComments = new ArrayList<>();
  for (Map<String, String> c : comments) {
    topComments.add(c);
  }

  int totalTop = topComments.size();
  int totalPages = (int) Math.ceil(totalTop / (double) commentsPerPage);
%>

<!-- 댓글 리스트 출력 -->
<div class="comment-section">
  <h2 style="margin-top: 80px;">댓글</h2>
  <div class="background">
    <%
      for (int j = (currentPage - 1) * commentsPerPage; j < currentPage * commentsPerPage && j < topComments.size(); j++) {
        Map<String, String> c = topComments.get(j);
        String id = c.get("id");
        String userId = c.get("user");
        String text = c.get("text");
        String date = c.get("date");

        boolean isSecret = "1".equals(c.get("is_secret"));
        boolean isMine = loginUser != null && loginUser.equals(userId);
        boolean isPostOwner = loginUser != null && loginUser.equals(writerId);
        boolean showText = !isSecret || isMine || isPostOwner;

        // 대댓글 유무 확인
        boolean hasReplies = false;
        for (Map<String, String> reply : replies) {
          if (reply.get("comment_id").equals(id)) {
            hasReplies = true;
            break;
          }
        }
    %>

<% if (id != null && !id.isEmpty()) { %>
<div class="comment">
  <div class="comment-header">
    <div class="comment-text">
      <div class="comment-id">
        <table>
          <tr>
            <td><%= userId %></td>
<% if (hasReplies && (isMine || isPostOwner)) { %>
  <td>
    <img src="images/arrow-big.png" class="dropdown-btn" onclick="toggleReplySection('<%= id %>')">
  </td>
<% } %>
<td>
  <% if (isMine || isPostOwner) { %>
    <div class="dot-menu-container">
      <img src="images/jum.png" width="40" height="40" class="jum-btn" onclick="toggleMenu('<%= id %>')">
      <div id="menu-<%= id %>" class="dropdown-menu" style="display: none;">
        <% if (isMine) { %>
          <div class="dropdown-item" onclick="enableCommentEdit('<%= id %>')">수정</div>
        <% } %>
        <div class="dropdown-item" onclick="deleteComment('<%= id %>', '<%= diaryId %>')">삭제</div>
      </div>
    </div>
  <% } else if (hasReplies) { %>
    <div class="dot-menu-container">
      <img src="images/arrow-big.png" class="dropdown-btn"
           onclick="toggleReplySection('<%= id %>'); toggleMenu('<%= id %>')">
      <div id="menu-<%= id %>" class="dropdown-menu" style="display: none;">
        <div class="dropdown-item" onclick="deleteComment('<%= id %>', '<%= diaryId %>')">삭제</div>
      </div>
    </div>
  <% } %>
</td>
          </tr>
        </table>
      </div>

      <div class="comment-text-detail">
        <table>
          <tr>
			<td id="text-<%= id %>" class="comment-text" data-comment="<%= text.replaceAll("\"","&quot;").replaceAll("'", "&#39;") %>">
			  <% if (showText) { %>
				<%= text %>
			  <% } else { %>
				<i>비밀댓글입니다.</i>
			  <% } %>
			</td>

          </tr>
        </table>
      </div>

      <div class="comment-ymd">
        <table>
          <tr>
            <td><%= date %></td>
            <td>
              <button type="button" id="reply-btn-<%= id %>" onclick="showReplyForm('replyForm<%= id %>')">답글</button>
            </td>
          </tr>
        </table>
      </div>
    </div> <!-- comment-text -->
  </div> <!-- comment-header -->
<% } %>

      <!-- 대댓글 작성 폼 -->
      <form action="sub4_commentReply.jsp" method="post" id="replyForm<%= id %>" style="display: none;">
        <input type="hidden" name="diary_id" value="<%= diaryId %>">
        <input type="hidden" name="parent_id" value="<%= id %>">
        <input type="hidden" name="title" value="<%= title %>">
        <div class="comment-write">
          <table>
            <tr>
              <td><img src="images/reply.png" width="40" height="40"></td>
              <td style="padding-left: 40px; padding-top: 20px;
                         border-left: 1px solid #000;
                         border-top: 1px solid #000;
                         border-bottom: 1px solid #000;
                         border-top-left-radius: 15px;"><%= loginUser %></td>
              <td style="border-top: 1px solid #000;
                         border-right: 1px solid #000;
                         border-bottom: 1px solid #000;
                         border-top-right-radius: 15px;">
                <button type="submit">등록</button></td>
            </tr>
            <tr>
              <td></td>
              <td colspan="2"
                  style="border-left: 1px solid #000;
                         border-right: 1px solid #000;">
                <textarea name="comment_text" placeholder="답글을 작성하세요"></textarea>
              </td>
            </tr>
			<tr>
			  <td></td>
			  <td colspan="2"
				  style="height: 30px;
						 border-left: 1px solid #000;
						 border-right: 1px solid #000;
						 border-bottom: 1px solid #000;
						 border-bottom-left-radius: 15px;
						 border-bottom-right-radius: 15px;
						 position: relative;">
				<input type="hidden" name="is_secret" id="reply_is_secret_<%= id %>" value="0">
				<div style="position: absolute; bottom: 10px; right: 10px; display: flex; align-items: center; gap: 6px;">
				  <img id="reply_secretToggleBtn_<%= id %>" src="images/unlock.png" onclick="toggleReplySecret('<%= id %>')" 
					   alt="비밀" title="비밀 대댓글 전환" 
					   style="width: 24px; height: 24px; cursor: pointer;">
				  <span style="font-size: 16px;">비밀대댓글</span>
				</div>
			  </td>
			</tr>
          </table>
        </div>
      </form>

		<!-- 대댓글 출력 -->
		<div id="replySection<%= id %>" class="reply-section" style="display: none;">
		<%
		for (Map<String, String> reply : replies) {
		  if (reply.get("comment_id").equals(id)) {
			String replyId = reply.get("id");
			String replyUser = reply.get("user");
			String replyText = reply.get("text");
			String replyDate = reply.get("date");
			String replyIsSecret = reply.get("is_secret"); // <- 변수명 변경

			boolean isSecretReply = "1".equals(replyIsSecret); // 기존 유지
			boolean isReplyMine = loginUser != null && loginUser.equals(replyUser);
			boolean replyIsPostOwner = loginUser != null && loginUser.equals(writerId); // <- 변수명 변경
			boolean canSeeReply = !isSecretReply || isReplyMine || replyIsPostOwner;
			boolean showDots = isReplyMine || replyIsPostOwner;
		%>
		  <div class="reply">
			<div class="reply-body">
			  <!-- 작성자 여부에 따른 대댓글 헤더 -->
			  <div class="<%= replyUser.equals(writerId) ? "reply-id" : "reply-id2" %>">
				<table>
				  <tr>
					<td><img src="images/reply.png" width="40" height="40"></td>
					<td><%= replyUser %></td>
					<td><% if (replyUser.equals(writerId)) { %><button>작성자</button><% } %></td>
					<td>
					  <% if (showDots) { %>
					  <div class="dot-menu-container">
						<img src="images/jum.png" width="40" height="40" class="jum-btn" onclick="toggleMenu('reply-<%= replyId %>')">
						<div id="menu-reply-<%= replyId %>" class="dropdown-menu" style="display: none;">
						  <% if (isReplyMine) { %>
							<div class="dropdown-item" onclick="enableReplyEdit('<%= replyId %>')">수정</div>
						  <% } %>
						  <div class="dropdown-item" onclick="deleteReply('<%= replyId %>', '<%= diaryId %>')">삭제</div>
						</div>
					  </div>
					  <% } %>
					</td>
				  </tr>
				</table>
			  </div>

			  <!-- 대댓글 본문 -->
			  <div class="reply-text-detail">
				<table>
				  <tr>
					<td></td>
					<td id="reply-text-<%= replyId %>" data-reply="<%= replyText.replaceAll("\"", "&quot;").replaceAll("'", "&#39;") %>">
					  <% if (canSeeReply) { %>
						<%= replyText %>
					  <% } else { %>
						<i>비밀 대댓글입니다.</i>
					  <% } %>
					</td>
				  </tr>
				</table>
			  </div>

			  <div class="reply-ymd">
				<table>
				  <tr><td></td><td><%= replyDate %></td><td></td></tr>
				</table>
			  </div>
			</div>
		  </div>
		<% } } %>

      </div>
    </div>
    <% } %>

<!-- 페이지네이션 -->
<div class="pagination">
  <% if (totalPages > 1) { %>
    <!-- 이전 페이지 버튼 -->
    <% if (currentPage > 1) { %>
      <a href="sub4_text.jsp?diary_id=<%= diaryId %>&cpage=<%= currentPage - 1 %>">&lt;</a>
    <% } else { %>
      <span class="disabled-page">&lt;</span>
    <% } %>

    <!-- 페이지 번호 -->
    <% for (int i = 1; i <= totalPages; i++) { %>
      <% if (i == currentPage) { %>
        <span class="active-page"><%= i %></span>
      <% } else { %>
        <a href="sub4_text.jsp?diary_id=<%= diaryId %>&cpage=<%= i %>"><%= i %></a>
      <% } %>
    <% } %>

    <!-- 다음 페이지 버튼 -->
    <% if (currentPage < totalPages) { %>
      <a href="sub4_text.jsp?diary_id=<%= diaryId %>&cpage=<%= currentPage + 1 %>">&gt;</a>
    <% } else { %>
      <span class="disabled-page">&gt;</span>
    <% } %>
  <% } %>
</div>

<!-- 댓글 작성 폼 -->
		<div class="comment-form">
		  <form action="sub4_commentWrite.jsp" method="post">
			<input type="hidden" name="diary_id" value="<%= diaryId %>">
			<input type="hidden" name="title" value="<%= title %>">

			<!-- 댓글 내용만 입력 -->
			<table>
			  <tr>
			    <td id="loginUser" 
				style="border-left: 1px solid #000;
					   border-top: 1px solid #000;
					   border-bottom: 1px solid #000;
					   border-top-left-radius: 15px;"><%= loginUser %></td>
				<td
				style="border-top: 1px solid #000;
					   border-right: 1px solid #000;
					   border-bottom: 1px solid #000;
					   border-top-right-radius: 15px;"><button type="submit">등록</button></td>
			  </tr>
			  <tr>
			  	<td colspan="2"
				style="border-left: 1px solid #000;
					   border-right: 1px solid #000;">
	<textarea name="comment_text" placeholder="댓글을 작성하세요" required
			  style="width: 100%; height: 170px; padding: 20px; box-sizing: border-box; border: none; resize: none;
			         font-size: 24px; font-family: 'GmarketSansTTFLight';"></textarea>
				</td>
			  </tr>
			  <tr>
			    <td colspan="2" 
				style="height: 50px;
					   position: relative;
					   border-left: 1px solid #000;
					   border-right: 1px solid #000;
					   border-bottom: 1px solid #000;
					   border-bottom-left-radius: 15px;
					   border-bottom-right-radius: 15px;">
				<!-- 비밀댓글 여부 서버 전송용 -->
				<input type="hidden" name="is_secret" id="is_secret" value="0">

				<!-- 비밀댓글 토글 UI -->
				<div style="position: absolute; bottom: 10px; right: 10px; display: flex; align-items: center; gap: 6px;">
				  <img id="secretToggleBtn" src="images/unlock.png" onclick="toggleSecret()"
					   alt="비밀" title="비밀댓글 전환"
					   style="width: 28px; height: 28px; cursor: pointer;">
				  <span style="font-size: 20px; color: #2f2f2f; font-family: 'GmarketSansTTFMedium';">비밀댓글</span>
				</div>
				</td>
			  </tr>
			</table>

		  </form>
		</div>
</div>
</div>
</div>
</center>

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
  if (!pw) return alert("비밀번호를 입력해주세요");
  document.getElementById("editPwHidden").value = pw;
  document.getElementById("titleInput").removeAttribute("readonly");
  document.getElementById("contentField").removeAttribute("readonly");
  document.getElementById("editToggleRow").style.display = "flex";
  document.getElementById("editBtn").style.display = "none";
  document.getElementById("saveBtn").style.display = "inline-block";
}
function handleSubmitEdit() {
  document.getElementById("finalTitle").value = document.getElementById("titleInput").value;
  document.getElementById("finalContent").value = document.getElementById("contentField").value;
  document.getElementById("editForm").submit();
}
function handleDelete() {
  const pw = document.getElementById("pwInput").value;
  if (!pw) return alert("비밀번호를 입력해주세요");

  const confirmed = confirm("정말 삭제하시겠습니까?");
  if (!confirmed) return;

  location.href = "sub4_textDeleteCheck.jsp?diary_id=<%= diaryId %>&pw=" + encodeURIComponent(pw);
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

<!-- 댓글 수정삭제 버튼 -->
<script>
  function toggleMenu(id) {
    const menu = document.getElementById("menu-" + id);
    if (menu.style.display === "none" || menu.style.display === "") {
      // 다른 메뉴 닫기
      document.querySelectorAll(".dropdown-menu").forEach(m => m.style.display = "none");
      menu.style.display = "block";
    } else {
      menu.style.display = "none";
    }
  }

  // 외부 클릭 시 메뉴 닫기
  window.addEventListener("click", function(e) {
    if (!e.target.classList.contains("jum-btn")) {
      document.querySelectorAll(".dropdown-menu").forEach(menu => {
        menu.style.display = "none";
      });
    }
  });
  
  // 댓글 수정 UI 전환
function enableCommentEdit(commentId) {
  console.log("== enableCommentEdit 실행 ==");
  console.log("받은 commentId:", commentId);

  const textDiv = document.getElementById("text-" + commentId);
  console.log("찾은 댓글 div:", textDiv);

  if (!textDiv) {
    alert("댓글 영역 못 찾음: text-" + commentId);
    return;
  }

  const originalText = textDiv.dataset.comment;
  console.log("원래 댓글 내용:", originalText);

textDiv.innerHTML =
  '<textarea id="edit-text-' + commentId + '" style="width: 100%; height: 100px; padding: 10px; font-size: 16px; font-family: \'GmarketSansTTFLight\';">' +
    originalText +
  '</textarea>' +
  '<br><button type="button" style="margin-top: 8px; background: #60af46; color: white; padding: 8px 16px; border-radius: 10px; border: none; font-family: \'GmarketSansTTFBold\'; font-size: 18px;" onclick="submitCommentEdit(\'' + commentId + '\')">' +
    '수정완료' +
  '</button>' +
	'<button type="button" style="cursor: pointer; background: #fff; color: #60af46; margin-left: 10px; padding: 8px 16px; border-radius: 10px; border: 1px solid #60af46; font-family: \'GmarketSansTTFBold\'; font-size: 18px;" onclick="cancelCommentEdit(\'' + commentId + '\')">' +
      '취소' +
    '</button>';


  setTimeout(() => {
    const btn = document.getElementById(`submit-edit-${commentId}`);
    const textarea = document.getElementById(`edit-text-${commentId}`);

    if (!btn || !textarea) {
      console.log("버튼 또는 텍스트박스 없음");
    } else {
      console.log("버튼 생성 완료");
    }

    btn?.addEventListener("click", () => submitCommentEdit(commentId));
  }, 30);
}

  // 수정 완료 처리 JS + 페이지 유지
  function submitCommentEdit(commentId) {
	console.log("submitCommentEdit 실행됨");
    console.log("받은 commentId: ", commentId);

	const newText = document.getElementById("edit-text-" + commentId).value;
	const diaryId = "<%= diaryId %>";  // JSP 상단에서 request로 받은 diary_id

	const form = document.createElement("form");
	form.method = "post";
	form.action = "sub4_commentUpdate.jsp";

	const idInput = document.createElement("input");
	idInput.type = "hidden";
	idInput.name = "comment_id";
	idInput.value = commentId;

	const textInput = document.createElement("input");
	textInput.type = "hidden";
	textInput.name = "comment_text";
	textInput.value = newText;

	const diaryInput = document.createElement("input");
	diaryInput.type = "hidden";
	diaryInput.name = "diary_id";
	diaryInput.value = diaryId;

	form.appendChild(idInput);
	form.appendChild(textInput);
	form.appendChild(diaryInput);

	document.body.appendChild(form);
	form.submit();
  }

function cancelCommentEdit(commentId) {
  const textDiv = document.getElementById("text-" + commentId);
  const original = textDiv.dataset.comment || '';
  textDiv.innerHTML = original;
}

  
  // 삭제 처리
  function deleteComment(commentId, diaryId) {
    if (!confirm("정말 삭제하시겠습니까? 만약, 대댓글이 있는 댓글을 삭제할 경우 모든 대댓글이 함께 삭제됩니다.")) return;

    const form = document.createElement("form");
    form.method = "post";
    form.action = "sub4_commentDelete.jsp";

	const idInput = document.createElement("input");
	idInput.type = "hidden";
	idInput.name = "comment_id";
	idInput.value = commentId;

	const diaryInput = document.createElement("input");
	diaryInput.type = "hidden";
	diaryInput.name = "diary_id";
	diaryInput.value = diaryId;

	form.appendChild(idInput);
	form.appendChild(diaryInput);
	document.body.appendChild(form);
	form.submit();
}

</script>

<script>
function enableReplyEdit(replyId) {
  const td = document.getElementById("reply-text-" + replyId);
  if (!td) return alert("대댓글 요소 못 찾음");

  const encoded = td.dataset.reply || '';
  const temp = document.createElement("textarea");
  temp.innerHTML = encoded;
  const decoded = temp.value;

  td.innerHTML =
    '<textarea id="edit-reply-' + replyId + '" style="width: 100%; height: 100px; padding: 10px; font-size: 16px; font-family: GmarketSansTTFLight; resize: none;">' + decoded + '</textarea>' +
    '<div style="margin-top: 8px;">' +
    '<button type="button" style="cursor: pointer; background: #60af46; color: white; padding: 8px 16px; border-radius: 10px; border: none; font-family: GmarketSansTTFBold; font-size: 18px; margin-right: 8px;" onclick="submitReplyEdit(\'' + replyId + '\')">수정완료</button>' +
    '<button type="button" style="cursor: pointer; background: #fff; color: #60af46; padding: 8px 16px; border-radius: 10px; border: 1px solid #60af46; font-family: GmarketSansTTFBold; font-size: 18px;" onclick="cancelReplyEdit(\'' + replyId + '\')">취소</button>' +
    '</div>';
}

function cancelReplyEdit(replyId) {
  const td = document.getElementById("reply-text-" + replyId);
  const original = td.dataset.reply || '';
  const temp = document.createElement("textarea");
  temp.innerHTML = original;
  td.innerHTML = temp.value;
}

function submitReplyEdit(replyId) {
  const newText = document.getElementById("edit-reply-" + replyId).value;
  const diaryId = "<%= diaryId %>";

  const form = document.createElement("form");
  form.method = "post";
  form.action = "sub4_commentUpdate.jsp"; // 그대로 댓글 수정 JSP 사용

  const inputId = document.createElement("input");
  inputId.type = "hidden";
  inputId.name = "reply_id";
  inputId.value = replyId;

  const inputText = document.createElement("input");
  inputText.type = "hidden";
  inputText.name = "reply_text";
  inputText.value = newText;

  const inputDiary = document.createElement("input");
  inputDiary.type = "hidden";
  inputDiary.name = "diary_id";
  inputDiary.value = diaryId;

  form.appendChild(inputId);
  form.appendChild(inputText);
  form.appendChild(inputDiary);

  document.body.appendChild(form);
  form.submit();
}

function deleteReply(replyId, diaryId) {
  if (!confirm("정말 삭제하시겠습니까?")) return;

  const form = document.createElement("form");
  form.method = "post";
  form.action = "sub4_commentDelete.jsp";

  const inputId = document.createElement("input");
  inputId.type = "hidden";
  inputId.name = "reply_id";
  inputId.value = replyId;

  const inputDiary = document.createElement("input");
  inputDiary.type = "hidden";
  inputDiary.name = "diary_id";
  inputDiary.value = diaryId;

  form.appendChild(inputId);
  form.appendChild(inputDiary);
  document.body.appendChild(form);
  form.submit();
}
</script>

<!-- 나눔중 버튼 -->
<script>
const title = "<%= URLEncoder.encode(title, "UTF-8") %>";  // 인코딩 맞춰야 서버에서도 제대로 읽음

document.getElementById("statusBtn")?.addEventListener("click", function () {
  const btn = this;
  const current = btn.textContent.trim();
  const newStatus = (current === "나눔중") ? "나눔완료" : "나눔중";

  fetch("updateStatus.jsp?title=" + title + "&status=" + encodeURIComponent(newStatus))
    .then(res => res.text())
    .then(result => {
      if (result.trim() === "OK") {
        btn.textContent = newStatus;
      } else {
        alert("상태 변경 실패");
      }
    })
    .catch(() => alert("요청 중 오류 발생"));
});
</script>

<!-- 비밀댓글 -->
<script>
  function toggleSecret() {
    const btn = document.getElementById("secretToggleBtn");
    const hiddenInput = document.getElementById("is_secret");
    const isSecret = hiddenInput.value === "1";

    if (isSecret) {
      btn.src = "images/unlock.png";
      hiddenInput.value = "0";
    } else {
      btn.src = "images/Lock.png";
      hiddenInput.value = "1";
    }
  }
</script>

<script>
function toggleReplySecret(id) {
  const btn = document.getElementById("reply_secretToggleBtn_" + id);
  const hidden = document.getElementById("reply_is_secret_" + id);
  const isSecret = hidden.value === "1";

  if (isSecret) {
    btn.src = "images/unlock.png";
    hidden.value = "0";
  } else {
    btn.src = "images/Lock.png";
    hidden.value = "1";
  }
}
</script>

<!-- 이미지 확대용 모달 -->
<div id="imageModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); z-index:10000; justify-content:center; align-items:center;">
  <div id="modalContent" style="position:relative;">
    <!-- 닫기 버튼 -->
    <span id="closeModalBtn"
          style="position:absolute; top:-30px; right:-30px; font-size:40px; color:white; cursor:pointer;">&times;</span>
    <img id="modalImage" src="" style="max-width:90vw; max-height:90vh; border-radius:10px; box-shadow:0 0 20px rgba(0,0,0,0.5);">
  </div>
</div>

<!-- 이미지 확대 스크립트 -->
<script>
function showImageModal(src) {
  const modal = document.getElementById("imageModal");
  const modalImg = document.getElementById("modalImage");
  modalImg.src = src;
  modal.style.display = "flex";
}

// 이벤트는 DOM이 모두 로드된 이후에 연결
document.addEventListener("DOMContentLoaded", function () {
  const modal = document.getElementById("imageModal");
  const closeBtn = document.getElementById("closeModalBtn");

  // 배경 클릭 시 닫기 (이미지 아닌 배경 클릭일 경우에만)
  modal.addEventListener("click", function (e) {
    if (e.target === modal) {
      modal.style.display = "none";
    }
  });

  // X 버튼 클릭 시 닫기
  closeBtn.addEventListener("click", function () {
    modal.style.display = "none";
  });
});
</script>

</body>
</html>
