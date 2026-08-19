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

            String sql = "SELECT condition_title, condition_desc FROM product_conditions WHERE product_id = ? AND condition_type = 'temperature'";
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
    <title>온도</title>
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
            width: 800px;
            height: 480px;
            float: left;
            background-color: #f5f5f5;
            display: table;
            text-align: left;
        }

        .content-inner {
            display: table-cell;
            vertical-align: middle;
            padding: 0 20px;
        }

        .temp-label {
            color: #7ab863;
            font-weight: bold;
            font-size: 20px;
            font-family: 'GmarketSansTTFLight';
            margin-top: 20px;
            margin-bottom: 25px;
        }

        .temp-desc {
            font-family: 'GmarketSansTTFLight';
            font-size: 20px;
            margin-top: 0;
            margin-bottom: 10px;
            line-height: 1.4;
        }

        .content h2 {
            font-family: 'GmarketSansTTFMedium';
            font-weight: bold;
            font-size: 24px;
            text-align: center;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<center>
    <div class="img">
        <img src="images/temperature.jpg">
    </div>
    <div class="content">
        <div class="content-inner">
            <h2><%= dataExists ? title : "정보 없음" %></h2>
            <%
                if (dataExists) {
                    String[] lines = description.split("\\n");
                    for (String line : lines) {
                        line = line.trim();
                        if (line.startsWith("온도가 낮을 때:")) {
                            String desc = line.substring("온도가 낮을 때:".length()).trim();
            %>
                            <p class="temp-label">온도가 낮을 때</p>
                            <p class="temp-desc"><%= desc %></p>
            <%
                        } else if (line.startsWith("온도가 높을 때:")) {
                            String desc = line.substring("온도가 높을 때:".length()).trim();
            %>
                            <p class="temp-label">온도가 높을 때</p>
                            <p class="temp-desc"><%= desc %></p>
            <%
                        } else {
            %>
                            <p class="temp-desc"><%= line %></p>
            <%
                        }
                    }
                } else {
            %>
                <p class="temp-desc">해당 상품의 온도 정보가 등록되어 있지 않습니다.</p>
            <%
                }
            %>
        </div>
    </div>
</center>
</body>
</html>
