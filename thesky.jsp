<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>일기 작성</title>
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
    body {
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 82px 150px;
      width: 100%;
      margin: 0 auto;
      margin-bottom: 20px;
    }

    .logo {
      display: block;
      width: 300px;
      height: 56px;
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
    }

    .nav-icons {
      display: flex;
      align-items: center;
      gap: 35px;
    }

    .nav-icons img {
      width: 40px;
      height: 40px;
    }

    .nav-login {
      text-decoration: none;
      font-size: 24px;
      font-family: 'GmarketSansTTFMedium';
      color: black;
    }

    .container {
      background-color: #eef4ea;
      width: 1600px;
      height: 1450px;
      border-radius: 50px;
      padding: 40px;
      box-sizing: border-box;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      align-items: center;
    }

    .white-background {
      background-color: white;
      width: 1500px;
      height: 1300px;
      border-radius: 30px;
      padding: 40px;
      box-sizing: border-box;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      align-items: center;
      margin-top: 30px;
    }

    .header {
      width: 100%;
      background-color: white;
      padding: 20px;
      border-radius: 15px;
      margin-bottom: 0;
    }

    .header .category {
      font-size: 30px;
      color: #60af46;
      margin-bottom: 30px;
      font-family: 'GmarketSansTTFLight';
    }

    .header .title {
      font-size: 40px;
      margin-bottom: 30px;
      font-family: 'GmarketSansTTFBold';
    }

    .header .date {
      font-size: 28px;
      color: #777;
      margin-bottom: 0;
      font-family: 'GmarketSansTTFLight';
    }

    .divider {
      width: 100%;
      height: 3px;
      background-color: #ccc;
      margin-top: 0;
    }

    .content {
      width: 100%;
      height: 700px;
      background-color: white;
      border-radius: 15px;
      padding: 20px;
      font-size: 26px;
      line-height: 1.6;
      box-sizing: border-box;
      text-align: center;
      font-family: 'GmarketSansTTFLight';
      margin-top: 30px;
    }

    .content::placeholder {
      color: #aaa;
    }

    .image-section {
      margin-top: 10px;
      width: 100%;
      text-align: center;
    }

    .image-section img {
      width: 100%;
      max-width: 400px;
      height: auto;
      border-radius: 15px;
    }

    .button-container {
      display: flex;
      gap: 20px;
      margin-top: 150px;
      justify-content: flex-end;
      width: 100%;
      margin-bottom: 30px;
    }

    .btn {
      padding: 15px 40px;
      font-size: 40px;
      background-color: #60af46;
      color: white;
      border: none;
      border-radius: 50px;
      cursor: pointer;
      transition: background-color 0.3s ease;
      font-family: 'GmarketSansTTFBold';
    }

    .btn:hover {
      background-color: #4d9339;
    }

    .footer {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 100%;
      height: 283px;
      padding: 0 150px;
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
      font-family: 'RixInooAriDuriPro';
      margin-left: 35px;
      color: #ffffff;
    }

    .footer-right {
      font-size: 16px;
      color: #ffffff;
      margin-left: 177px;
      font-family: 'GmarketSansTTFLight';
    }

    .footer-right span {
      margin-bottom: 10px;
    }

    .footer-right a {
      text-decoration: none;
      color: #ffffff;
    }

  </style>
</head>
<body>

  

  <div class="container">
    <div class="white-background">
      <div class="header">
        <div class="category">일기</div>
        <div class="title">하늘이</div>
        <div class="date">2025.04.08</div>
      </div>

      <div class="divider"></div>

      <div class="content" contenteditable="true" placeholder="내용을 입력하세요.">
        내용 본가에 있던 하늘이를 집에 데려 왔는데<br> 
        성미인을 처음 발견하고 냄새를 킁킁 맡으면서<br>
        신기한지 앉아서 한참 쳐다봤다.<br>
        다행히 물거나 만지진 않고, 그냥 구경만 했다.<br>
        정말 천재 똑똑 강아지라니까
      </div>

      <div class="image-section">
        <img src="images/4.jpg" alt="삽입된 이미지">
      </div>
    </div>

    <div class="button-container">
      <button class="btn" onclick="deleteContent()">삭제</button>
      <button class="btn" onclick="editContent()">수정</button>
    </div>
  </div>

  

  <script>
    function deleteContent() {
      alert('삭제 버튼 클릭');
      // 여기에 삭제 기능을 구현할 수 있습니다
    }

    function editContent() {
      alert('수정 버튼 클릭');
      // 여기에 수정 기능을 구현할 수 있습니다
    }
  </script>
</body>
</html>
