<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("euc-kr");
    String productId = request.getParameter("product_id");

    String title = "";
    String description = "";
    boolean dataExists = false;

    if (productId != null && !productId.trim().equals("")) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.gjt.mm.mysql.Driver");
            String url = "jdbc:mysql://localhost:3306/succu";
            conn = DriverManager.getConnection(url, "multi", "abcd");

            String sql = "SELECT condition_title, condition_desc FROM product_conditions WHERE product_id = ? AND condition_type = 'sun'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, productId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                title = rs.getString("condition_title");
                description = rs.getString("condition_desc");
                dataExists = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>빛</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
        }
        img {
            width: 350px;
            height: 350px;
        }
        .img {
            float: left;
            margin-top: 25px;
            margin-right: 30px;
        }
       .content {
			width: 764px;
			height: 400px;
			float: left;
			background-color: #f5f5f5;
			display: table;             /* 핵심: 테이블처럼 동작 */
		}

		.content-inner {
			display: table-cell;        /* 테이블 셀처럼 */
			vertical-align: middle;     /* 수직 가운데 정렬 */
			padding: 0 20px;            /* 좌우 여백 */
		}

        .content h2 {
            font-family: 'GmarketSansTTFMedium';
            margin-top: 50px;
            margin-bottom: 30px;
			text-align: center;
        }
        .content p {
            font-family: 'GmarketSansTTFLight';
            font-size: 20px;
            text-align: left;
            padding-left: 20px;
            padding-right: 20px;
        }
        .content font {
            color: #7ab863;
        }
		.sun-label {
			color: #7ab863;
			font-weight: bold;
			font-size: 20px;
			font-family: 'GmarketSansTTFLight';
			padding-left: 20px;
			padding-right: 20px;
			margin-top: 25px;
			margin-bottom: 30px;
		}

		.sun-desc {
			font-size: 20px;
			font-family: 'GmarketSansTTFLight';
			text-align: left;
			padding-left: 20px;
			padding-right: 20px;
			margin-top: 0;
			margin-bottom: 20px;
		}

    </style>
</head>
<body>
    <center>
    <div class="img">
        <img src="images/sun.jpg">
    </div>
    <div class="content">
		<div class="content-inner">
		<h2><%= dataExists ? title : "정보 없음" %></h2>

		<%
			if (dataExists) {
				String[] lines = description.split("\\n"); // 줄 단위로 자름
				for (String line : lines) {
					line = line.trim();
					if (line.startsWith("빛이 강할 때:")) {
						String desc = line.substring("빛이 강할 때:".length()).trim();
		%>
			<p class="sun-label">빛이 강할 때</p>
			<p class="sun-desc"><%= desc %></p>
		<%
					} else if (line.startsWith("빛이 약할 때:")) {
						String desc = line.substring("빛이 약할 때:".length()).trim();
		%>
			<p class="sun-label">빛이 약할 때</p>
			<p class="sun-desc"><%= desc %></p>
		<%
					} else {
		%>
			<p class="sun-desc"><%= line %></p>
		<%
					}
				}
			} else {
		%>
			<p class="sun-desc">해당 상품의 빛 정보가 등록되어 있지 않습니다.</p>
		<%
			}
		%>
		</div>
	</div>


    </center>
</body>
</html>
