<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="euc-kr">
  <title>다육탐구생활</title>
  <style>
  	a { text-decoration: none; color: inherit;}
    @font-face { font-family: 'GmarketSansTTFMedium'; src: url('fonts/GmarketSansTTFMedium.ttf') format('truetype'); }
    @font-face { font-family: 'GmarketSansTTFBold'; src: url('fonts/GmarketSansTTFBold.ttf') format('truetype'); }
    @font-face { font-family: 'GmarketSansTTFLight'; src: url('fonts/GmarketSansTTFLight.ttf') format('truetype'); }
    @font-face { font-family: 'RixInooAriDuriPro'; src: url('fonts/RixInooAriDuri_Pro Regular.otf') format('opentype'); font-weight: normal; font-style: normal; }

    .idea-section-wrapper {
      width: 1600px;
      margin: 0 auto;
      background-color: #f1f6ed;
      border-radius: 20px;
      padding: 30px 0;
      box-sizing: border-box;
      margin-left: -30px;
    }
    .board-wrapper { width: 1600px; margin: 0 auto; }
    .board-header-wrapper {
      width: 1400px;
      margin: 0 auto;
      display: flex;
      align-items: center;
      font-size: 28px;
      padding: 30px 40px;
      background-color: white;
      font-family: 'GmarketSansTTFMedium';
    }
    .board-header-wrapper .col-title { flex: 2; padding-left: 40px; }
    .board-header-wrapper .col-views { flex: 1; text-align: center; padding-left: 150px; }
    .board-header-wrapper .col-writer { flex: 1.6; text-align: center; }
    .board-header-wrapper .col-date { flex: 1.2; text-align: center; }

    .board-line {
      width: 1500px;
      height: 2px;
      background-color: #67b54d;
      margin: 0 auto;
    }
    .board-card {
	  display: flex;
	  align-items: center;
	  justify-content: space-between;
	  padding: 30px 40px;
	  box-sizing: border-box;
	  min-height: 200px; /*  높이 고정 */
	}
    .board-card .title-box {
      display: flex;
      align-items: center;
      flex: 2;
      gap: 20px;
      font-size: 32px;
      color: #333;
      padding-left: 20px;
      font-family: 'GmarketSansTTFLight';
    }
    .title-box {
	  font-size: 32px;
	  color: #333;
	  font-family: 'GmarketSansTTFLight';
	  align-items: center;
	  box-sizing: border-box;
	  padding-left: 20px;
	}

	.title-box.with-image {
	  display: flex;
	  gap: 20px;
	}

	.title-box.no-image {
	  display: block;
	}

	.image-box {
	  width: 150px;
	  height: 150px;
	  background-color: #67b54d;
	  overflow: hidden;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	  margin-left: 10px;
	}

	.image-box img {
	  width: 100%;
	  height: 100%;
	  object-fit: cover;
	  display: block;
	}

    .views {
      flex: 0.9;
      text-align: center;
      font-size: 32px;
      font-family: 'GmarketSansTTFMedium';
    }
    .view-count-box {
      background-color: #f5b100;
      color: white;
      border-radius: 20px;
      padding: 9px 15px;
      display: inline-block;
    }
    .writer, .date {
      flex: 1;
      text-align: center;
      font-size: 34px;
      color: #666;
      font-family: 'GmarketSansTTFLight';
    }
	.image-box.no-bg {
	  background-color: transparent !important;
	}

	.pagination {
	width: 250px;
	height: 80px;
	background-color: #f2f7ef;
	border-radius: 43px;
	display: flex;
	gap: 15px;
	justify-content: center;
	align-items: center;
	margin-top: 40px;
}

.page-btn {
	background: none;
	border: none;
	font-size: 30px;
	font-family: 'GmarketSansTTFMedium';
	color: #333;
	cursor: pointer;
	border-radius: 8px;
	transition: 0.2s;
	text-decoration: none;

	width: 60px;
	height: 60px;
	display: inline-flex;
	justify-content: center;
	align-items: center;

	padding: 0;
	line-height: 1;
	box-sizing: border-box;
}

.page-btn.active {
	background-color: #4caf50;
	color: white;
	border-radius: 8px;
}

.page-btn:hover:not(.active) {
	background-color: #e0eed9;
}

.page-btn.disabled {
	pointer-events: none;
	opacity: 0.4;
}

  </style>
</head>
<body>
<div class="board-header-wrapper">
  <div class="col-title">제목</div>
  <div class="col-views">조회수</div>
  <div class="col-writer">작성자</div>
  <div class="col-date">날짜</div>
</div>

<a href="spring.jsp" class="content-link">
<div class="board-wrapper">
  <div class="idea-section-wrapper">
  
    <a href="spring.jsp" class="content-link" style="display: block;">
      <div class="board-card">
        <div class="title-box">
          <div class="title-text">봄</div>
        </div>
        <div class="views"><span class="view-count-box">1</span></div>
        <div class="writer">관리자</div>
        <div class="date">2025.04.09</div>
      </div>
    </a>
    <div class="board-line"></div>

    <a href="summer.jsp" class="content-link" style="display: block;">
      <div class="board-card">
        <div class="title-box">
          <div class="title-text">여름</div>
        </div>
        <div class="views"><span class="view-count-box">13</span></div>
        <div class="writer">관리자</div>
        <div class="date">2025.04.09</div>
      </div>
    </a>
	<div class="board-line"></div>

	<a href="autumn.jsp" class="content-link" style="display: block;">
      <div class="board-card">
        <div class="title-box">
          <div class="title-text">가을</div>
        </div>
        <div class="views"><span class="view-count-box">2</span></div>
        <div class="writer">관리자</div>
        <div class="date">2025.04.09</div>
      </div>
    </a>
    <div class="board-line"></div>

	<a href="winter.jsp" class="content-link" style="display: block;">
      <div class="board-card">
        <div class="title-box">
          <div class="title-text">겨울</div>
        </div>
        <div class="views"><span class="view-count-box">5</span></div>
        <div class="writer">관리자</div>
        <div class="date">2025.04.09</div>
      </div>
    </a>
    <div class="board-line"></div>

</div> <!-- idea-section-wrapper -->
<%
  int currentPage = 1;
  int totalPage = 1; // 현재는 고정이므로 1페이지
%>

<div class="pagination">
  <button class="page-btn disabled">&lt;</button> <!-- 이전 비활성화 -->
  <button class="page-btn active"><%= currentPage %></button> <!-- 현재페이지 -->
  <button class="page-btn disabled">&gt;</button> <!-- 다음 비활성화 -->
</div>
</div> <!-- board-wrapper -->
</body>
</html>
