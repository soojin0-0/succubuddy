<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
  String loginId = (String) session.getAttribute("sid");
  String roadPrefix = "";

  // ★ 위도/경도 초기값 설정
  double userLatitude = 0.0;
  double userLongitude = 0.0;

  if (loginId == null) {
%>
    <script>
      alert("로그인이 필요합니다!");
      location.href = "login.jsp";
    </script>
<%
    return;
  }

  // 로그인 상태일 경우 주소와 위도경도 가져오기
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;

  try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");
    pstmt = conn.prepareStatement("SELECT address, latitude, longitude FROM user WHERE user_id = ?");
    pstmt.setString(1, loginId);
    rs = pstmt.executeQuery();
    if (rs.next()) {
      String fullAddress = rs.getString("address");
      if (fullAddress != null && fullAddress.contains(",")) {
        String[] parts = fullAddress.split(",");
        if (parts.length > 1) roadPrefix = parts[1].trim();
      }
      userLatitude = rs.getDouble("latitude");
      userLongitude = rs.getDouble("longitude");
    }
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
  }
%>

<%
    String url = "jdbc:mysql://localhost:3306/succu";
    String user = "multi";
    String password = "abcd";

    String selectedCategory = request.getParameter("category");
    if (selectedCategory == null) selectedCategory = "C001";

    // 기존: 카테고리 설명 + 상품용 변수
    String description = "";
    String structuralFeatures = "";
    String growthAndPropagation = "";
    String productList = "";
    String productId = "", name = "";

    // 추천용 변수 (전부 rec 접두어)
    String recProductId = "", recName = "", recDescription = "";
    String recWater = "", recWaterDetail = "";
    String recTemp = "", recTempDetail = "";
    String recSun = "", recSunDetail = "";
    String recHumid = "", recHumidDetail = "";

	ArrayList<HashMap<String, String>> recList = new ArrayList<>();
	ArrayList<Map<String, String>> monthList = new ArrayList<>();
    Map<String, String> first = null;
	
    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(url, user, password);

        // 카테고리 설명
        String sql = "SELECT description, structural_features, growth_and_propagation FROM plant_category WHERE category_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, selectedCategory);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            description = rs.getString("description");
            structuralFeatures = rs.getString("structural_features");
            growthAndPropagation = rs.getString("growth_and_propagation");
        }
        rs.close();
        pstmt.close();

        // 상품 목록
        sql = "SELECT product_id, product_name FROM plant_products WHERE category_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, selectedCategory);
        rs = pstmt.executeQuery();
        int count = 0;
        productList += "<div class='product-row'>";
        while (rs.next()) {
            String productIdTemp = rs.getString("product_id");
            String productNameTemp = rs.getString("product_name");

            productList += "<div class='product-item'>";
            productList += "<img src='images/" + productIdTemp + ".png' alt='" + productNameTemp + "' class='product-img' "
                         + "onerror=\"this.onerror=null; this.src='images/no_image.png';\">";
            productList += "<div class='product-name'>" + productNameTemp + "</div>";
            productList += "</div>";

            count++;
            if (count % 4 == 0) {
                productList += "</div><div class='product-row'>";
            }
        }
        productList += "</div>";
        rs.close();
        pstmt.close();

        // 추천 식물 정보 (변수/객체명 전부 분리)
		String recSql = "SELECT * FROM recommend_succu ORDER BY sort_order ASC";
			pstmt = conn.prepareStatement(recSql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				HashMap<String, String> map = new HashMap<>();
				map.put("productId", rs.getString("product_id"));
				map.put("name", rs.getString("name"));
				map.put("description", rs.getString("description"));
				map.put("water", rs.getString("water"));
				map.put("waterDetail", rs.getString("water_detail"));
				map.put("temp", rs.getString("temperature"));
				map.put("tempDetail", rs.getString("temperature_detail"));
				map.put("sun", rs.getString("sun"));
				map.put("sunDetail", rs.getString("sun_detail"));
				map.put("humid", rs.getString("humidity"));
				map.put("humidDetail", rs.getString("humidity_detail"));
				recList.add(map);
			}

			rs.close();
			pstmt.close();
	

		//month of succu
		String monthSql = "SELECT * FROM month_of_succu WHERE month = 5 ORDER BY product_id ASC";
			pstmt = conn.prepareStatement(monthSql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				Map<String, String> map = new HashMap<>();
				map.put("productId", rs.getString("product_id"));
				map.put("name", rs.getString("name"));
				map.put("desc", rs.getString("description"));
				monthList.add(map);
			}

			if (!monthList.isEmpty()) {
				first = monthList.get(0); // 첫 번째 다육이를 초기값으로 설정
			}

			rs.close();
			pstmt.close();
		
	 } catch(Exception e) {
		e.printStackTrace();
	} finally {
		// 추천용은 여기서 닫지 않음, 기존 것만 닫기
		if (rs != null) try { rs.close(); } catch (Exception e) {}
		if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
		if (conn != null) try { conn.close(); } catch (Exception e) {}
	}
%>

<html lang="ko">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main</title>
	<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=b32f0cea9b46043cd332b797ceefc593&autoload=true&libraries=services"></script>

<% if (userLatitude == 0.0 || userLongitude == 0.0) { %>
<script>
  kakao.maps.load(function () {
    const geocoder = new kakao.maps.services.Geocoder();
    const userAddress = "<%= roadPrefix.replace("\"", "\\\"").replace("'", "\\'") %>";

    if (userAddress) {
      geocoder.addressSearch(userAddress, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
          const lat = result[0].y;
          const lng = result[0].x;

          fetch("/succu/updateLatLng.jsp", {
            method: "POST",
            headers: {
              "Content-Type": "application/x-www-form-urlencoded"
            },

            body: "latitude=" + encodeURIComponent(lat) + "&longitude=" + encodeURIComponent(lng)
          })
          .then(res => res.text())
          .then(text => {
            console.log("updateLatLng.jsp 응답 내용:", text);
          })
          .catch(err => console.error("요청 실패:", err));
        }
      });
    }
  });
</script>
<% } %>

   <style>
    /* 기본 설정 */
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

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        width: 100%;
        max-width: 1920px;
        margin: 0 auto;
        overflow-x: hidden;
    }

   /* 네비게이션 */
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

/* 배너 */
.banner {
    width: 100%;
    height: 850px; /* 배너 높이 조정 */
    background-image: url('images/keyimg.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
}


    .content {
        text-align: center;
    }

    .highlight {
        color: #4CAF50; /* 초록색 강조 */
    }

    /*식물 카테고리*/
    .body-wrapper {
        width: 1500px;
        height: 900px;
        position: relative;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        box-sizing: border-box;
        background-image: url('images/typeofsuccu.png');
        background-repeat: no-repeat;
        padding: 50px;
        display: flex;
        flex-direction: column;
        gap: 50px;
        margin-top: 650px;
        margin-bottom: -400px;
    }

    .plant-category-wrapper {
        display: flex;
        gap: 30px;
        justify-content: center;
        background-color: #fff; /* 선을 가리는 흰색 배경 */
        z-index: 2; /* 선 위로 배치 */
        padding: 5px 20px;
        position: relative;
        top: -90px; /* 카테고리와 선의 시각적 정렬 최적화 */
        width: fit-content; /* 카테고리만큼만 너비 설정 */
        margin-left: 390px;
    }

    .plant-category-wrapper::before,
    .plant-category-wrapper::after {
        content: "";
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        width: 20px;  /* 가림막의 너비 */
        height: 4px;  /* 가림막의 높이 (선과 일치) */
        background-color: #fff; /* 배경과 동일한 색으로 선 가림 */
    }

    .plant-category-wrapper::before {
        left: -15px;  /* 왼쪽 끝 선 가림 */
    }

    .plant-category-wrapper::after {
        right: -10px; /* 오른쪽 끝 선 가림 */
    }

    .plant-category {
        text-align: center;
        color: #60af46;
        cursor: pointer; /* 선택 가능한 형태로 변경 */
        font-size: 24px;
        font-family: 'GmarketSansTTFMedium';
    }

    .plant-selected {
        background-color: #60AF46;
        color: #fff;
        border-radius: 50%;
        width: 126px;
        height: 126px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        text-align: center;
        margin-top: -30px;
        position: static;  /* 위치 변경 방지 */
        transform: none;   /* 추가적인 위치 변경 방지 */
    }

    .plant-selected .plant-icon {
        filter: brightness(0) invert(1);
        margin-bottom: 10px;
    }

    .plant-icon {
        width: 65px;
        height: 65px;
        margin-bottom: 5px;
        margin-left: 10px;
        margin-right: 10px;
    }

    .plant-category img {
        width: 60px;
        height: 60px;
        margin-bottom: 15px;
    }

    .plant-info {
        display: flex;
        justify-content: space-between;
        color: #333; /* 기본 글씨 색상 */
        line-height: 1.2; /* 줄 간격 조정 */
        margin-left: 30px; /* 좌측 여백 추가 */
    }

    .plant-description {
        width: 50%;
        margin-top: -50px;
    }

    .plant-description p {
        width: 650px;
        height: 90px;
        padding: 15px 10px; /* 내부 여백 추가 */
        font-size: 20px;
        margin-bottom: 30px;
        color: #f4a900; /* 기본 글씨 색상 */
        font-family: 'GmarketSansTTFBold';
        line-height: 1.8; /* 줄 간격 조정 */
    }

    .plant-section-title {
        color: #60af46; /* 타이틀 초록색 강조 */
        font-size: 24px; /* 제목 크기 */
        margin-top: 60px; /* 제목 상단 여백 */
        font-family: 'GmarketSansTTFMedium';
        margin-bottom: 30px;
    }

    .plant-section ul {
        padding-left: 25px; /* 목록 들여쓰기 */
        list-style: disc; /* 일반 점 목록 스타일 */
    }

    .plant-section li {
        margin-top: 10px; /* 목록 간격 추가 */
        font-size: 20px; /* 목록 글씨 크기 */
        font-family: 'GmarketSansTTFLight';
    }

    .plant-products {
        width: 44%;
        display: flex;
        flex-direction: column;
        gap: 20px;
        margin-top: -120px;
    }

    .product-row {
        display: flex;
        justify-content: flex-start;
        gap: 60px;
    }

    .product-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 100px;
        text-align: center;
    }

    .product-img {
        width: 125px;
        height: 125px;
        margin-bottom: 10px;
    }

    .product-name {
        font-size: 19px;
        word-break: keep-all;
        font-family: 'GmarketSansTTFLight';
    }

    /* 섹션 타이틀 */
    .section-title {
        font-family: 'RixInooAriDuriPro';
        font-size: 40px;
        color: #000000;
        text-align: left;
        margin-bottom: 10px;
        margin-top: 150px;
        padding-bottom: 5px;
        margin-left: 70px;
    }

    /*pmrecommend sccu*/
    .rm-wrapper {
        max-width: 1920px;                 /* 최대 1920px까지만 */
        height: 904px;                     /* 세로 고정 */
        background-image: url('images/rmbackground.png');
        background-repeat: no-repeat;
        background-position: center center;
        background-size: 100% 904px;       /* 가로는 100%, 세로는 고정 */
        position: relative;
        margin: 0 auto;
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden;
        padding: 0;
        border: none;
        margin-left: -50px;
        margin-right: -10px;
        margin-top: 71px;
        margin-bottom: 123px;
    }

    .rm-slide-container {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 1400px;
        margin: 0 auto;
    }

    .rm-arrow {
        width: 120px;
        height: 130px;
        cursor: pointer;
    }

    .rm-slide-content {
        display: flex;
        gap: 80px;
        align-items: center;
        justify-content: center;
        margin-top: 100px;
    }

    .rm-left {
        text-align: center;
    }

    .rm-plant-image {
        width: 400px;
        height: 400px;
    }

    .rm-plant-name {
        color: #60af46;
        font-size: 35px;
        margin-top: 32px;
        font-family: 'GmarketSansTTFBold';
    }

    .rm-more-link {
        font-size: 18px;
        color: #000000;
        margin-top: 15px;
        margin-left: 145px;
        font-family: 'GmarketSansTTFLight';
    }

    .rm-right {
        padding: 30px;
        width: 830px;
        margin-right: 30px;
    }

    .rm-description {
        text-align: center;
        font-size: 24px;
        color: #000000;
        margin-bottom: 60px;
        font-family: 'GmarketSansTTFLight';
    }

    .rm-info-table {
        display: grid;
        grid-template-columns: 1fr 1fr;
    }

    .rm-info-item {
        display: flex;
        flex-direction: column; /* 수직 정렬 */
        align-items: flex-start;
        gap: 20px;
        padding: 20px;
        box-sizing: border-box;
        min-height: 120px;
    }

    /* 십자선만 보이게 조건부 테두리 설정 */
    .rm-info-item:nth-child(1),
    .rm-info-item:nth-child(2) {
        border-bottom: 2px solid #9ED88F;
    }
    .rm-info-item:nth-child(1),
    .rm-info-item:nth-child(3) {
        border-right: 2px solid #9ED88F;
    }

    .rm-info-icon {
        width: auto;
        height: auto;
        margin-top: 4px;
    }

    .rm-info-text {
        display: flex;
        flex-direction: column;
    }

    .rm-info-title {
        font-size: 20px;
        font-family: 'GmarketSansTTFMedium';
        color: #111;
    }

    .rm-info-detail {
        font-size: 18px;
        font-family: 'GmarketSansTTFLight';
        color: #666;
        margin-top: 10px;
    }

    .succu-difficulty-btn {
        position: absolute;
        top: 135px;
        left: 60%;
        transform: translateX(-50%);
        width: 341px;
        height: 86px;
        display: inline-flex;
        align-items: center;
        border: 2px solid #6EB466;
        border-radius: 43px;
        padding: 8px 18px;
        
        font-family: 'GmarketSansTTFBold';
        font-size: 34px;
        color: #6EB466;
        z-index: 10;
    }

    .succu-text {
        margin-right: 6px;
        margin-left: 45px;
    }

    .succu-star {
        width: 30px;
        height: 29px;
        vertical-align: middle;
        margin-top: -5px;
        margin-left: 10px;
    }


		/* month of succu*/
		.month-wrapper {
			display: flex;
			justify-content: space-between;
			padding: 60px 100px;
			position: relative;
		}
		.month-card-topdotted-img {
			width: 1633px; /* 또는 60% 등 적절히 조절 */
			height: 10px; /* 점선 이미지 높이 */
			background-image: url('images/dashline.png');
			background-repeat: repeat-x;
			background-position: center;
			background-size: contain; /* or cover */
			margin: 120px auto;
			margin-bottom: -120px;

		}
		.month-card-bottomdotted-img {
			width: 1633px; /* 또는 60% 등 적절히 조절 */
			height: 10px; /* 점선 이미지 높이 */
			background-image: url('images/dashline.png');
			background-repeat: repeat-x;
			background-position: center;
			background-size: contain; /* or cover */
			margin: 10px auto;
			margin-top: -120px;
		}

		.month-left {
			display: flex;
			align-items: center; /* 수직 가운데 정렬 */
			height: 800px; /* 오른쪽 카드와 동일하게 맞추기 */
			margin-left: 30px;
		}

		.month-left-content {
			width: 100%;
			margin-top: 150px;
		}

		.month-left-title {
			font-size: 35px;
			margin-bottom: 15px;
			font-family: 'GmarketSansTTFMedium';
			
		}

		.month-left-subtitle {
			font-size: 30px;
			margin-bottom: 63px;
			margin-top: 78px;
			text-align: center;
			font-family: 'GmarketSansTTFMedium';
			position: relative;
			display: inline-block;
		}
		.month-left-subtitle::after {
			content: '';
			position: absolute;
			bottom: -6px;
			left: 6;
			width: 100%;
			height: 2px;
			background-color: #f4a900;
		}

		.month-left-subtitle::before {
			content: '';
			position: absolute;
			bottom: -11px;
			left: 20;
			width: 100%;
			height: 2px;
			margin-right: -20px;
			background-color: #f4a900;
		}
		.month-left-guide {
			list-style: none;
			padding: 0;
			margin: 0;
			margin-top: 60px;
		}
		.month-left-guide img {
			width: auto;
			height: 35px;
			flex-shrink: 0; /* 이미지 크기 유지 */
			margin-top: 0;  /* 정렬 깨짐 방지 */
		}
		.month-left-guide li {
			display: flex;
			align-items: center; /* 세로 가운데 정렬 */
			gap: 20px;
			margin-bottom: 50px;
			font-size: 24px;
			color: #444;
			line-height: 1.4;
			font-family: 'GmarketSansTTFLight';
		}

		.month-left-subtitle img {
			vertical-align: middle;
			width: 30px;
			height: 30px;
			margin-right: 10px;
			margin-top: -35px;
		}


		.month-guide-text {
			display: inline-block;
		}

		/* 제목용 하이라이트 (예: "5월의 다육") */
		.month-highlight-title {
			color: #f4a900;
			font-size: 50px;
			font-family: 'GmarketSansTTFBold';
		}

		/* 설명 문장 중 강조 텍스트용 (예: "강한 직사광선" 등) */
		.month-highlight-desc {
			color: #60af46;
			font-size: 24px;
			font-family: 'GmarketSansTTFMedium';
		}

		/*right*/
		.month-right-card {
			position: relative; /* 기준점 */
			width: 621px;
			height: 845px;
			background-color: #f0f7ec;
			border-radius: 30px;
			transform: rotate(6deg);
			margin: 8px 22px;
			margin-bottom: 50px;
			padding-top: 50px;
		}
		.month-top-title {
		  font-size: 35px;
		  color: #4CAF50; /* 초록색 */
		  text-align: center;
		  font-family: 'GmarketSansTTFBold';
		}

		.month-card {
			background-color: #eef6ea;
			border-radius: 20px;
			padding: 25px 20px;
			text-align: center;
			width: 100%;
			height: 100%;
			box-sizing: border-box;
			position: relative;
		}

		.month-card-imgbox {
			background-color: white;
			padding: 15px;
			border-radius: 12px;
			margin: 80 auto 20px;
			width: 451.46px;
			height: 300px;
			display: flex;
			align-items: center;
			justify-content: center;
		}

		.month-card-img {
			max-width: 100%;
			max-height: 100%;
		}
		.month-card-name {
			font-size: 35px;
			margin: 45px 0;
			font-family: 'GmarketSansTTFMedium';
		}

		.month-card-line {
			width: 80%;
			height: 1px;
			background: #000000;
			margin: 20 auto 15px;
		}

		.month-card-desc {
			font-size: 22px;
			color: #333;
			font-family: 'GmarketSansTTFLight';
			line-height: 1.7;
			word-break: keep-all;       /* 단어 중간 줄바꿈 방지 */
			white-space: normal;        /* 자동 줄바꿈 허용 */
			padding: 0 0px;            /* 좌우 여백 */
			text-align: center;
			display: block;
			max-width: 100%;             /* 카드 안쪽 최대 폭 */
			margin: 50px auto;             /* 가운데 정렬 */
		}

		/* 테이프 */
		.month-tape {
			width: 230px;
			height: 53px;
			background-color: #81c784;
			position: absolute;
			z-index: 2;
			opacity: 0.85;
		}

		/* 좌측 상단 테이프 */
		.tape-top-left {
			top: 125px;
			left: -50px;
			transform: rotate(-45deg);
			transform-origin: left top;
		}

		/* 우측 하단 테이프 */
		.tape-bottom-right {
			bottom:100px;
			right: -50px;
			transform: rotate(-45deg);
			transform-origin: right bottom;
		}


		/* CUSTOM SUCCU */
		.custom-wrapper {
		  display: flex;
		  justify-content: space-between;
		  max-width: 1400px; /* 줄였어 */
		  margin: 100px auto;
		  padding: 0 20px; /* 여백도 줄였어 */
		  box-sizing: border-box;
		}

		/* 왼쪽 텍스트 영역 */
		.custom-left {
		  width: 38%;
		  text-align: center;
		  margin-top: 60px;
		}

		.custom-left-text {
		  font-size: 33px;
		  margin-bottom: 10px;
		  white-space: nowrap;        /* 줄바꿈 방지 */
		  font-family: 'GmarketSansTTFMedium';
		  line-height: 1.6;
		}

		.custom-highlight-title {
		  color: #4CAF50;
		  font-family: 'GmarketSansTTFBold';
		}

		.custom-highlight-desc {
		  color: #60af46;
		  font-family: 'GmarketSansTTFMedium';
		}

		.custom-left p {
		  font-size: 30px;
		  color: #555;
		  margin-bottom: 30px;
		  font-family: 'GmarketSansTTFLight';
		}

		.custom-test-button {
		  display: inline-block;
		  background-image: url('images/hawor.png'); /* 실제 이미지 경로로 수정 */
		  background-size: cover;
		  background-repeat: no-repeat;
		  background-position: center;
		  width: 500px;   /* 이미지 크기 맞게 조정 */
		  height: 472px;
		  text-align: center;
		  line-height: 200px;
		  margin-top: 50px;
		  text-decoration: none;
		  font-family: 'GmarketSansTTFBold';
		  font-size: 34px;
		  padding-top: 130px;
		  color: #4CAF50;
		  transition: transform 0.2s ease;
		}

		.custom-test-button:hover {
		  transform: scale(1.05);
		}


		/* 오른쪽 이미지 영역 */
		.custom-right {
		  width: 50%;
		  margin-bottom: 100px;
		  position: relative;
		}

		/* 오른쪽 전체 이미지 */
		.custom-full-image {
		  max-width: 100%;
		  height: auto;
		  display: block;
		  
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
		.manager {
			width: 1100px;
			margin-top: 10px;
			font-size: 16px;
			font-family: 'GmarketSansTTFMedium'; /* 원하시면 다른 폰트 사용 */
		}
		.manager a {
			font-size: 28px;
			margin: 0 15px; /* 좌우 간격 */
			text-decoration: none;
			color: black;
		}
</style>

</head>
<script>
    function selectCategory(categoryId) {
        // 모든 카테고리에서 선택 클래스 제거
        document.querySelectorAll('.plant-category').forEach(el => el.classList.remove('plant-selected'));

        // 클릭한 카테고리에 선택 클래스 추가
        document.getElementById(categoryId).classList.add('plant-selected');

        // AJAX로 카테고리 정보 가져오기
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "get_category.jsp?category=" + categoryId, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const data = JSON.parse(xhr.responseText);

                // 설명
                document.querySelector(".plant-section p").innerHTML =
                    data.descriptionParts.map(part => part.trim() + "<br>").join("");

                // 구조적 특징
                const structureUl = document.querySelectorAll(".plant-section")[1].querySelector("ul");
                structureUl.innerHTML = "";
                data.structuralFeatures.forEach(f => {
                    if (f.trim()) structureUl.innerHTML += "<li>" + f.trim() + "</li>";
                });

                // 생장 및 번식
                const growthUl = document.querySelectorAll(".plant-section")[2].querySelector("ul");
                growthUl.innerHTML = "";
                data.growthAndPropagation.forEach(f => {
                    if (f.trim()) growthUl.innerHTML += "<li>" + f.trim() + "</li>";
                });

                // 상품 목록
                document.querySelector(".plant-products").innerHTML = data.productList;
            }
        };
        xhr.send();
    }

    //  페이지가 처음 로드될 때 돌나물 선택되도록
    window.onload = function () {
        selectCategory("C001"); // 초기 선택을 돌나물로 강제
    };
</script>
<!--recommend succu-->
<script>
	document.addEventListener("DOMContentLoaded", function () {
		let items = document.querySelectorAll(".recommend-item");
		let current = 0;

		function showSlide(index) {
			if (items.length === 0) return;
			const item = items[index];

			document.getElementById("rec-img").src = "images/" + item.dataset.productid + ".png";
			document.getElementById("rec-name").innerText = item.dataset.name;
			let description = item.dataset.description;

			// 줄바꿈 먼저 처리 (문자 그대로 '\n' → <br>)
			description = description.replace(/\\n/g, "<br>");

			// 강조 부분 처리 (이건 <br> 치환 다음에)
			description = description
			  .replace(/특별한 관리하지 않아도/g, "<span style='color:#f4a900; font-family:GmarketSansTTFMedium;'>특별한 관리하지 않아도</span>")
			  .replace(/초보자도 쉽게/g, "<span style='color:#f4a900; font-family:GmarketSansTTFMedium;'>초보자도 쉽게</span>")
			  .replace(/은은한 햇빛에도 잘 적응하며/g, "<span style='color:#f4a900; font-family:GmarketSansTTFMedium;'>은은한 햇빛에도 잘 적응하며</span>")
			  .replace(/강한 햇빛에도 잘 견디며/g, "<span style='color:#f4a900; font-family:GmarketSansTTFMedium;'>강한 햇빛에도 잘 견디며</span>")
			  .replace(/단단한 몸통에는/g, "<span style='color:#f4a900; font-family:GmarketSansTTFMedium;'>단단한 몸통에는</span>")
			  .replace(/수분을 많이 머금을 수 있어/g, "<span style='color:#f4a900; font-family:GmarketSansTTFMedium;'>수분을 많이 머금을 수 있어</span>")
			  .replace(/물 없어도/g, "물 없어도<br>");

			// 최종 삽입
			document.getElementById("rec-description").innerHTML = description;


			// 텍스트 나눠서 넣기 (title / detail)
			document.getElementById("water-title").innerText = item.dataset.water;
			document.getElementById("water-detail").innerText = item.dataset.waterdetail;

			document.getElementById("temp-title").innerText = item.dataset.temp;
			document.getElementById("temp-detail").innerText = item.dataset.tempdetail;

			document.getElementById("sun-title").innerText = item.dataset.sun;
			document.getElementById("sun-detail").innerText = item.dataset.sundetail;

			document.getElementById("humid-title").innerText = item.dataset.humid;
			document.getElementById("humid-detail").innerText = item.dataset.humiddetail;
		}

		window.nextSlide = function () {
			current = (current + 1) % items.length;
			showSlide(current);
		}

		window.prevSlide = function () {
			current = (current - 1 + items.length) % items.length;
			showSlide(current);
		}

		showSlide(0); // 초기 슬라이드 실행
	});
</script>
<!--month of succu-->
<script>
	document.addEventListener("DOMContentLoaded", function () {
		let monthItems = document.querySelectorAll(".month-item");
		let monthCurrent = 0;

		function showMonthSlide(index) {
			if (monthItems.length === 0) return;

			const item = monthItems[index];
			let desc = item.dataset.description;

			desc = desc
				.replace(/잎꽃이 번식/g, "<span style='color:#f4a900; font-family:GmarketSansTTFBold;'>잎꽃이 번식</span>")
				.replace(/자주 환기/g, "<span style='color:#f4a900; font-family:GmarketSansTTFBold;'>자주 환기</span>")
				.replace(/큰 일교차에 주의/g, "<span style='color:#f4a900; font-family:GmarketSansTTFBold;'>큰 일교차에 주의</span>")
				.replace(/초보자도 쉽게/g, "<span style='color:#f4a900; font-family:GmarketSansTTFBold;'>초보자도 쉽게</span>")
				.replace(/잎이 단단하고 물이 많아/g, "<span style='color:#f4a900; font-family:GmarketSansTTFBold;'>잎이 단단하고 물이 많아</span>")
				.replace(/색이 선명해지고/g, "<span style='color:#f4a900; font-family:GmarketSansTTFBold;'>색이 선명해지고</span>")
				.replace(/병해도 줄어듦/g, "<span style='color:#f4a900; font-family:GmarketSansTTFBold;'>병해도 줄어듦</span>")
				.replace(/수분 관리가 중요함/g, "<span style='color:#f4a900; font-family:GmarketSansTTFBold;'>수분 관리가 중요함</span>")
				.replace(/\\n/g, "<br>");

			document.getElementById("month-img").src = "images/" + item.dataset.productid + ".png";
			document.getElementById("month-name").innerText = item.dataset.name;
			document.getElementById("month-desc").innerHTML = desc;
		}


		showMonthSlide(0);

		setInterval(() => {
			monthCurrent = (monthCurrent + 1) % monthItems.length;
			showMonthSlide(monthCurrent);
		}, 5000);
	});




</script>




</head>

<body>
    <header class="navbar">
		<img src="images/logo.png" alt="SuccuBuddy Logo" class="logo">
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

<% if ("admin".equals(loginId)) { %>
	<div class="manager">
		<a href="manager_member.jsp">회원관리</a>	|
		<a href="manager_order.jsp">	주문배송관리</a>		|
		<a href="manager_review.jsp">	리뷰관리</a>	|
		<a href="manager_inquiry.jsp">	문의관리</a>
	</div>
<% } %>

    <div class="banner"></div>


	<!--식물 카테고리-->
	<div class="section-title"><span class="highlight">TYPE OF</span> SUCCU</div>


	<div class="body-wrapper">
    <div class="plant-container">
	<div class="plant-category-wrapper">
        <div class="plant-category" id="C001"  onclick="selectCategory('C001')">
            <img src="images/C001.png" alt="돌나물 아이콘" class="plant-icon">
            <div>돌나물과</div>
        </div>
        <div class="plant-category" id="C002" onclick="selectCategory('C002', event)">
            <img src="images/C002.png" alt="선인장 아이콘" class="plant-icon">
            <div>선인장과</div>
        </div>
        <div class="plant-category" id="C003" onclick="selectCategory('C003', event)">
            <img src="images/C003.png" alt="백합 아이콘" class="plant-icon">
            <div>백합과</div>
        </div>
        <div class="plant-category" id="C004" onclick="selectCategory('C004', event)">
            <img src="images/C004.png" alt="대극 아이콘" class="plant-icon">
            <div>대극과</div>
        </div>
        <div class="plant-category" id="C005" onclick="selectCategory('C005')">
            <img src="images/C005.png" alt="용설란 아이콘" class="plant-icon">
            <div>용설란과</div>
        </div>
		</div>
    </div>

    <div class="plant-info">
        <div class="plant-description">
            <div class="plant-section">
				<p>
					<% 
						// "특징이며", "있으며", "구별되며", "많으며" 기준으로 줄 바꿈 추가
						String[] descriptionParts = description.split("(?<=특징이며|있으며|구별되며|많으며)"); 
						for (String part : descriptionParts) { 
					%>
						<%= part.trim() %><br>
					<% 
						}
					%>
				</p>
			</div>



            <div class="plant-section">
                <div class="plant-section-title">구조적 특징</div>
                <ul>
                    <% 
                        String[] features = structuralFeatures.split("\\.\\s*"); 
                        for (String feature : features) { 
                            if (!feature.trim().isEmpty()) {
                    %>
                        <li><%= feature.trim() %></li>
                    <% 
                            }
                        } 
                    %>
                </ul>
            </div>

            <div class="plant-section">
                <div class="plant-section-title">생장 및 번식</div>
                <ul>
                    <% 
                        String[] growthFeatures = growthAndPropagation.split("\\.\\s*"); 
                        for (String growthFeature : growthFeatures) { 
                            if (!growthFeature.trim().isEmpty()) {
                    %>
                        <li><%= growthFeature.trim() %></li>
                    <% 
                            }
                        } 
                    %>
                </ul>
            </div>
        </div>

        <div class="plant-products">
			<%= productList %>
		</div>
    </div>
	</div>



	
	<!--RECOMMEND SUCCU-->
	<div class="section-title"><span class="highlight">RECOMMENDED</span> SUCCU</div>

	<div class="rm-wrapper">
		<div class="rm-slide-container">
		 <!--  다육 난이도  -->
		<div class="succu-difficulty-btn">
			<span class="succu-text">다육 난이도</span>
			<img src="images/star_g.png" alt="별" class="succu-star">
		</div>

			<img src="images/left_arrow.png" class="rm-arrow" onclick="prevSlide()">

				<div class="rm-slide-content">
					<div class="rm-left">
						<img id="rec-img" src="" class="rm-plant-image">
						<div id="rec-name" class="rm-plant-name"></div>
						<div class="rm-more-link" href="productDetail.jsp">알아보기 ></div>
					</div>

					<div class="rm-right">
						<div id="rec-description" class="rm-description"></div>
						<div class="rm-info-table">
							<div class="rm-info-item">
							  <img src="images/g_water.png" class="rm-info-icon">
							  <div class="rm-info-text">
								<div id="water-title" class="rm-info-title"></div>
								<div id="water-detail" class="rm-info-detail"></div>
							  </div>
							</div>

							<div class="rm-info-item">
							  <img src="images/g_thermometer.png" class="rm-info-icon">
							  <div class="rm-info-text">
								<div id="temp-title" class="rm-info-title"></div>
								<div id="temp-detail" class="rm-info-detail"></div>
							  </div>
							</div>

							<div class="rm-info-item">
							  <img src="images/g_sun.png" class="rm-info-icon">
							  <div class="rm-info-text">
								<div id="sun-title" class="rm-info-title"></div>
								<div id="sun-detail" class="rm-info-detail"></div>
							  </div>
							</div>

							<div class="rm-info-item">
							  <img src="images/g_cloud.png" class="rm-info-icon">
							  <div class="rm-info-text">
								<div id="humid-title" class="rm-info-title"></div>
								<div id="humid-detail" class="rm-info-detail"></div>
							  </div>
							</div>

						</div>
					</div>
				</div>

			<img src="images/right_arrow.png" class="rm-arrow" onclick="nextSlide()">
		</div>
	</div>

		<div id="recommend-data" style="display:none;">
		<%
			for (HashMap<String, String> rec : recList) {
		%>
			<div class="recommend-item"
				data-productid="<%=rec.get("productId")%>"
				data-name="<%=rec.get("name")%>"
				data-description="<%=rec.get("description")%>"
				data-water="<%=rec.get("water")%>"
				data-waterdetail="<%=rec.get("waterDetail")%>"
				data-temp="<%=rec.get("temp")%>"
				data-tempdetail="<%=rec.get("tempDetail")%>"
				data-sun="<%=rec.get("sun")%>"
				data-sundetail="<%=rec.get("sunDetail")%>"
				data-humid="<%=rec.get("humid")%>"
				data-humiddetail="<%=rec.get("humidDetail")%>">
			</div>
		<%
			}
		%>
	</div>




	<!--MONTH OF SUCCU-->
	<div class="section-title"><span class="highlight"> MONTH OF </span> SUCCU</div>

	 <div class="month-card-topdotted-img"></div>
	<div class="month-wrapper">
			<div class="month-left">
			<div class="month-left-content">
				<div class="month-left-title"><span class="month-highlight-title">5월</span>의 다육</div>
				<div style="text-align:center;">
				  <div class="month-left-subtitle">
					<img src="images/star_o.png" alt="star">이번 달은 이렇게 관리해 보세요!
				  </div>
				</div>

				<ul class="month-left-guide">
					<li>
						<img src="images/Sun.png">
						<span class="month-guide-text">
							다육식물은 햇빛을 많이 필요로 하지만, 
							<span class="month-highlight-desc">강한 직사광선(특히 한낮의 강한 빛)</span>은 <br> 잎을 태울 수 있으므로 주의해야 합니다.
						</span>
					</li>
					<li>
						<img src="images/Water.png">
						<span class="month-guide-text">
							성장기이므로 <span class="month-highlight-desc">물을 너무 아끼지 말고</span>, 흙이 충분히 마른 후 주는 것이 중요합니다.
						</span>
					</li>
					<li>
						<img src="images/Cloud.png">
						<span class="month-guide-text">
							기온이 오르는 시기이므로, 실내에서는 창문을 열어 <span class="month-highlight-desc">자주 환기</span>를 시켜주는 것이<br> 좋습니다.
						</span>
					</li>
					<li>
						<img src="images/Thermometer.png">
						<span class="month-guide-text">
							낮에는 따뜻하지만 밤에는 기온이 다소 떨어질 수 있으므로, 실외에 두는 경우<br> 
							<span class="month-highlight-desc">큰 일교차에 주의</span>해야 합니다.
						</span>
					</li>
				</ul>
			</div>
		</div>

		<% if (first != null) { %>
		<div class="month-right-card">
		
			<div class="month-card">
			 <div class="month-top-title">5월에 잘 크는 다육은?</div> <!-- 추가된 부분 -->
				<div class="month-card-imgbox">
					<img id="month-img" src="images/<%= first.get("productId") %>.png" class="month-card-img">
				</div>
				<div id="month-name" class="month-card-name"><%= first.get("name") %></div>
				<div class="month-card-line"></div>
				<div id="month-desc" class="month-card-desc"></div>


			</div>
			<div class="month-tape tape-top-left"></div>
			<div class="month-tape tape-bottom-right"></div>
		</div>
		<% } else { %>
		<p style="color:red;">추천 다육이 정보가 없습니다.</p>
		<% } %>

		<div id="month-data" style="display:none;">
			<%-- monthList 반복문 --%>
			<% for (Map<String, String> m : monthList) { %>
			  <div class="month-item"
				   data-productid="<%= m.get("productId") %>"
				   data-name="<%= m.get("name") %>"
				   data-description="<%= m.get("desc").replace("\n", "\\n").replace("\r", "").replace("\"", "&quot;") %>">
			  </div>
			<% } %>


		</div>
		
	</div>
	<div class="month-card-bottomdotted-img"></div>


	<!--CUSTOM SUCCU-->
	<div class="section-title"><span class="highlight"> CUSTOM </span> SUCCU</div>

	<div class="custom-wrapper">
	  <!-- 왼쪽 텍스트 -->
	  <div class="custom-left">
		<div class="custom-left-text">나와 <span class="custom-highlight-title">가장 알맞은</span> 다육이 궁금하신가요?</div>
		<p>테스트를 통해 <span class="custom-highlight-desc">맞춤 다육</span>을 알아보세요</p>
		<a href="sub3.jsp" class="custom-test-button">
		  <span>테스트하러 가기</span>
		</a>
	  </div>

	  <!-- 오른쪽 이미지만 -->
	  <div class="custom-right">
		<img src="images/customsuccu.png" alt="맞춤 다육 테스트 플로우" class="custom-full-image">
	  </div>
	</div>








	


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
