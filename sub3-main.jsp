<%@ page contentType="text/html;charset=euc-kr" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맞춤다육추천 메인</title>
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
            border: none;
			outline: none;
			margin: 0;
			padding: 0;
        }

		.title {
			font-size: 55px;
			text-align: center;
			font-family: 'GmarketSansTTFMedium';
		}
		.title2 {
			font-size: 24px;
			text-align: center;
			font-family: 'GmarketSansTTFLight';
			margin-top: 45px;
			margin-bottom: 104px;
		}

		.container {
			display: flex;
			justify-content: center;
			align-items: center;
			margin-top: 80px;
			margin-bottom: 104px;
		}
		.box {
			width: 300px;
			height: 300px;
			border: 2px solid #000;
			display: flex;
			justify-content: center;
			align-items: center;
			font-size: 80px;
			font-weight: bold;
			font-family: 'GmarketSansTTFMedium';
		}

		.button {
			display: flex;
			justify-content: center;
			align-items: center;
			height: 80px;
			margin-top: 80px;
		}

		.start {
			width: 380px;
			height: 70px;
			border-radius: 8px;
			background-color: #7ab863;
			border: none;
			color: #fff;
			font-size: 30px;
			font-family: 'GmarketSansTTFMedium';
			cursor: pointer;
		}

	</style>
</head>
<body>
<div class="title">나의 맞춤 다육은 어떤 것일까?</div>

<div class="title2">공간에 어울리고 맞춤인 다육을 추천해 드립니다</div>

<div class="container">
	<img src="images/sub3.png" width="400" height="374" border="0" alt="">
</div>

<div class="button">
	<button class="start" onclick="goToQuestion1()">시작하기</button>
</div>
<script>
    function goToQuestion1() {
        window.location.href = "sub3-Q1.jsp"; // 질문1 페이지로 이동
    }
</script>
</body>
</html>