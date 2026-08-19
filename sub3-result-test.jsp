<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
request.setCharacterEncoding("euc-kr");

// 추천된 product_id 가져오기
String productId = (String) session.getAttribute("recommendedProduct");
System.out.println("추천된 product_id: " + productId);

// 초기값 설정
String productName = "이름 없음";
String feature = "특징 없음";
String water = "정보 없음", temperature = "정보 없음", sun = "정보 없음", humidity = "정보 없음";

// DB 연결
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

    // product 테이블 조회
    String productSql = "SELECT name, feature FROM product WHERE product_id = ?";
    pstmt = conn.prepareStatement(productSql);
    pstmt.setString(1, productId);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        productName = rs.getString("name");
        feature = rs.getString("feature");

        System.out.println("상품 이름: " + productName);
        System.out.println("특징: " + feature);
    } else {
        System.out.println("상품 테이블에 해당 ID 없음");
    }
    rs.close();
    pstmt.close();

    // succu_detail 테이블 조회
    String detailSql = "SELECT water_detail, temperature_detail, sun_detail, humidity_detail FROM succu_detail WHERE product_id = ?";
    pstmt = conn.prepareStatement(detailSql);
    pstmt.setString(1, productId);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        water = rs.getString("water_detail");
        temperature = rs.getString("temperature_detail");
        sun = rs.getString("sun_detail");
        humidity = rs.getString("humidity_detail");

        System.out.println("물: " + water);
        System.out.println("온도: " + temperature);
        System.out.println("햇빛: " + sun);
        System.out.println("습도: " + humidity);
    } else {
        System.out.println("succu_detail 테이블에 정보 없음");
    }

} catch (Exception e) {
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>

<!-- 결과 출력 부분 (원하는 위치에 넣으세요) -->
<div class="recommend-right">
  <div class="text-group">
    <p><span class="jul">당신에게 맞는 다육은</span></p>
    <p class="point"><%= productName %></p>
    <p><%= feature %></p>
    <br>
    <p>물: <%= water %></p>
    <p>온도: <%= temperature %></p>
    <p>햇빛: <%= sun %></p>
    <p>습도: <%= humidity %></p>
  </div>
</div>
