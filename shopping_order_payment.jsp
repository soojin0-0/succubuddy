<%@ page contentType="text/html;charset=euc-kr" session="true" %>
<%@ page import="java.io.*, java.sql.*, java.util.*" %> <%-- java.util.* 추가 --%>

<%
    request.setCharacterEncoding("euc-kr");
    String userId = (String) session.getAttribute("sid");

    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }

	String productId = request.getParameter("productId"); // URL에서 받아오기
	productId = request.getParameter("productId"); // 변수 선언 없이 값만 할당
	if (productId == null || productId.trim().isEmpty()) {
		productId = ""; // 기본값 설정 (예외 방지)
	}


    // DB 연결 정보
    String url = "jdbc:mysql://localhost:3306/succu";
    String dbUser = "multi";
    String dbPassword = "abcd";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 사용자 정보 저장 변수
    String orderName = "", orderPhone1 = "", orderPhone2 = "", orderPhone3 = "";
    String orderMobile1 = "", orderMobile2 = "", orderMobile3 = "";
    String recipientName = "", recipientMobile1 = "", recipientMobile2 = "", recipientMobile3 = "";
    String zipcode = "", roadAddress = "", detailAddress = "";

    // 상품 정보 저장할 리스트
    List<Map<String, String>> orderItems = new ArrayList<>();

    // 쿠폰 정보를 담을 리스트
    List<Map<String, String>> coupons = new ArrayList<>();

    // 전달된 상품 목록을 가져옴
    String type = request.getParameter("type");
    String productIdsParam = request.getParameter("products");
    String quantitiesParam = request.getParameter("quantities");

    if (productIdsParam == null || quantitiesParam == null) {
        return;
    }

    // 상품 ID 및 개수를 배열로 변환
    String[] productIds = productIdsParam.split(",");
    String[] quantities = quantitiesParam.split(",");
	String[] potIds = request.getParameterValues("pot_id");
	String[] potPrices = request.getParameterValues("potPrice");

    if (productIds.length != quantities.length) {
        return;
    }

    int totalPrice = 0;  // 총 결제 금액 초기화
	int userPoints = 0; // 보유 포인트

	String usedPoints = request.getParameter("usedPoints");
	String usedCoupon = request.getParameter("usedCoupon");
	String finalPrice = request.getParameter("finalPrice");

	// 디버깅 출력
	System.out.println("productIds: " + Arrays.toString(productIds));
	System.out.println("quantities: " + Arrays.toString(quantities));
	System.out.println("potIds: " + Arrays.toString(potIds));
	System.out.println("potPrices: " + Arrays.toString(potPrices));

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        // user 테이블에서 로그인한 사용자 정보 가져오기
        String userSql = "SELECT username, phone, mobile_phone, address FROM user WHERE user_id = ?";
        pstmt = conn.prepareStatement(userSql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            orderName = rs.getString("username") != null ? rs.getString("username").trim() : "";

            String[] phoneParts = rs.getString("phone") != null ? rs.getString("phone").trim().split("-") : new String[]{"", "", ""};
            if (phoneParts.length == 3) {
                orderPhone1 = phoneParts[0];
                orderPhone2 = phoneParts[1];
                orderPhone3 = phoneParts[2];
            }

            String[] mobileParts = rs.getString("mobile_phone") != null ? rs.getString("mobile_phone").trim().split("-") : new String[]{"", "", ""};
            if (mobileParts.length == 3) {
                orderMobile1 = mobileParts[0];
                orderMobile2 = mobileParts[1];
                orderMobile3 = mobileParts[2];
            }

            recipientName = orderName;
            recipientMobile1 = orderMobile1;
            recipientMobile2 = orderMobile2;
            recipientMobile3 = orderMobile3;

            String fullAddress = rs.getString("address");
            if (fullAddress != null && !fullAddress.isEmpty()) {
                int firstComma = fullAddress.indexOf(",");
                int lastComma = fullAddress.lastIndexOf(",");

                if (firstComma > 0) {
                    zipcode = fullAddress.substring(0, firstComma).trim();
                }
                if (lastComma > firstComma) {
                    detailAddress = fullAddress.substring(lastComma + 1).trim();
                    roadAddress = fullAddress.substring(firstComma + 1, lastComma).trim();
                } else {
                    roadAddress = fullAddress.substring(firstComma + 1).trim();
                }
            }
        }
        rs.close();
        pstmt.close();

         // 선택된 상품 정보 가져오기
		 for (int i = 0; i < productIds.length; i++) {
			String pid = productIds[i].trim();
			String qty = quantities[i].trim();

			if ("direct".equals(type)) {
				// 직접구매인 경우: product + pot 테이블에서 직접 조회
				String productSql = 
					"SELECT p.product_id, p.name, p.price, ? AS pot_id, po.pot_name, IFNULL(po.extra_price, 0) AS pot_price " +
					"FROM product p LEFT JOIN pot po ON po.pot_id = ? WHERE p.product_id = ?";
				pstmt = conn.prepareStatement(productSql);
				pstmt.setString(1, potIds != null ? potIds[i] : "0");
				pstmt.setString(2, potIds != null ? potIds[i] : "0");
				pstmt.setString(3, pid);
			} else {
				// 장바구니에서 구매하는 경우
				String cartSql =
					"SELECT c.product_id, p.name, p.price, c.pot_id, po.pot_name, IFNULL(po.extra_price, 0) AS pot_price " +
					"FROM cart c " +
					"JOIN product p ON c.product_id = p.product_id " +
					"LEFT JOIN pot po ON c.pot_id = po.pot_id " +
					"WHERE c.user_id = ? AND c.product_id = ?";
				pstmt = conn.prepareStatement(cartSql);
				pstmt.setString(1, userId);
				pstmt.setString(2, pid);
			}


			rs = pstmt.executeQuery();

			if (rs.next()) {
				Map<String, String> item = new HashMap<>();
				item.put("product_id", rs.getString("product_id"));
				item.put("name", rs.getString("name"));
				item.put("price", rs.getString("price"));
				item.put("quantity", qty);
				item.put("pot_id", rs.getString("pot_id"));
				item.put("pot_name", rs.getString("pot_name"));
				item.put("pot_price", rs.getString("pot_price"));

				int itemPrice = rs.getInt("price");
				int potPrice = rs.getInt("pot_price");
				int totalItemPrice = (itemPrice + potPrice) * Integer.parseInt(qty);
				totalPrice += totalItemPrice;

				item.put("item_total", String.valueOf(totalItemPrice));
				orderItems.add(item);
			}

			rs.close();
			pstmt.close();
		}

	
         // 사용 가능한 쿠폰 가져오기 (할인율 % 적용)
		String couponSql = "SELECT coupon_id, coupon_name, discount FROM coupon WHERE user_id = ? AND expiry_date >= CURDATE()";
		pstmt = conn.prepareStatement(couponSql);
		pstmt.setString(1, (String) session.getAttribute("sid"));
		rs = pstmt.executeQuery();

		while (rs.next()) {
			Map<String, String> coupon = new HashMap<>();
			coupon.put("coupon_id", rs.getString("coupon_id"));
			coupon.put("coupon_name", rs.getString("coupon_name"));
			coupon.put("discount", rs.getString("discount")); // 할인율 (예: 10 → 10%)
			coupons.add(coupon);
		}

		 // 현재 사용자의 보유 포인트 조회
		String pointSql = "SELECT points FROM point WHERE user_id = ?";
		pstmt = conn.prepareStatement(pointSql);
		pstmt.setString(1, (String) session.getAttribute("sid"));
		rs = pstmt.executeQuery();

		if (rs.next()) {
			userPoints = rs.getInt("points"); // 사용자의 현재 포인트
		}
        rs.close();
        pstmt.close();

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생: " + e.getMessage() + "');</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="euc-kr">
    <title>결제</title>
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
		.container {
			width: 1400px;
			margin: 60px auto;
			padding-top: 50px;
		}
		
		/* 결제 제목 스타일 */
		h2 {
			font-size: 34px;
			font-family: 'GmarketSansTTFMedium';
			margin-bottom: 20px;
			padding-bottom: 15px;
			border-bottom: 2px solid #666;
		}
		
		.section {
			padding: 30px 0;
			margin-bottom: 20px;
		}

		.section-title {
			font-size: 28px;
			font-family: 'GmarketSansTTFMedium';
			margin-bottom: 100px;
			margin-left: 60px;
		}

		.form-group {
			display: flex;
			align-items: center;
			margin-bottom: 60px;
			margin-left: 65px;
		}

		.form-group label {
			width: 150px;
			font-size: 24px;
			font-family: 'GmarketSansTTFMedium';
		}

		.form-group input,
		.form-group select {
			width: 395px;
			height: 60px;
			padding: 15px;
			border: none;
			border-radius: 8px;
			background-color: #f8f8f8;
			font-family: 'GmarketSansTTFMedium';
			font-size: 22px;
		}
		 /* 이름 입력란의 글자 크기 키우기 */
		.name-input {
			font-size: 24px !important; /* 글자 크기 키우기 */
			height: 69px; /* 입력 칸 높이 조정 */
			padding-left: 26px !important; /* 내부 여백 추가 */
			border-radius: 8px;
			font-family: 'GmarketSansTTFMedium';
			background-color: #f8f8f8;
		}

		.phone-group {
			display: flex;
			align-items: center;
		}

		.phone-group select {
			width: 154px;
			height: 69px;
			text-align: center;
			margin-right: 10px;
			font-size: 24px;
			border-radius: 8px;
			text-align: left;
			padding-top: 18px;
			padding-left: 45px;
			appearance: none;
			-webkit-appearance: none;
			-moz-appearance: none;
			background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="14" height="14"><path d="M5 9l7 7 7-7" stroke="black" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>');
			background-repeat: no-repeat;
			background-position: right 16px center;
			background-size: 28px;
			cursor: pointer;
		}

		.phone-group input {
			width: 154px;
			height: 69px;
			text-align: center;
			margin: 0 10px;
			font-size: 24px;
			box-sizing: border-box;
			padding: 5px;
			min-width: 154px;
			max-width: 154px;
			transition: none;
			background-color: #f8f8f8 !important;
			-webkit-text-fill-color: #000 !important;
			transition: background-color 5000s ease-in-out 0s;
		}

		.phone-group input:focus {
			font-size: 24px;
			outline: none;
		}

		.separator {
			display: inline-block;
			width: 28px;
			height: 2px;
			margin-left: 22px;
			margin-right: 20px;
			background-color: black;
			vertical-align: middle;
		}

		.btn {
			background-color: #7ab863;
			color: white;
			padding: 12px 24px;
			border: none;
			border-radius: 5px;
			cursor: pointer;
			font-size: 20px;
		}

		/* 주소 입력 그룹 스타일 */
		.address-group {
			display: flex;
			flex-direction: column;
			align-items: flex-start;
			gap: 20px;
			margin-top: 10px;
			margin-left: 16px;
			font-family: 'GmarketSansTTFMedium';
			width: 100%;
		}

		/* 주소 입력 필드 스타일 */
		.address-group input {
			padding: 10px;
			border: none;
			border-radius: 8px;
			background-color: #f8f8f8;
			font-size: 24px;
			flex-grow: 1;
			height: 69px;
			width: 100%;
			padding-left: 25px;
		}

		/* 전체 주소 입력 컨테이너 */
		.address-container {
			display: flex;
			flex-direction: column;
			gap: 5px;
		}

		/* 우편번호 및 검색 버튼을 포함하는 상단 행 */
		.address-top {
			display: flex;
			align-items: center;
			gap: 10px; 
		}

		/* 우편번호 필드 크기 조정 */
		.small-input {
			width: 277px;
			height: 69px;
			padding: 8px;
			border: none;
			border-radius: 8px;
			background-color: #f8f8f8;
			font-size: 20px;
		}

		/* 주소 검색 버튼 크기 */
		.search-btn {
			width: 160px;
			height: 69px;
			background-color: #f8f8f8;
			border: none;
			padding-top: 3px;
			margin-left: 10px;
			border-radius: 8px;
			cursor: pointer;
			font-size: 18px;
			font-family: 'GmarketSansTTFMedium';
		}
		/* 도로명 주소 & 상세 주소 크기 조정 */
		.large-input {
			width: 800px !important;
			height: 69px !important;
			padding: 10px;
			border: none;
			border-radius: 8px;
			background-color: #f8f8f8;
			font-size: 18px;
		}
		/* 입력란 클릭 시 검은색 테두리 제거 */
		.small-input:focus,
		.large-input:focus,
		.name-input:focus { /* 이름 입력란 추가 */
			outline: none !important; /* 검은색 테두리 제거 */
			border: none !important; /* 기존 테두리 유지 */
			background-color: #f8f8f8 !important; /* 배경색 변경 방지 */
			-webkit-box-shadow: none !important; /* 크롬, 사파리 기본 효과 제거 */
			-moz-box-shadow: none !important; /* 파이어폭스 기본 효과 제거 */
			box-shadow: none !important; /* 기본 효과 제거 */
		}

		 /* 배송 요청사항 드롭다운 스타일 */
		.delivery-select {
			width: 981px !important;
			height: 100px !important;
			padding-left: 30px !important;
			margin-left: 20px;
			border: none;
			border-radius: 8px;
			background-color: #f8f8f8;
			font-size: 24px;
			appearance: none; /* 기본 화살표 제거 */
			-webkit-appearance: none;
			-moz-appearance: none;
			background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="14" height="14"><path d="M5 9l7 7 7-7" stroke="black" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>'); 
			background-repeat: no-repeat;
			background-position: right 20px center;
			background-size: 28px;
			cursor: pointer;
		}

		/* 드롭다운 선택 시 스타일 */
		.delivery-select:focus {
			outline: none;
			box-shadow: none;
		}
		/* 주문 상품 전체 컨테이너 */
		.order-product {
			display: flex;
			align-items: center;
			gap: 45px;
			margin-left: 100px;
			margin-bottom: 40px; /* 추가: 아래쪽 간격 조정 */
		}

		/* 상품 이미지 스타일 */
		.product-image {
			width: 180px;
			height: 180px;
			object-fit: cover;
			margin-left: 20px;
		}

		/* 상품 정보 컨테이너 (양쪽 정렬) */
		.product-info {
			display: flex;
			justify-content: space-between; /* 왼쪽: 상품명, 오른쪽: 가격 & 개수 */
			align-items: center;
			width: 960px;
		}
		/*화분 및 상품정보 */
		.product-name-pot {
			display: flex;
			flex-direction: column;
			align-items: flex-start; /* 왼쪽 정렬 */
			gap: 6px;  /* 글씨 사이 적당히 띄우기 */
			margin-bottom: 5px;
		}
		/*화분 명칭*/
		.product-pot {
			font-size: 18px;
			color: #333;
			margin-top: 7px;
			font-family: 'GmarketSansTTFMedium';
		}

		/* 상품명 (왼쪽 정렬) */
		.product-name {
			flex-grow: 1;  /* 남은 공간 차지 */
			text-align: left;
			font-size: 30px;
			gap: 10px;
			color: #333;
			font-family: 'GmarketSansTTFLight';
		}

		/* 가격과 개수 컨테이너 (오른쪽 정렬) */
		.price-quantity-container {
			display: flex;
			align-items: center;
			gap: 10px; /* 가격과 개수 사이 간격 */
			text-align: right;
			font-family: 'GmarketSansTTFMedium';
		}

		/* 가격 스타일 */
		.product-price {
			font-size: 22px;
			color: #7ab863; /* 초록색 */
			margin-right: 2px; /* 개수와의 간격 조정 */
		}

		/* 개수 스타일 */
		.product-quantity {
			font-size: 22px;
			color: black;
			margin-right: 10px;
		}
		/* 주문 상품 가격과 개수를 구분하는 세로 선 */
		.product-divider {
			width: 2px;
			height: 20px; /* 텍스트 높이에 맞춰 조정 */
			background-color: #666;
			margin: 0 10px; /* 가격과 개수 사이 여백 */
		}
		/*결제 요약 박스*/
		.payment-container {
			display: flex;
			justify-content: space-between;
			align-items: flex-start;
			gap: 20px; /* 기존 50px → 20px로 줄이기 */
			width: 1100px;
			margin: 0 30px; /* 가운데 정렬 */
		}

		/*  왼쪽 컨텐츠 (쿠폰/포인트 + 결제수단) */
		.left-section {
			flex: 1;
			max-width: 500px;
			margin-left: 60px;
		}

		/* 왼쪽 타이틀 스타일 */
		.left-title {
			font-size: 26px;
			color: black;
			margin-bottom: 50px; /* 너무 벌어지지 않도록 조정 */
			display: block;
			font-family: 'GmarketSansTTFMedium';
		}

		/*  쿠폰/포인트 영역 정렬 */
		.coupon-section, .point-section {
			display: flex;
			flex-direction: column;
			align-items: flex-start;
			margin-bottom: 20px;
		}

		/*  쿠폰 선택 드롭다운 위치 조정 */
		.coupon-section {
			margin-top: 15px; /* 위쪽 여백 추가 */
			display: flex;
			flex-direction: column;
			align-items: flex-start;
		}

		/* 쿠폰 선택 드롭다운 */
		.coupon-select {
			width: 534px;
			height: 70px; /* 크기 키움 */
			border: none;
			margin-top: 25PX;
			margin-bottom: 30px; 
			border-radius: 8px; /* 둥글게 */
			padding: 10px;
			font-size: 18px;
			padding-left: 25px;
			font-family: 'GmarketSansTTFLight';
			background-color: #f8f8f8; /* 배경색 추가 */
			
			/* 화살표 아이콘 추가 */
			background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24"><path d="M7 10l5 5 5-5" stroke="%23000" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>');
			background-repeat: no-repeat;
			background-position: right 20px center;
			background-size: 45px;

			appearance: none; /* 기본 화살표 제거 */
			-webkit-appearance: none;
			-moz-appearance: none;
		}
		/* 쿠폰 개수 표시 */
		.coupon-text {
			font-size: 24px; /* 글씨 크기 키우기 */
			color: #333; /* 색상 변경 */
			font-family: 'GmarketSansTTFLight';
			 
		}
		/* 포인트 입력 영역 */
		.point-input {
			display: flex;
			align-items: center;
			background-color: #f8f8f8;
			border-radius: 8px;
			width: 534px;
			height: 70px;
			padding-left: 25px; /* 왼쪽 여백 */
			margin-top: 30px;
			margin-bottom: 50px;
		}
		/* 포인트 입력 칸 */
		.point-input input {
			flex-grow: 1; /* 입력 칸이 최대한 넓어지도록 설정 */
			height: 100%;
			border: none;
			background-color: transparent;
			font-size: 18px;
			font-family: 'GmarketSansTTFLight';
			color: #666;
		}

		/* 입력 칸 포커스 시 스타일 */
		.point-input input:focus {
			outline: none;
		}
		/* 포인트 보유 표시 */
		.point-text {
			font-size: 24px; /* 글씨 크기 키우기 */
			color: #333; /* 색상 변경 */
			font-family: 'GmarketSansTTFLight';
		}
		/* 버튼 (모두사용) */
		.apply-btn {
			background-color: #7ab863;
			color: white;
			border: none;
			width: 90px; /* 버튼 너비 고정 */
			height: 100%;
			font-size: 16px;
			border-top-right-radius: 8px;
			border-bottom-right-radius: 8px;
			cursor: pointer;
			display: flex;
			align-items: center;
			justify-content: center;
		}

		/* 버튼 호버 효과 */
		.apply-btn:hover {
			background-color: #6aa75c;
		}
		/* 결제 수단 전체 영역 */
		.payment-methods-container {
			display: flex;
			flex-direction: column; /* 세로 정렬 */
			align-items: flex-start; /*  왼쪽 정렬 */
			padding-top: 20px;
			margin-top: 30px;
		}
		/*  결제수단 선택 상단 구분선 (길이 늘리기) */
		.payment-divider {
			width: 750px; /*  전체 너비로 설정 */
			height: 2px;
			background-color: #666;
			margin-bottom: 20px;
		}
		/*  결제수단 제목 */
		.payment-methods-container .left-title {
			font-size: 26px;
			color: black;
			margin-bottom: 50px; /* 너무 벌어지지 않도록 조정 */
			display: block;
			font-family: 'GmarketSansTTFMedium';
		}
		/* 결제수단 선택 */
		.payment-methods {
			display: flex;
			align-items: center;
			gap: 50px; /* 기존 간격 유지 */
			flex-wrap: nowrap; /*  줄바꿈 방지 */
			white-space: nowrap; /*  줄바꿈 방지 */
		}
		/* 라디오 버튼 숨기기 */
		.payment-methods input[type="radio"] {
			display: none;
		}
		/*  결제 수단 선택 버튼 정렬 문제 해결 */
		.payment-options {
			display: flex;
			gap: 15px; /* 라디오 버튼과 글씨 간격 */
			align-items: center; /* 세로 정렬 맞추기 */
		}
		/* 커스텀 라디오 버튼 스타일 */
		.payment-methods label {
			display: flex;
			align-items: center; /* 수직 정렬 */
			gap: 10px; /* 간격 */
			cursor: pointer;
			font-size: 26px;
			color: #333;
			font-family: 'GmarketSansTTFLight';
		}

		/* 라디오 버튼 앞의 원 스타일 */
		.payment-methods label::before {
			content: "";
			display: inline-block;
			width: 26px;
			height: 26px;
			border-radius: 50%;
			border: 4px solid #f0f0f0; /* 기본 회색 테두리 */
			background-color: #f0f0f0;
			transition: all 0.3s ease;
		}

		/* 선택된 라디오 버튼 스타일 */
		.payment-methods input[type="radio"]:checked + label::before {
			border-color: #7ab863; /* 초록색 테두리 */
			background-color: #7ab863;
		}
		.payment-methods label {
			padding-left: 10px; /* 왼쪽 간격 추가 */
		}
		/*  결제 요약 박스를 오른쪽으로 이동 */
		.right-section {
			max-width: 550px; /* 기존 크기 유지 */
			margin-left: 685px; /* 자동으로 오른쪽 정렬 */
			margin-right: 50px; /* 오른쪽 마진 추가 */
			margin-top: -665px;
		}


		.summary-box {
			width: 575px; /* 너비 조정 */
			height:760px;
			background-color: #f7f7f7; /* 배경색 추가 */
			padding: 35px; /* 내부 여백 추가 */
			padding-top: 20px;
			margin-left: 100px;
			position: relative; /* 기준이 되는 박스 */
		}

		.payment-summary h3 {
			font-size: 18px;
			font-weight: bold;
			margin-bottom: 20px;
		}

		.summary-item {
			display: flex;
			justify-content: space-between;
			font-size: 26px;
			font-weight: 500;
			padding: 15px 10px;
			margin-top: 14px;
			font-family: 'GmarketSansTTFLight';
		}

		.summary-divider {
			width: 480px;
			height: 1px;
			background-color: #000000;
			margin: 15px 6px;
			margin-top: 25px;
			margin-bottom: 25px;
		}

		.discount-detail {
			display: flex;
			justify-content: space-between;
			align-items: center;
			flex-direction: column;
			gap: 15px; /* 항목 간격 조정 */
			padding: 5px 15px; /* 내부 여백 */
			font-size: 16px;
			color: #666;
			font-family: 'GmarketSansTTFLight';
		}
		.discount-row {
			display: flex;
			justify-content: space-between;
			align-items: center;
			font-size: 22px;
			font-weight: 500;
			gap: 10px;
			color: #000000;
			width: 100%;
			padding: 6px 0;
		}

		.discount-row span:first-child {
			text-align: left;
			padding-left: 55px;
		}

		.discount-row span:last-child {
			text-align: right;
			flex-grow: 1; /* 가격을 오른쪽으로 밀어냄 */
		}
		.total {
			font-size: 26px;
			font-family: 'GmarketSansTTFLight';
		}

		.btn-payment {
			width: 100%; /* 버튼 크기를 박스 너비에 맞추기 */
			height: 147px;
			background-color: #7ab863;
			color: white;
			font-size: 32px;
			border: none;
			border-radius: 0 0 8px 8px;
			cursor: pointer;
			margin-top: auto; /* 자동으로 아래쪽으로 정렬 */
			position: absolute;
			bottom: 0; /* 박스의 아래쪽에 붙이기 */
			left: 0;
			font-family: 'GmarketSansTTFBold';
		}
		.btn-payment:hover {
			background-color: #6aa852;
		}
		/* 중앙 구분선 스타일 */
		.divider {
			width: 1400px;
			height: 2px;
			background-color: #666;
			margin: 40px 0;
		}
		/* 주문 상품 사이의 짧은 구분선 */
		.short-divider {
			width: 740px;  /* 짧은 선 길이 */
			height: 2px;
			background-color: #666;
			margin: 10px 0 60px 0; /* 위 여백 10px, 아래 여백 30px */
			position: relative;
			bottom: -10px; /* 살짝 내려서 상품 아래로 조정 */
			position: relative; /* 새로운 선의 기준이 됨 */
		}

		/* 할인 금액이 보이지 않는 문제 해결 */
		#coupon-discount, #point-discount, #total-discount, #final-price {
			visibility: visible !important;
			display: inline-block !important;
			color: black !important;  /* 색상이 다르게 적용될 가능성 제거 */
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
   </style>
	
</head>
	<script>
		document.addEventListener("DOMContentLoaded", function () {
			let totalPriceElement = document.getElementById("total-price"); // 총 상품 금액
			let couponSelect = document.getElementById("coupon-select"); // 쿠폰 선택
			let pointInput = document.getElementById("pointInput"); // 포인트 입력창
			let applyAllPointsBtn = document.querySelector(".apply-btn"); // 포인트 모두 사용 버튼

			let finalPriceElement = document.getElementById("final-price"); // 최종 결제 금액
			let totalDiscountElement = document.getElementById("total-discount") || document.getElementById("discount-amount");
			let couponDiscountElement = document.getElementById("coupon-discount") || document.getElementById("coupon-amount");
			let pointDiscountElement = document.getElementById("point-discount") || document.getElementById("point-amount");
			let shippingFeeElement = document.getElementById("shipping-fee"); // 배송비

			let totalPrice = parseInt(totalPriceElement.getAttribute("data-original-price")) || 0; // 총 상품 금액
			let userPoints = <%= userPoints %>; // 사용자의 보유 포인트
			let shippingFee = 0; // 기본 배송비

			// **이벤트 리스너 추가**
			couponSelect.addEventListener("change", updateTotalDiscount);
			pointInput.addEventListener("input", updateTotalDiscount);
			applyAllPointsBtn.addEventListener("click", function () {
				let maxPoints = getMaxUsablePoints();
				pointInput.value = maxPoints.toLocaleString(); // 천 단위 콤마 추가
				updateTotalDiscount();
			});

			function updateTotalDiscount() {
				let couponDiscount = getCouponDiscount(); // 쿠폰 할인 금액
				let pointDiscount = getPointDiscount(); // 포인트 할인 금액

				// NaN 방지: 만약 NaN이면 0으로 설정
				couponDiscount = isNaN(couponDiscount) ? 0 : couponDiscount;
				pointDiscount = isNaN(pointDiscount) ? 0 : pointDiscount;

				let totalDiscount = couponDiscount + pointDiscount; // 총 할인 금액
				let finalPrice = totalPrice - totalDiscount + shippingFee; // 최종 결제 금액

				if (finalPrice < 0) finalPrice = 0; // 결제 금액이 0 이하가 되지 않도록 조정

				console.log(`쿠폰 할인: ${couponDiscount} | 포인트 할인: ${pointDiscount} | 총 할인: ${totalDiscount} | 최종 결제: ${finalPrice}`);

				// 쿠폰 또는 포인트가 선택되었을 때만 - 부호 추가
				if (totalDiscountElement) {
					totalDiscountElement.innerText = totalDiscount > 0 ? "- " + totalDiscount.toLocaleString() + " 원" : "0 원";
				}
				if (couponDiscountElement) {
					couponDiscountElement.innerText = couponDiscount > 0 ? "- " + couponDiscount.toLocaleString() + " 원" : "0 원";
				}
				if (pointDiscountElement) {
					pointDiscountElement.innerText = pointDiscount > 0 ? "- " + pointDiscount.toLocaleString() + " 원" : "0 원";
				}
				 
				 // 최종 결제 금액 업데이트
				 finalPriceElement.innerText = finalPrice.toLocaleString() + " 원";
			}

			function getCouponDiscount() {
				let selectedCoupon = couponSelect.options[couponSelect.selectedIndex];

				if (!selectedCoupon || selectedCoupon.value === "0") {
					return 0; // 쿠폰 선택 안했을 경우 0원 반환
				}

				let discountRate = parseInt(selectedCoupon.getAttribute("data-discount")) || 0;
				let discountAmount = Math.floor(totalPrice * (discountRate / 100)); // 할인율 적용

				console.log(`쿠폰 할인 적용: ${discountAmount}`);
				return discountAmount;

			}

			function getPointDiscount() {
				let enteredPoints = pointInput.value.replace(/,/g, "").trim();
				if (enteredPoints === "" || isNaN(enteredPoints)) return 0; // 입력값이 없거나 NaN이면 0 처리

				let usedPoints = parseInt(enteredPoints) || 0;
				return Math.min(userPoints, usedPoints); // 보유 포인트 내에서 사용 가능
			}

			function getMaxUsablePoints() {
				let couponDiscount = getCouponDiscount();
				return Math.min(userPoints, totalPrice - couponDiscount);
			}

			// **페이지 로드 후 즉시 실행**
			updateTotalDiscount();
		});
		
		// 결제 버튼 이벤트 처리
		document.addEventListener("DOMContentLoaded", function () {
			let paymentButton = document.getElementById("paymentButton");
			let paymentForm = document.getElementById("paymentForm");

			if (paymentButton && paymentForm) {
				paymentButton.addEventListener("click", function (event) {
					const selected = document.querySelector('input[name="paymentMethod"]:checked');
					if (!selected) {
						alert("결제 수단을 선택하세요.");
						return;
					}

					const paymentMethod = selected.value;
					document.getElementById("payment-method").value = paymentMethod;

					const couponSelect = document.getElementById("coupon-select");
					const couponValue = couponSelect?.value || "";
					document.getElementById("usedCoupon").value = couponValue;

					const pointInput = document.getElementById("pointInput");
					const usedPoints = pointInput ? pointInput.value.replace(/,/g, "") : "0";
					document.getElementById("usedPoints").value = usedPoints;

					const finalPriceElement = document.getElementById("final-price");
					const finalPrice = finalPriceElement ? finalPriceElement.innerText.replace(/,/g, "").replace(" 원", "") : "0";
					document.getElementById("final-price-input").value = finalPrice;

					const discountAmountElement = document.getElementById("discount-amount") || document.getElementById("total-discount");
					const discountAmount = discountAmountElement ? discountAmountElement.innerText.replace(/,/g, "").replace(" 원", "") : "0";
					document.getElementById("discount-amount-input").value = discountAmount;

					console.log("결제 수단:", paymentMethod);
					console.log("사용된 쿠폰:", couponValue);
					console.log("사용된 포인트:", usedPoints);
					console.log("총 할인 금액:", discountAmount);
					console.log("최종 결제 금액:", finalPrice);

					event.preventDefault();

					if (paymentMethod === "카카오페이") {
						const formData = new FormData(paymentForm);
						const params = new URLSearchParams(formData).toString();
						location.href = "kakao_ready.jsp?" + params;
					} else {
						paymentForm.submit();
					}
				});
			}
		});


	</script>

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

    <div class="container">
        <h2>결제</h2>
       <form id="paymentForm" action="save_payment.jsp" method="post">
		<!-- 선택한 상품 정보 -->
		<input type="hidden" name="product_ids" value="<%= productIdsParam %>">
		<input type="hidden" name="quantities" value="<%= quantitiesParam %>">

		 <input type="hidden" id="payment-method" name="payment_method"> <!-- 자동 설정 -->
		<input type="hidden" id="usedCoupon" name="usedCoupon">
		<input type="hidden" id="usedPoints" name="usedPoints" value="0">
		<input type="hidden" id="final-price-input" name="finalPrice">
		<input type="hidden" id="discount-amount-input" name="discountAmount" value="0">

   



            <div class="section">
                <div class="section-title">주문고객정보</div>
                <div class="form-group">
                    <label for="order-name">이름</label>
                     <input type="text" id="order-name" class="name-input" name="order_name" required value="<%= orderName %>">
                </div>
                <div class="form-group">
                    <label>전화</label>
                    <div class="phone-group">
                        <select name="order_phone1">
                            <option value="02" <%= "02".equals(orderPhone1) ? "selected" : "" %>>02</option>
                            <option value="031" <%= "031".equals(orderPhone1) ? "selected" : "" %>>031</option>
                            <option value="032" <%= "032".equals(orderPhone1) ? "selected" : "" %>>032</option>
							<option value="034" <%= "034".equals(orderPhone1) ? "selected" : "" %>>034</option>
							<option value="041" <%= "041".equals(orderPhone1) ? "selected" : "" %>>041</option>
                        </select>
                        <div class="separator"></div>
                        <input type="text" name="order_phone2" required value="<%= orderPhone2 %>">
                        <div class="separator"></div>
                        <input type="text" name="order_phone3" required value="<%= orderPhone3 %>">
                    </div>
                </div>
				<div class="form-group">
                    <label>휴대전화</label>
                    <div class="phone-group">
                        <select name="recipient_mobile1">
                            <option value="010" <%= "010".equals(recipientMobile1) ? "selected" : "" %>>010</option>
                            <option value="011" <%= "011".equals(recipientMobile1) ? "selected" : "" %>>011</option>
                        </select>
                        <div class="separator"></div>
                        <input type="text" name="recipient_mobile2" required value="<%= recipientMobile2 %>">
                        <div class="separator"></div>
                        <input type="text" name="recipient_mobile3" required value="<%= recipientMobile3 %>">
                    </div>
                </div>
            </div>

            <div class="divider"></div>

            <div class="section">
                <div class="section-title">배송지정보</div>
                <div class="form-group">
                    <label for="shipping-name">이름</label>
                    <input type="text" id="shipping-name" class="name-input" name="recipient_name" required value="<%= recipientName %>">
                </div>
                <div class="form-group">
                    <label>휴대전화</label>
                    <div class="phone-group">
                        <select name="recipient_mobile1">
                            <option value="010" <%= "010".equals(recipientMobile1) ? "selected" : "" %>>010</option>
                            <option value="011" <%= "011".equals(recipientMobile1) ? "selected" : "" %>>011</option>
                        </select>
                        <div class="separator"></div>
                        <input type="text" name="recipient_mobile2" required value="<%= recipientMobile2 %>">
                        <div class="separator"></div>
                        <input type="text" name="recipient_mobile3" required value="<%= recipientMobile3 %>">
                    </div>
                </div>
                <div class="form-group">
					<label>주소</label>
					<div class="address-group">
						<div class="address-top">
							<input type="text" id="zipcode" class="small-input" name="zipcode" required value="<%= zipcode %>">
							<button type="button" class="search-btn" onclick="searchPostalCode()">주소검색</button>
						</div>
						<input type="text" id="road-address" class="large-input" name="road_address" required value="<%= roadAddress %>">
						<input type="text" id="detail-address" class="large-input" name="detail_address" required value="<%= detailAddress %>">
					</div>
				</div>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function searchPostalCode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById("zipcode").value = data.zonecode;
								document.getElementById("road-address").value = data.roadAddress;
								document.getElementById("detail-address").focus();
							}
						}).open();
					}
				</script>
            <div class="divider"></div>

			<div class="section">
				<div class="section-title">배송요청사항</div>
				<div class="form-group">
					<select id="delivery-request" class="delivery-select" name="delivery_request">
						<option value="">선택해주세요</option>
						<option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
						<option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
						<option value="배송 전 연락 부탁드립니다">배송 전 연락 부탁드립니다</option>
						<option value="직접 받고 싶습니다">직접 받고 싶습니다</option>
					</select>
				</div>
			</div>

			<div class="divider"></div>

			<!-- 주문 상품 정보 출력 -->
			<div class="section">
				<div class="section-title">주문 상품 정보</div>

				<% if (orderItems.isEmpty()) { %>
					<p style="font-size: 20px; color: red;">선택한 상품이 없습니다.</p>
				<% } else {
					for (Map<String, String> item : orderItems) {
						//int itemPrice = Integer.parseInt(item.get("price"));
						//int quantity = Integer.parseInt(item.get("quantity"));
						//int totalItemPrice = itemPrice * quantity;

						int itemPrice = Integer.parseInt(item.get("price"));
						int potPrice = 0;
						if (item.get("pot_price") != null && !item.get("pot_price").equals("")) {
							potPrice = Integer.parseInt(item.get("pot_price"));
						}
						int itemTotalPrice = (itemPrice + potPrice) * Integer.parseInt(item.get("quantity"));
				%>
					<div class="order-product">
						<!-- 상품 이미지 -->
						<img src="images/<%= item.get("product_id") %>.jpg"
							onerror="this.onerror=null;"
							class="product-image"
							alt="<%= item.get("name") %>">

						<!-- 상품 정보 -->
						<div class="product-info">
							<div class="product-name-pot">
								<p class="product-name"><%= item.get("name") %></p>
								<p class="product-pot">
									화분 | <%= item.get("pot_name") != null ? item.get("pot_name") : "선택안함" %>
								</p>
							</div>
						<!-- 가격 및 개수 -->
						<div class="price-quantity-container">
							<span class="product-price"><%= String.format("%,d", itemPrice + potPrice) %> 원</span>
							<div class="product-divider"></div>
							<span class="product-quantity"><%= item.get("quantity") %> 개</span>
						</div>
					</div>
				</div>
				<% 
					}} 
				%>
			</div>

			<div class="short-divider"></div>

			<!--  왼쪽: 쿠폰/포인트 & 결제수단 -->
			<div class="left-section">
				<!-- 쿠폰 선택 -->
				<div class="coupon-point">
					<span class="left-title">쿠폰/포인트</span>
					<div class="coupon-section">
						<span class="coupon-text">쿠폰 | <%= coupons.size() %> 개</span>
						<select id="coupon-select" class="coupon-select" name="usedCoupon">
							<option value="0" data-discount="0">쿠폰 선택</option>
							<% for (Map<String, String> coupon : coupons) { %>
								<option value="<%= coupon.get("coupon_id") %>" data-discount="<%= coupon.get("discount") %>">
									<%= coupon.get("coupon_name") %>
								</option>
							<% } %>
						</select>
					</div>
					</div>

					<!-- 보유 포인트 표시 및 입력 폼 -->
					<div class="point-section">
						<span class="point-text">포인트 | 보유 포인트 <span id="userPoints"><%= userPoints %>P</span></span>
						<div class="point-input">
							<input type="text" id="pointInput" placeholder="포인트 입력">
							<button type="button" class="apply-btn">모두 사용</button>
						</div>
					</div>

				</div>
				
				<div class="payment-divider"></div> <!--  선 추가 -->

				<!--  결제수단 -->

				<div class="payment-methods-container">
					<span class="left-title">결제수단 선택</span>
					<div class="payment-methods">
						<input type="radio" name="paymentMethod" value="신용카드" id="credit">
						<label for="credit">신용카드</label>

						<input type="radio" name="paymentMethod" value="무통장" id="bank">
						<label for="bank">무통장</label>

						<input type="radio" name="paymentMethod" value="카카오페이" id="kakaopay">
						<label for="kakaopay">카카오페이</label>
					</div>
				</div>
			
			<!--  오른쪽: 주문 상품 및 결제 요약 -->
			<div class="right-section">
				<div class="summary-box">
					<!-- 총 상품 금액 -->
					<div class="summary-item">
						<span>총 상품 금액</span>
						<span id="total-price" data-original-price="<%= totalPrice %>"><%= String.format("%,d", totalPrice) %> 원</span>
					</div>
					<div class="summary-divider"></div>

					<!-- 총 할인 금액 -->
					<div class="summary-item">
						<span>총 할인 금액</span>
						 <span id="total-discount">0 원</span>
					</div>
					<div class="discount-detail">
						<div class="discount-row">
							<span>상품 할인</span>
							<span>0 원</span>
						</div>
						<!-- 쿠폰 할인 -->
						<div class="discount-row">
							<span>쿠폰</span>
							<span id="coupon-discount">0 원</span>
						</div>
						<div class="discount-row">
							<span>포인트</span>
							<span id="point-discount">0 원</span>
						</div>
					</div>

					<div class="summary-divider"></div> 

					<div class="summary-item">
					<input type="hidden" name="finalShippingFee" id="finalShippingFee" value="3000">
						<span>배송비</span>
						<span id="shipping-fee">0 원</span>
					</div>
					<div class="summary-divider"></div>

					<!-- 최종 결제 금액 -->
					<div class="summary-item">
						<span>최종 결제 금액</span>
						<span id="final-price"><%= String.format("%,d", totalPrice) %> 원</span>
						<!-- 결제 버튼 -->
						  <button type="button" id="paymentButton" class="btn-payment">결제하기</button>
					</div>						
				</div>
			</div>
			</div>
        </form>
    </div>
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
			<span><a href="footer_policy.jsp">개인정보처리방침</a> | <a href="footer_terms.jsp">이용약관</a></span>
		</div>
	</footer>
</body>
</html>