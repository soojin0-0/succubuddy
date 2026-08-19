<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.io.*, java.net.*, java.sql.*, java.util.*, org.json.simple.*, org.json.simple.parser.*" %>

<%
request.setCharacterEncoding("euc-kr");
String userId = (String) session.getAttribute("sid");
if (userId == null || userId.equals("")) {
    out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
    return;
}

String step = request.getParameter("step");

if ("approve".equals(step)) {
    //  결제 승인 단계
    String pg_token = request.getParameter("pg_token");
    String tid = (String) session.getAttribute("tid");
    String orderId = (String) session.getAttribute("order_id");

    String[] productIds = (String[]) session.getAttribute("product_ids");
    String[] quantities = (String[]) session.getAttribute("quantities");
    String[] potIds = (String[]) session.getAttribute("pot_ids");
    String[] potPrices = (String[]) session.getAttribute("pot_prices");

    String usedPoints = (String) session.getAttribute("usedPoints");
    String usedCoupon = (String) session.getAttribute("usedCoupon");
    String finalPrice = (String) session.getAttribute("finalPrice");

    try {
        // 1. KakaoPay 승인 요청
        URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/approve");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "SECRET_KEY DEV6744AB1DFFD5F846D5EFCFC74AD0F03FA0A59");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        JSONObject json = new JSONObject();
        json.put("cid", "TC0ONETIME");
        json.put("tid", tid);
        json.put("partner_order_id", orderId);
        json.put("partner_user_id", userId);
        json.put("pg_token", pg_token);

        OutputStream os = conn.getOutputStream();
        os.write(json.toString().getBytes("UTF-8"));
        os.flush(); os.close();

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder(); String line;
        while ((line = reader.readLine()) != null) sb.append(line);
        reader.close();

        // 2. DB 저장 처리
        Class.forName("org.gjt.mm.mysql.Driver");
        Connection dbConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

        // 주문 저장
        PreparedStatement ps = dbConn.prepareStatement("INSERT INTO orders (order_id, user_id, order_date) VALUES (?, ?, NOW())");
        ps.setString(1, orderId);
        ps.setString(2, userId);
        ps.executeUpdate();
        ps.close();

        // 주문 상세 저장 (pot 정보 포함)
        ps = dbConn.prepareStatement("INSERT INTO order_detail (order_id, product_id, quantity, pot_id, pot_price) VALUES (?, ?, ?, ?, ?)");
        for (int i = 0; i < productIds.length; i++) {
            ps.setString(1, orderId);
            ps.setString(2, productIds[i]);
            ps.setInt(3, Integer.parseInt(quantities[i]));
            ps.setString(4, potIds != null && potIds.length > i ? potIds[i] : null);
            ps.setInt(5, potPrices != null && potPrices.length > i ? Integer.parseInt(potPrices[i]) : 0);
            ps.executeUpdate();
        }
        ps.close();

        // 결제 정보 저장
        ps = dbConn.prepareStatement("INSERT INTO payment (user_id, order_id, payment_method, payment_amount, used_points, used_coupon, payment_date) VALUES (?, ?, ?, ?, ?, ?, NOW())");
        ps.setString(1, userId);
        ps.setString(2, orderId);
        ps.setString(3, "카카오페이");
        ps.setInt(4, Integer.parseInt(finalPrice));
        ps.setInt(5, usedPoints != null ? Integer.parseInt(usedPoints) : 0);
        ps.setString(6, usedCoupon != null ? usedCoupon : "");
        ps.executeUpdate();
        ps.close();

        // 포인트 적립
        if (usedPoints == null || usedPoints.equals("0")) {
            ps = dbConn.prepareStatement("INSERT INTO point (user_id, points) VALUES (?, 500) ON DUPLICATE KEY UPDATE points = points + 500");
            ps.setString(1, userId);
            ps.executeUpdate();
            ps.close();
        }

        dbConn.close();
        response.sendRedirect("shopping_success.jsp");

    } catch (Exception e) {
        out.println("<script>alert('카카오페이 승인 오류: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
    }
    return;
}

//  결제 준비 단계
String[] productIds = request.getParameterValues("product_ids");
String[] quantities = request.getParameterValues("quantities");
String[] potIds = request.getParameterValues("pot_id");
String[] potPrices = request.getParameterValues("potPrice");

String paymentMethod = request.getParameter("payment_method");
String usedCoupon = request.getParameter("usedCoupon");
String usedPoints = request.getParameter("usedPoints");
String finalPrice = request.getParameter("finalPrice");

if (productIds == null || quantities == null || finalPrice == null || finalPrice.equals("")) {
    out.println("<script>alert('결제 정보가 부족합니다.'); history.back();</script>");
    return;
}

String itemName = (productIds.length == 1) ? productIds[0] : productIds[0] + " 외 " + (productIds.length - 1) + "건";

try {
    URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/ready");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Authorization", "SECRET_KEY DEV6744AB1DFFD5F846D5EFCFC74AD0F03FA0A59");
    conn.setRequestProperty("Content-Type", "application/json");
    conn.setDoOutput(true);

    JSONObject json = new JSONObject();
    json.put("cid", "TC0ONETIME");
    json.put("partner_order_id", "ORD" + System.currentTimeMillis());
    json.put("partner_user_id", userId);
    json.put("item_name", itemName);
    json.put("quantity", 1);
    json.put("total_amount", Integer.parseInt(finalPrice));
    json.put("tax_free_amount", 0);
    json.put("approval_url", "http://localhost:8080/succu/kakao_payment_process.jsp?step=approve");
    json.put("cancel_url", "http://localhost:8080/succu/shopping_order_payment.jsp");
    json.put("fail_url", "http://localhost:8080/succu/shopping_order_payment.jsp");

    OutputStream os = conn.getOutputStream();
    os.write(json.toString().getBytes("UTF-8"));
    os.flush(); os.close();

    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    StringBuilder sb = new StringBuilder(); String line;
    while ((line = reader.readLine()) != null) sb.append(line);
    reader.close();

    JSONParser parser = new JSONParser();
    JSONObject res = (JSONObject) parser.parse(sb.toString());

    // 세션 저장
    session.setAttribute("tid", res.get("tid"));
    session.setAttribute("order_id", json.get("partner_order_id"));
    session.setAttribute("product_ids", productIds);
    session.setAttribute("quantities", quantities);
    session.setAttribute("pot_ids", potIds);
    session.setAttribute("pot_prices", potPrices);
    session.setAttribute("usedPoints", usedPoints);
    session.setAttribute("usedCoupon", usedCoupon);
    session.setAttribute("finalPrice", finalPrice);
    session.setAttribute("payment_method", paymentMethod);

    response.sendRedirect((String) res.get("next_redirect_pc_url"));

} catch (Exception e) {
    out.println("<script>alert('카카오페이 준비 오류: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
}
%>
