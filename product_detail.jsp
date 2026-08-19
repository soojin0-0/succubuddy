<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>
<%
    String DB_URL = "jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR";
    String DB_ID = "multi"; 
    String DB_PASSWORD = "abcd";
    String product_id = request.getParameter("product_id");  //  변수명 일관성 유지

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String purchaseQuantityStr = request.getParameter("purchaseQuantity");

    String productName = "";
    String productPrice = "0";  // 초기화
	String productDescription = "";
    int purchaseQuantity = 1;   // 기본값 설정
    int totalAmount = 0;        // 총 금액 초기화 (상단 선언)
    double averageRating = 0.0;
    int reviewCount = 0;

    try {
        if (purchaseQuantityStr != null && !purchaseQuantityStr.isEmpty()) {
            purchaseQuantity = Integer.parseInt(purchaseQuantityStr);
        }

        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD); //  누락된 conn 추가


        // 상품 정보 조회
        String productSql = "SELECT name, price, description FROM product WHERE product_id = ?";
		PreparedStatement productPstmt = conn.prepareStatement(productSql);
		productPstmt.setString(1, product_id);  // 여기서 productId 값이 제대로 들어가는지 확인 필요
		ResultSet productRs = productPstmt.executeQuery();

		if (productRs.next()) {
			productName = productRs.getString("name");
			productPrice = productRs.getString("price");
			productDescription = productRs.getString("description");
	
            // 가격에 콤마 추가
            try {
                productPrice = String.format("%,d", Integer.parseInt(productRs.getString("price")));
            } catch (NumberFormatException e) {
                productPrice = productRs.getString("price");  // 오류 발생 시 원래 값 그대로
            }
        }

        // 총 금액 계산 (상단에 선언한 totalAmount 값 변경)
        totalAmount = Integer.parseInt(productPrice.replace(",", "")) * purchaseQuantity;

        // 리뷰 정보 조회
        String reviewSql = "SELECT AVG(review_score) AS avg_score, COUNT(*) AS review_count FROM review WHERE product_id = ?";
        PreparedStatement reviewPstmt = conn.prepareStatement(reviewSql);
        reviewPstmt.setString(1, product_id);
        ResultSet reviewRs = reviewPstmt.executeQuery();

        if (reviewRs.next()) {
            averageRating = reviewRs.getDouble("avg_score");
            reviewCount = reviewRs.getInt("review_count");
        }

        productRs.close();
        productPstmt.close();
        reviewRs.close();
        reviewPstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<script>
    const productPrice = <%= productPrice.replace(",", "") %>;

    function updateQuantity(change) {
        const quantityInput = document.getElementById('purchaseQuantity');

        // 장바구니 및 구매 폼에 각각 동기화
        const cartQuantityInput = document.getElementById('cartQuantity');
        const buyQuantityInput = document.getElementById('buyQuantity');
        const cartTotalAmountInput = document.getElementById('cartTotalAmount');
        const buyTotalAmountInput = document.getElementById('buyTotalAmount');

        let currentQuantity = parseInt(quantityInput.value);

        // 수량 최소값 제한
        currentQuantity = Math.max(1, currentQuantity + change);

        // 수량 업데이트
        quantityInput.value = currentQuantity;
        cartQuantityInput.value = currentQuantity;
        buyQuantityInput.value = currentQuantity;

        // 총 가격 계산 및 업데이트
        const totalAmount = productPrice * currentQuantity;
        document.getElementById('totalAmount').innerText = totalAmount.toLocaleString() + '원';

        // 폼에 총 금액 동기화
        cartTotalAmountInput.value = totalAmount;
        buyTotalAmountInput.value = totalAmount;
    }

	
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        /* ==============================
            리뷰 모달 관련 기능
        ============================== */
        const modal = document.getElementById("reviewModal");
		const writeReviewBtn = document.querySelector(".open-review-btn"); // <-- 클래스 이름 맞춰야 함
		const closeBtn = document.querySelector(".close-btn");
		const cancelBtn = document.querySelector(".btn-cancel");
        // 모달 열기 (작성하기 버튼 클릭 시)
        if (writeReviewBtn) {
            writeReviewBtn.addEventListener("click", function (event) {
                event.preventDefault(); // 기본 동작 방지
                modal.style.display = "block";
            });
        }

        // 모달 닫기 함수
        function closeReviewModal() {
            modal.style.display = "none";
        }

        // 닫기 버튼(X) 및 취소 버튼 클릭 시 모달 닫기
        if (closeBtn) closeBtn.addEventListener("click", closeReviewModal);
        if (cancelBtn) cancelBtn.addEventListener("click", closeReviewModal);

        // ESC 키를 누르면 모달 닫기
        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") {
                closeReviewModal();
            }
        });

        /* ==============================
            리뷰 별점 선택 기능
        ============================== */
        const stars = document.querySelectorAll(".star");
        const reviewScoreInput = document.getElementById("reviewScore");

        stars.forEach((star, index) => {
            star.addEventListener("click", function () {
                const rating = index + 1; // 별점 (1부터 시작)
                reviewScoreInput.value = rating; // hidden input에 저장

                // 클릭한 별까지 색깔 있는 별(stargreen.png)로 변경
                stars.forEach((s, i) => {
                    s.src = i < rating ? "images/stargreen.png" : "images/starnone.png";
                });
            });
        });

        /* ==============================
            리뷰 작성 시 입력값 확인 및 폼 제출 후 처리
        ============================== */
        const reviewForm = document.getElementById("reviewForm");

        if (reviewForm) {
            reviewForm.addEventListener("submit", function (event) {
                const reviewScore = document.getElementById("reviewScore").value;
                const reviewText = document.getElementById("reviewText").value.trim();
                const reviewPswd = document.querySelector(".password-input input").value.trim();

                // 입력값 검증
                if (reviewScore === "0") {
                    alert("[별점을 선택해 주세요]");
                    event.preventDefault();
                    return;
                }

                if (reviewText === "") {
                    alert("[리뷰 내용을 작성해 주세요]");
                    event.preventDefault();
                    return;
                }

                if (reviewPswd === "") {
                    alert("[비밀번호를 입력해 주세요]");
                    event.preventDefault();
                    return;
                }

                // 부모 페이지 새로고침 및 모달 닫기
                setTimeout(function () {
                    window.opener.location.reload(); // 부모 페이지 새로고침
                    window.close(); // 모달 닫기
                }, 500);
            });
        }
    });

	document.addEventListener("DOMContentLoaded", function () {
        /* ==============================
            모달 관련 기능 (문의)
        ============================== */
        const inquiryModal = document.getElementById("inquiryModal");
		const writeInquiryBtn = document.querySelector(".open-inquiry-btn"); // 작성하기 버튼
		const closeInquiryBtn = document.querySelector("#inquiryModal .close-btn");
		const cancelInquiryBtn = document.querySelector("#inquiryModal .btn-cancel");

        // 모달 열기 (작성하기 버튼 클릭 시)
        if (writeInquiryBtn) {
            writeInquiryBtn.addEventListener("click", function (event) {
                event.preventDefault(); // 기본 동작 방지
                inquiryModal.style.display = "block";
            });
        }

        // 모달 닫기 함수
        function closeInquiryModal() {
            inquiryModal.style.display = "none";
        }

        // 닫기 버튼(X) 및 취소 버튼 클릭 시 모달 닫기
        if (closeInquiryBtn) closeInquiryBtn.addEventListener("click", closeInquiryModal);
        if (cancelInquiryBtn) cancelInquiryBtn.addEventListener("click", closeInquiryModal);

        // ESC 키를 누르면 모달 닫기
        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") {
                closeInquiryModal();
            }
        });

        /* ==============================
            문의 작성 시 입력값 확인
        ============================== */
        const inquiryForm = document.getElementById("inquiryForm");

        if (inquiryForm) {
            inquiryForm.addEventListener("submit", function (event) {
                const inquirySubject = document.getElementById("inquirySubject").value.trim();
                const inquiryText = document.getElementById("inquiryText").value.trim();
                const inquiryPswd = document.querySelector("input[name='inquiryPswd']").value.trim(); // 정확한 선택자 사용

                // 입력값 검증
                if (inquirySubject === "") {
                    alert("문의 제목을 입력해 주세요.");
                    event.preventDefault();
                    return;
                }

                if (inquiryText === "") {
                    alert("문의 내용을 작성해 주세요.");
                    event.preventDefault();
                    return;
                }

                if (inquiryPswd === "") {
                    alert("비밀번호를 입력해 주세요.");
                    event.preventDefault();
                    return;
                }
            });
        }
    });
</script>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상세페이지</title>
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
            width: 100%;
            max-width: 1920px; /* 화면 크기에 맞춰 자동 조정 */
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
		.nav-logout {
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
			margin-top: 109px;
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
		
		/* 설명 */
		.explain {
			margin-top: 100px;
			margin-bottom: 100px;
		}

		.explain p {
			font-size: 24px;
			font-family: 'GmarketSansTTFLight';
			padding-bottom: 10px;
		}

		/* 키우는 방법 */
		.how-to-raise {
			font-family: 'GmarketSansTTFMedium';
			font-size: 28px;
			width: 1440px;
		}
		
		.raise {
			font-family: 'GmarketSansTTFLight';
			font-size: 25px;
			border-collapse: collapse; /* 테두리 겹침 방지 */
			width: 1440px;
			height: 70px;
			margin-top: 20px;
		}
		
		.raise td {
			border-bottom: 1px solid #000;
			width: 120px;
			text-align: center;
			cursor: pointer;
		}

		.raise td:first-child, .raise td:last-child {
			width: 480px;
		}

		.raise td.active {
			color: #7ab863;
		}

		iframe {
			width: 1440px;
			height: 550px;
			border: none;
			margin-top: 80px;
		}

		.set {
			font-family: 'GmarketSansTTFMedium';
			font-size: 28px;
			width: 1440px;
		}

		.type {
			font-family: 'GmarketSansTTFLight';
			font-size: 25px;
			border-collapse: collapse; /* 테두리 겹침 방지 */
			width: 1440px;
			height: 70px;
			margin-top: 20px;
		}

		.type td {
			border-bottom: 1px solid #000;
			width: 33.3%;
			text-align: center;
			cursor: pointer;
		}


		.type td.active2 {
			color: #7ab863;
		}

		/* ==============================
					   리뷰
		============================== */
		.review {
			width: 1100px;
			height: 70px;
			margin-top: 80px;
		}

		.review td:first-child {
			width: 100px;
			font-family: 'GmarketSansTTFMedium';
			font-size: 28px;
		}

		.review td:nth-child(2) {
			width: 100px;
			font-family: 'GmarketSansTTFLight';
			font-size: 20px;
		}
		.review td:last-child {
			font-family: 'GmarketSansTTFLight';
			font-size: 20px;
			text-align: right;
		}

		.detail {
			width: 1100px;
			height: 70px;
			border-collapse: collapse; /* 테두리 겹침 방지 */
		}

		.reviewer {
			display: block; /* 별점과 다른 줄로 정렬 */
			margin-bottom: 10px; /* 간격 10px 추가 */
		}

		.detail td {
			border-bottom: 1px solid #000;
			padding: 10px;
		}
		
		.detail td:first-child {
			font-family: 'GmarketSansTTFMedium';
			font-size: 20px;
			width: 280px;
			padding-left: 20px;
			padding-top: 20px;
		}
		
		.detail img {
			width: 30px;
			height: 30px;
		}

		.detail td:nth-child(2) {	
			font-family: 'GmarketSansTTFLight';
			font-size: 24px;
		}

		.detail td:last-child {
			width: 180px;
			font-family: 'GmarketSansTTFMedium';
			font-size: 20px;
			text-align: right;
			padding-right: 20px;
		}

		/* 별점 스타일 */
		.rating {
			display: flex;
			justify-content: center;
			gap: 5px;
			margin-bottom: 15px;
		}

		.star {
			width: 40px;
			height: 40px;
			cursor: pointer;
		}

		/* 모달 스타일 */
		.modal {
			display: none;
			position: fixed;
			z-index: 1000;
			left: 0;
			top: 0;
			width: 100%;
			height: 100%;
			background-color: rgba(0, 0, 0, 0.5);
			justify-content: center;
			align-items: center;
		}

		.modal-content {
			background-color: #fff;
			width: 600px;
			max-width: 90%;
			height: 900px;
			max-height: 90vh;
			padding: 20px;
			border-radius: 10px;
			text-align: center;
			position: relative;
		}

		/* 닫기 버튼 */
		.close-btn {
			position: absolute;
			top: 10px;
			right: 20px;
			font-size: 28px;
			cursor: pointer;
		}

		.subject {
			font-size: 34px;
			margin-top: 30px;
			margin-bottom: 30px;
			font-family: 'GmarketSansTTFMedium';
		}

		.line {
			width: 450px;
			height: 50px;
			margin: 0 auto;
			border: none;
			border-top: 2px solid #000;
		}

		/* 별점 스타일 */
		.rating {
			display: flex;
			justify-content: center;
			gap: 5px;
			margin-bottom: 30px;
			margin-top: -15px;
		}

		.star {
			width: 40px;
			height: 40px;
			cursor: pointer;
		}

		/* 리뷰 입력 칸 */
		.review-input textarea {
			width: 400px;
			height: 300px;
			font-size: 16px;
			padding: 10px;
			background-color: #f5f5f5;
			border: 1px solid #000;
			resize: none;
			margin-bottom: 20px;
			font-family: 'GmarketSansTTFLight';
			font-size: 22px;
		}

		/* 비밀번호 입력 */
		.password-input input {
			width: 160px;
			height: 32px;
			font-size: 16px;
			padding: 10px;
			border: 1px solid #ccc;
			border-radius: 8px;
			margin-top: 10px;
			text-align: center;
			font-family: 'GmarketSansTTFLight';
		}
		.password-explain p {
			margin-top: 22px;
			font-size: 14px;
			font-family: 'GmarketSansTTFLight';
		}

		.password-explain font {
			color: #7ab863;
			font-weight: bold;
		}

		.rv-explain {
			font-family: 'GmarketSansTTFMedium';
			font-size: 22px;
			margin-bottom: 15px;
			margin-top: 40px;
		}

		.rv-explain font {
			color: #7ab863;
		}

		/* 버튼 스타일 */
		.btn-group {
			margin-top: 20px;
		}

		.btn {
			width: 120px;
			padding: 10px;
			font-size: 18px;
			margin: 5px;
			border-radius: 5px;
			cursor: pointer;
		}

		.btn-cancel {
			background-color: #7ab863;
			color: white;
			border: none;
			font-family: 'GmarketSansTTFLight';
		}

		.btn-confirm {
			background-color: white;
			color: #7ab863;
			border: 1px solid #7ab863;
			font-family: 'GmarketSansTTFLight';
		}

		/* ==============================
					   문의
		============================== */
		.inquiry {
			width: 1100px;
			height: 70px;
			margin-top: 80px;
		}
		.inquiry td:first-child {
			width: 100px;
			font-family: 'GmarketSansTTFMedium';
			font-size: 28px;
		}

		.inquiry td:nth-child(2) {
			width: 100px;
			font-family: 'GmarketSansTTFLight';
			font-size: 20px;
		}
		.inquiry td:last-child {
			font-family: 'GmarketSansTTFLight';
			font-size: 20px;
			text-align: right;
		}
		.inquiry-subject input{
			width: 400px;
			height: 40px;
			border: 1px solid #000;
			background-color: #f5f5f5;
			margin-bottom: 30px;
			font-family: 'GmarketSansTTFLight';
			font-size: 22px;
		}
		.inquiry-input textarea {
			width: 400px;
			height: 300px;
			font-size: 16px;
			padding: 10px;
			background-color: #f5f5f5;
			border: 1px solid #000;
			resize: none;
			margin-bottom: 20px;
			font-family: 'GmarketSansTTFLight';
			font-size: 22px;
		}
		.inquiry-detail {
			width: 1100px;
			height: 70px;
			border-collapse: collapse; /* 테두리 겹침 방지 */
		}

		.inquiry-detail td {
			border-bottom: 1px solid #000;
			padding: 10px;
			height: 90px;
		}
		
		.inquiry-detail td:first-child {
			font-family: 'GmarketSansTTFMedium';
			font-size: 20px;
			width: 280px;
			padding-left: 20px;
			padding-top: 20px;
		}

		.inquiry-detail td:nth-child(2) {	
			font-family: 'GmarketSansTTFLight';
			font-size: 24px;
		}

		.inquiry-detail td:last-child {
			width: 180px;
			font-family: 'GmarketSansTTFMedium';
			font-size: 20px;
			text-align: right;
			padding-right: 20px;
		}

		.noInfo {
			width: 1100px;
			height: 400px;
			border-radius: 10px; /* 모서리 둥글게 */
			border: 3px dashed #7ab863; /* 점선 테두리 적용 */
			padding: 10px;
			display: flex;
			justify-content: center;
			align-items: center;
			text-align: center;
		}

		.noInfo td {
			border: none; /* 개별 테두리 제거 */
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			padding: 20px;
			text-align: center;
		}

		.noInfo td:first-child {
			width: 300px;
		}
		.noInfo td:last-child {
			width: 300px;
		}
		.noInfo img {
			width: 250px;  /* 고정된 너비 */
			height: 250px; /* 고정된 높이 */
			object-fit: cover; /* 이미지 비율 유지하면서 잘 맞춤 */
			display: block;
		}
		/*총 컨테이너*/
		.pay-container {
			display: flex;
			max-width: 1400px;
			margin: 0 auto;
			padding-top: 0px;
			align-items: center;  /* 이미지와 텍스트를 같은 높이에 정렬 */
			gap: 20px;           /* 이미지와 내용 사이 간격 추가 */
			margin-top: 200px;
        }
		/*상품 이미지*/
        .pay-image {
            width: 450px;
            height: auto;
            object-fit: cover;
			margin-top: -350px;
        }
		/*오른쪽 컨테이너*/
        .pay-details {
            margin-left: 100px;
			margin-top: 20px;
        }
		/*다육박스 및 초보로 가능 링크*/
		.pay-path {
            font-size: 28px;
			font-family: 'GmarketSansTTFLight';
            color: #888;
            margin-bottom: 70px;
        }
        .pay-path a {
            text-decoration: none;
            color: #888;
        }

		/*상품 이름 및 가격*/
        .pay-title {
            font-size: 40px;
			margin-bottom: 30px; /* 상품명 아래 간격 추가 */
            font-family: 'GmarketSansTTFBold';
        }
        .pay-price {
            font-size: 30px;
			font-family: 'GmarketSansTTFMedium';
			margin-top: 50px; /* 가격 상단 간격 추가 (이미지와 균형 조정) */
        }

		/*리뷰 및 별점 이미지*/
		.pay-rating {
			display: inline-flex;
			align-items: center;
			margin-left: 460px;
			font-size: 30px;
			font-family: 'GmarketSansTTFMedium';
		}

		.pay-rating img {
			margin-right: 20px;
			width: auto;
			height: auto;
		}

		/*구분선*/
		.pay-divider {
			width: 800;
			height: 2px;
			background-color: #000000;
			margin: 15px 0;
			margin-top: 30px;
			margin-bottom: 40px;
		}
		/*배송비*/
        .pay-delivery {
            margin: 10px 0;
            font-size: 24px;
            color: #888;
			font-family: 'GmarketSansTTFLight';
        }
		.pay-delivery-gap {
			margin-left: 20px; /* 원하는 만큼 간격 조정 */
		}
		/*구매수량*/
        .pay-quantity {
			display: flex;
			align-items: center;
			background-color: #f5f5f5;
			padding: 10px 30px;
			border-radius: 8px;
			width: 790px;
			height: 102px;
			margin-top: 30px;
			margin-bottom: 30px;
		}

		.pay-quantity-label {
			color: #000000;
			font-size: 24px;
			font-family: 'GmarketSansTTFLight';
			margin-right: 335px;
			width: 100px;
		}

		.pay-quantity-box {
			display: flex;
			align-items: center;
			background-color: #fff;
			border: 1px solid #ddd;
			border-radius: 8px;
			overflow: hidden;
		}

		.pay-quantity-btn {
			background-color: #7ab863;
			color: #0000000;
			border: none;
			width: 55px;
			height: 55px;
			cursor: pointer;
			font-size: 24px;
			font-family: 'GmarketSansTTFLight';
			padding-top: 2px;
		}

		.pay-quantity-btn:hover {
			background-color: #7cb342;
		}

		.pay-quantity-input {
			width: 190px;
			height: 50px;
			border: none;
			text-align: center;
			font-size: 24px;
			outline: none;
			font-family: 'GmarketSansTTFLight';
			padding-top: 2px;
		}
		/*총금액*/
         .pay-total {
			display: flex;
			align-items: center;
			color: #7cb342;
			font-size: 38px;
			margin-top:50px; /* 위쪽 여백 추가 */
			font-family: 'GmarketSansTTFMedium';
		}

		.pay-total-label {
			margin-right: 370px; /* "상품합계 금액"과 가격 사이의 간격 추가 */
			color: #000000;
			font-family: 'GmarketSansTTFLight';
		}
		/*장바구니 및 구매 버튼*/
        .pay-buttons {
            margin-top: 62px;
            display: flex;
            gap: 56px;
			padding-left: 100px; 
			margin-bottom: 80px;
	
        }
        .pay-buttons button {
            background-color: #4CAF50;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
			width: 244px;
			height: 61px;
			font-size: 24px;
			font-family: 'GmarketSansTTFLight';
        }
        .pay-buttons .pay-buy {
            background-color: #fff;
            border: 2px solid #4CAF50;
            color: #4CAF50;
			font-size: 24px;
			font-family: 'GmarketSansTTFMedium';
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
         <a href="logout.jsp"><img src="images/logout.png" alt="로그아웃"></a> 
      </div>
   </header>

	 <div class="pay-container">
        <img src="images/<%= product_id %>.jpg" alt="<%= productName %>" class="pay-image">
        <div class="pay-details">
<%
String productId = request.getParameter("product_id");

Connection conCat = null;
PreparedStatement pstmtCat = null;
ResultSet rsCat = null;
int category = 0;

try {
    String DB_URL_cat = "jdbc:mysql://localhost:3306/succu";
    String DB_ID_cat = "multi";
    String DB_PASSWORD_cat = "abcd";

    Class.forName("org.gjt.mm.mysql.Driver");
    conCat = DriverManager.getConnection(DB_URL_cat, DB_ID_cat, DB_PASSWORD_cat);

    String sqlCat = "SELECT category_name FROM species WHERE product_id = ?";
    pstmtCat = conCat.prepareStatement(sqlCat);
    pstmtCat.setString(1, productId);
    rsCat = pstmtCat.executeQuery();

    if (rsCat.next()) {
        category = rsCat.getInt("category_name");
    }

} catch (Exception e) {
    out.println("에러: " + e.getMessage());
} finally {
    if (rsCat != null) try { rsCat.close(); } catch (Exception e) {}
    if (pstmtCat != null) try { pstmtCat.close(); } catch (Exception e) {}
    if (conCat != null) try { conCat.close(); } catch (Exception e) {}
}
%>
<!-- 서브 이동 -->
<div class="pay-path">
	<a href="sub2.jsp">다육 단품</a> &gt;
	<%
		if (category == 1) {
	%>
			<a href="sub2.jsp">소형</a>
	<%
		} else if (category == 2) {
	%>
			<a href="sub2_medium.jsp">중형</a>
	<%
		} else if (category == 3) {
	%>
			<a href="sub2_large.jsp">대형</a>
	<%
		} else {
	%>
			<span>분류없음</span>
	<%
		}
	%>
</div>
			<!--상품 이름-->
            <div class="pay-title"><%= productName %></div>
			<!--가격 및 리뷰 -->
           <div class="pay-price">
				<%= productPrice %>원
				<span class="pay-rating">
					<img src="images/starnone.png" alt="별점" > <%= String.format("%.1f", averageRating) %> | <%= reviewCount %>개
				</span>
			</div>

			<div class="pay-divider"></div>
			<!--배송비-->
            <div class="pay-delivery">
				<span>배송비</span>
				<span class="pay-delivery-gap">3,000원 (50,000원 이상 무료 배송)</span>
			</div>
			<!--수량 버튼-->
            <div class="pay-quantity">
				<span class="pay-quantity-label">구매수량</span>
				<div class="pay-quantity-box">
					<button type="button" class="pay-quantity-btn" onclick="updateQuantity(-1)">-</button>
					<input type="text" id="purchaseQuantity" value="1" min="1" class="pay-quantity-input" readonly>
					<button type="button" class="pay-quantity-btn" onclick="updateQuantity(1)">+</button>
				</div>
			</div>
			<!--총 금액-->
			<div class="pay-total">
				<span class="pay-total-label">상품합계 금액</span>
				<span id="totalAmount"><%= String.format("%,d", totalAmount) %>원</span>
			</div>
            <div class="pay-buttons">
				<!-- 장바구니 버튼 -->
				<form method="POST" action="shopping_list.jsp" style="display: inline;">
					<input type="hidden" name="product_id" value="<%= product_id %>">
					<input type="hidden" id="cartQuantity" name="purchaseQuantity" value="<%= purchaseQuantity %>">
					<input type="hidden" id="cartTotalAmount" name="totalAmount" value="<%= totalAmount %>">
					<button type="submit" class="pay-cart">장바구니</button>
				</form>

				<!-- 구매하기 버튼 -->
				<form method="POST" action="/succu/shopping_order_payment.jsp">
					<input type="hidden" name="products" value="<%= product_id %>">
					<input type="hidden" id="buyQuantity" name="quantities" value="<%= purchaseQuantity %>">
					<input type="hidden" id="buyTotalAmount" name="totalAmount" value="<%= totalAmount %>">
					<input type="hidden" name="type" value="direct"> <%-- 직접구매임을 명시 --%>
					<button type="submit" class="pay-buy">구매하기</button>
				</form>

			</div>

        </div>
    </div>

	<center>
	<div class="explain">
		<%= (productDescription != null && !productDescription.trim().equals("")) 
			? productDescription.replaceAll("([^\\.]+\\.)\\s*", "<p>$1</p>") 
			: "<p>상품 설명이 등록되어 있지 않습니다.</p>" 
		%>
	</div>

	<!-- 키우는 방법 -->
	<div class="how-to-raise">
		<p><b>키우는 방법</b></p>
		<table class="raise">
			<tr>
				<td></td>
				<td onclick="changeRaiseContent(this, 'water.jsp')">물</td>
				<td onclick="changeRaiseContent(this, 'sun.jsp')">빛</td>
				<td onclick="changeRaiseContent(this, 'humidity.jsp')">습도</td>
				<td onclick="changeRaiseContent(this, 'temperature.jsp')">온도</td>
				<td></td>
			</tr>
		</table>
		<iframe id="contentRaise"></iframe>
	</div>

<script>
	const raiseTabs = document.querySelectorAll('.raise td');

	// JSP에서 받은 product_id를 JS 변수로 전달
	const productId = "<%= request.getParameter("product_id") %>";

	function changeRaiseContent(selectedTab, url) {
		raiseTabs.forEach(tab => tab.classList.remove('active'));
		selectedTab.classList.add('active');

		// product_id를 URL에 붙여서 iframe에 전달
		const fullUrl = url + "?product_id=" + productId;
		document.getElementById('contentRaise').src = fullUrl;
	}

	window.onload = function() {
		document.querySelector('.raise td:nth-child(2)').click();
		document.querySelector('.type td:nth-child(2)').click();
	};
</script>

<%
    String toolPage = "";
    if (category == 1) { // 소형
        toolPage = "tool-sub2-small.jsp";
    } else if (category == 2) { // 중형
        toolPage = "tool-sub2-medium.jsp";
    } else if (category == 3) { // 대형
        toolPage = "tool-sub2-large.jsp";
    }
%>

<!-- 구성품 -->
<div class="set">
    <p><b>구성품</b></p>
    <table class="type">
        <tr>
            <td></td>
            <td onclick="changeTypeContent(this, '<%= toolPage %>')">관리도구</td> <!-- 관리도구만 남김 -->
            <td></td>
        </tr>
    </table>
    <iframe id="contentSet"></iframe>
</div>

<script>
    const typeTabs = document.querySelectorAll('.type td');

    function changeTypeContent(selectedTab, url) {
        typeTabs.forEach(tab => tab.classList.remove('active2'));
        selectedTab.classList.add('active2');
        document.getElementById('contentSet').src = url;
    }
</script>



<%

    // 상품 ID가 없는 경우, 리뷰와 문의를 표시하지 않음
    if (product_id == null || product_id.trim().isEmpty()) {
        out.println("<p>상품 정보가 없습니다.</p>");
        return;
    }
%>

<!-- 리뷰 작성 테이블 -->
<table class="review">
    <tr>
        <td>리뷰</td>
        <td><a href="all_review.jsp?product_id=<%= productId %>">더보기</a></td>
        <td><a href="#" class="open-review-btn">작성하기</a></td>
    </tr>
</table>

<!-- 리뷰 작성 모달 -->
<div class="modal" id="reviewModal">
    <div class="modal-content">
        <span class="close-btn">&times;</span>
        <p class="subject">리뷰 작성</p>
        <table class="line">
            <tr><td></td></tr>
        </table>

        <form id="reviewForm" method="post" action="review_process.jsp">
            <input type="hidden" name="product_id" value="<%= request.getParameter("product_id") %>">
            <input type="hidden" id="reviewScore" name="reviewScore" value="0">

            <!-- 별점 -->
            <div class="rating">
                <img src="images/starnone.png" class="star" data-value="1">
                <img src="images/starnone.png" class="star" data-value="2">
                <img src="images/starnone.png" class="star" data-value="3">
                <img src="images/starnone.png" class="star" data-value="4">
                <img src="images/starnone.png" class="star" data-value="5">
            </div>

            <!-- 리뷰 작성 -->
            <div class="review-input">
                <textarea id="reviewText" name="reviewText" placeholder="리뷰를 작성해주세요"></textarea>
            </div>

            <!-- 비밀번호 입력 -->
            <div class="password-input">
                <input type="password" name="reviewPswd" placeholder="비밀번호">
            </div>
            <div class="password-explain">
                <p>글 <font>등록, 수정, 삭제 </font>시에 필요합니다.</p>
            </div>
            <div class="rv-explain">
                <p>작성한 리뷰는 <font>[마이페이지 > 리뷰]</font>에서<br>확인 및 수정이 가능합니다</p>
            </div>

            <!-- 버튼 -->
            <div class="btn-group">
                <button type="button" class="btn btn-cancel">취소</button>
                <button type="submit" class="btn btn-confirm">등록</button>
            </div>
        </form>
    </div>
</div>

<!-- 리뷰 목록 표시 -->
<table class="detail">
<%
    reviewCount = 0;  // 중복 선언 없이 초기화만 수행


    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

        // 최신 4개 리뷰 가져오기
        String reviewSql = "SELECT user_id, review_text, review_score, DATE_FORMAT(review_ymd, '%Y.%m.%d') AS review_date FROM review WHERE product_id = ? ORDER BY review_ymd DESC LIMIT 4";
        pstmt = conn.prepareStatement(reviewSql);
        pstmt.setString(1, product_id);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            reviewCount++;
            String reviewer = rs.getString("user_id");
            String text = rs.getString("review_text");
            int score = rs.getInt("review_score");
            String date = rs.getString("review_date");
%>
		<tr>
			<td>
				<div style="margin-bottom: 10px;"><%= reviewer %></div> <!-- 간격 추가 -->
				<% for (int i = 0; i < score; i++) { %>
					<img src="images/stargreen.png" width="18px" height="18px">
				<% } %>
			</td>
			<td>
				<div style="max-width: 600px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
				    <%= text %>
			    </div>
			</td>
			<td><%= date %></td>
		</tr>

<%
        }

        if (reviewCount == 0) {
%>
	<tr class="noInfo">
		<td>
			<img src="images/productDetail.png">
		</td>
		<td>
			아직 작성된 리뷰가 없습니다.<br>첫 리뷰를 남겨보세요!
		</td>
		<td>
			<img src="images/productDetail.png">
		</td>
	</tr>

<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='3'>리뷰를 불러오는 중 오류 발생: " + e.getMessage() + "</td></tr>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
</table>

<!-- 문의 작성 테이블 -->
<table class="inquiry">
    <tr>
        <td>문의</td>
        <td><a href="all_inquiry.jsp?product_id=<%= product_id %>">더보기</a></td>
        <td><a href="#" class="open-inquiry-btn">작성하기</a></td>
    </tr>
</table>

<!-- 문의 작성 모달 -->
<div class="modal" id="inquiryModal">
    <div class="modal-content">
        <span class="close-btn">&times;</span>
        <p class="subject">문의 작성</p>
        <table class="line">
            <tr><td></td></tr>
        </table>
    
        <form id="inquiryForm" method="post" action="inquiry_process.jsp">
            <input type="hidden" name="product_id" value="<%= request.getParameter("product_id") %>">

            <!-- 문의 제목 -->
            <div class="inquiry-subject">
                <input type="text" id="inquirySubject" name="inquirySubject" placeholder="문의 제목을 입력해주세요">
            </div>

            <!-- 문의 내용 -->
            <div class="inquiry-input">
                <textarea id="inquiryText" name="inquiryText" placeholder="문의 내용을 작성해주세요"></textarea>
            </div>

            <!-- 비밀번호 입력 -->
            <div class="password-input">
                <input type="password" name="inquiryPswd" placeholder="비밀번호">
            </div>
            <div class="password-explain">
                <p>글 <font>등록, 수정, 삭제</font> 시에 필요합니다.</p>
            </div>

            <div class="rv-explain">
                <p>작성한 문의는 <font>[마이페이지 > 문의]</font>에서<br>확인 및 수정이 가능합니다</a>
            </div>
			

            <!-- 버튼 -->
            <div class="btn-group">
                <button type="button" class="btn btn-cancel">취소</button>
                <button type="submit" class="btn btn-confirm">등록</button>
            </div>
        </form>
    </div>
</div>

<!-- 문의 목록 표시 -->
<table class="inquiry-detail">
<%
    int inquiryCount = 0;
    conn = null;
    pstmt = null;
    rs = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

        // 최신 4개 문의 가져오기
        String inquirySql = "SELECT user_id, inquiry_subject, inquiry_text, DATE_FORMAT(inquiry_ymd, '%Y.%m.%d') AS inquiry_date FROM inquiry WHERE product_id = ? ORDER BY inquiry_ymd DESC LIMIT 4";
        pstmt = conn.prepareStatement(inquirySql);
        pstmt.setString(1, product_id);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            inquiryCount++;
            String inquiry_user = rs.getString("user_id");
            String inquiry_subject = rs.getString("inquiry_subject");
            String inquiry_text = rs.getString("inquiry_text");
            String inquiry_date = rs.getString("inquiry_date");
%>
    <tr>
        <td><%= inquiry_user %></td>
		<td>
		  <div style="max-width: 600px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
			<%= inquiry_subject %>
		  </div>
		</td>

        <td><%= inquiry_date %></td>
    </tr>
<%
        }

        if (inquiryCount == 0) {
%>
    <tr class="noInfo">
		<td>
			<img src="images/productDetail.png">
		</td>
		<td>
			아직 작성된 문의가 없습니다.<br>궁금한 점이 있다면 문의해주세요!
		</td>
		<td>
			<img src="images/productDetail.png">
		</td>
	</tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='3'>문의를 불러오는 중 오류 발생: " + e.getMessage() + "</td></tr>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
</table>


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
       <span><a href="footer_policy.jsp">개인정보처리방침</a> | <a href="footer_terms.jsp">이용약관</a></span>
    </div>
</footer>

</body>
</html>