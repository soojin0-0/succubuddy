<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맞춤다육추천 질문4</title>
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
			opacity: 1;
			transition: opacity 0.5s ease-in-out;
        }
		.container {
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
		}
		.Q {
			text-align: center;
			font-size: 24px;
			font-family: 'GmarketSansTTFMedium';
			color: #7ab863;
			margin-bottom: 44px;
		}
		.title {
			text-align: center;
			font-size: 55px;
			font-family: 'GmarketSansTTFMedium';
			margin-bottom: 50px;
		}
		.img-container {
			position: relative;
			width: 100%;
			height: 400px; /* 이미지 높이에 맞춰 조절 */
		}

		.image {
			position: absolute;
			left: 50%;
			transform: translateX(-50%);
		}

		.arrow {
			position: absolute;
			left: calc(50% - 365px - 100px - 200px); /* 중앙에서 365px + 이미지 너비만큼 왼쪽 */
			top: 126px;
		}
		button {
			width: 380px;
			height: 70px;
			background-color: #f5f5f5;
			border: none;
			border-radius: 8px;
			font-size: 24px;
			font-family: 'GmarketSansTTFLight';
			margin-bottom: 20px;
			cursor: pointer;
		}
	</style>
</head>
<body>
<%
request.setCharacterEncoding("euc-kr");

List<String> userAnswers = (List<String>) session.getAttribute("userAnswers");
if (userAnswers == null) userAnswers = new ArrayList<>();

// 뒤로가기일 경우 마지막 답변 제거
if ("true".equals(request.getParameter("back")) && !userAnswers.isEmpty()) {
    userAnswers.remove(userAnswers.size() - 1);
    session.setAttribute("userAnswers", userAnswers);
}

// 답변 선택 시
String answerId = request.getParameter("answer_id");
if (answerId != null) {
    userAnswers.add(answerId);
    session.setAttribute("userAnswers", userAnswers);
    response.sendRedirect("sub3-Q5.jsp");
}
%>


<div class="container">
	<div class="Q">Q4</div>
	<div class="title">어떤 크기를 원하나요?</div>
<div class="img-container">
    <div class="arrow" onclick="location.href='sub3-Q3.jsp?back=true'" style="cursor: pointer;">
        <img src="images/left_arrow.png">
    </div>
    <div class="image">
        <img src="images/sub3_Q4.png">
    </div>
</div>
	<button onclick="submitAnswer(1)">작았으면 좋겠습니다</button>
	<button onclick="submitAnswer(2)">보통이면 좋겠습니다</button>
	<button onclick="submitAnswer(3)">크면 좋겠습니다</button>
</div>

<script>
    function submitAnswer(answerId) {
        window.location.href = "sub3-Q4.jsp?answer_id=" + answerId;
    }
</script>
</body>
</html>