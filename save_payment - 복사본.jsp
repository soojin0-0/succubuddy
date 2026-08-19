<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.io.*, java.net.*, java.sql.*, java.util.*, java.text.*, org.json.simple.*, org.json.simple.parser.*" %>
<%
request.setCharacterEncoding("euc-kr");

String userId = (String) session.getAttribute("sid");
String tid = (String) session.getAttribute("tid");
String pg_token = request.getParameter("pg_token");
String orderId = (String) session.getAttribute("order_id");

String[] productIds = (String[]) session.getAttribute("product_ids");
String[] quantities = (String[]) session.getAttribute("quantities");
String usedPoints = (String) session.getAttribute("usedPoints");
String usedCoupon = (String) session.getAttribute("usedCoupon");
String finalPrice = (String) session.getAttribute("finalPrice");
String paymentMethod = (String) session.getAttribute("payment_method");
String discountAmount = (String) session.getAttribute("discountAmount");

if (finalPrice == null || finalPrice.trim().equals("")) finalPrice = "0";
if (usedPoints == null || usedPoints.trim().equals("")) usedPoints = "0";
if (discountAmount == null || discountAmount.trim().equals("")) discountAmount = "0";

int paymentAmount = Integer.parseInt(finalPrice);
int pointUsed = Integer.parseInt(usedPoints);
int discount = Integer.parseInt(discountAmount);

if (userId == null || tid == null || pg_token == null || orderId == null) {
    response.sendRedirect("shopping_list.jsp");
    return;
}

Connection dbConn = null;
PreparedStatement pstmt = null;

try {
    // 1. 카카오페이 승인 요청
    URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/approve");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Authorization", "SECRET_KEY DEV6744AB1DFFD5F846D5EFCFC74AD0F03FA0A59");
    conn.setRequestProperty("Content-Type", "application/json");
    conn.setDoOutput(true);

    JSONObject payload = new JSONObject();
    payload.put("cid", "TC0ONETIME");
    payload.put("tid", tid);
    payload.put("partner_order_id", orderId);
    payload.put("partner_user_id", userId);
    payload.put("pg_token", pg_token);

    OutputStream os = conn.getOutputStream();
    os.write(payload.toJSONString().getBytes("UTF-8"));
    os.flush();
    os.close();

    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    StringBuilder sb = new StringBuilder();
    String line;
    while ((line = br.readLine()) != null) {
        sb.append(line);
    }
    br.close();

    // 2. DB 저장
    Class.forName("org.gjt.mm.mysql.Driver");
    dbConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    // 2-1. 주문 저장 (ENUM 정확히 "결제완료")
    String insertOrder = "INSERT INTO orders (order_id, user_id, total_amount, order_status) VALUES (?, ?, ?, ?)";
    pstmt = dbConn.prepareStatement(insertOrder);
    pstmt.setString(1, orderId);
    pstmt.setString(2, userId);
    pstmt.setInt(3, paymentAmount);
    pstmt.setString(4, "결제완료");
    pstmt.executeUpdate();
    pstmt.close();

    // 2-2. 주문 상세 저장
    for (int i = 0; i < productIds.length; i++) {
        String pid = productIds[i];
        int qty = Integer.parseInt(quantities[i]);

        String getPriceSql = "SELECT price FROM product WHERE product_id = ?";
        pstmt = dbConn.prepareStatement(getPriceSql);
        pstmt.setString(1, pid);
        ResultSet rs = pstmt.executeQuery();

        int unitPrice = 0;
        if (rs.next()) {
            unitPrice = Integer.parseInt(rs.getString("price"));
        }
        rs.close();
        pstmt.close();

        int subtotal = unitPrice * qty;

        String insertDetail = "INSERT INTO order_detail (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
        pstmt = dbConn.prepareStatement(insertDetail);
        pstmt.setString(1, orderId);
        pstmt.setString(2, pid);
        pstmt.setInt(3, qty);
        pstmt.setInt(4, unitPrice);
        pstmt.setInt(5, subtotal);
        pstmt.executeUpdate();
        pstmt.close();
    }

    // 2-3. 결제 저장
    String insertPayment = "INSERT INTO payment (order_id, user_id, payment_amount, payment_method, used_points, coupon_code, discount_amount) VALUES (?, ?, ?, ?, ?, ?, ?)";
    pstmt = dbConn.prepareStatement(insertPayment);
    pstmt.setString(1, orderId);
    pstmt.setString(2, userId);
    pstmt.setInt(3, paymentAmount);
    pstmt.setString(4, paymentMethod);
    pstmt.setInt(5, pointUsed);
    pstmt.setString(6, usedCoupon);
    pstmt.setInt(7, discount);
    pstmt.executeUpdate();
    pstmt.close();

} catch (Exception e) {
    // 오류가 나도 쇼핑 성공 페이지로 이동
    // 디버깅 정보 콘솔 출력
    e.printStackTrace();
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (dbConn != null) try { dbConn.close(); } catch (Exception e) {}
}

// 무조건 쇼핑 성공 페이지로 이동
response.sendRedirect("shopping_success.jsp");
%>
