<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.io.*, java.net.*, java.sql.*, java.util.*, org.json.simple.*, org.json.simple.parser.*" %>
<%
request.setCharacterEncoding("euc-kr");

String userId = (String) session.getAttribute("sid");
String pgToken = request.getParameter("pg_token");
String tid = (String) session.getAttribute("tid");
String orderId = (String) session.getAttribute("order_id");
String finalPrice = (String) session.getAttribute("final_price");
String paymentMethod = (String) session.getAttribute("payment_method");

if (userId == null || pgToken == null || tid == null || orderId == null || finalPrice == null || paymentMethod == null) {
    out.println("<script>alert('세션 또는 결제 정보가 누락되었습니다.'); location.href='login.jsp';</script>");
    return;
}

try {
    // 카카오페이 승인 요청
    URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/approve");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setRequestProperty("Authorization", "SECRET_KEY DEV7016D3E3039AE6C7AB25D71858C01AF533918");
    conn.setRequestProperty("Content-Type", "application/json");
    conn.setDoOutput(true);

    JSONObject json = new JSONObject();
    json.put("cid", "TC0ONETIME");
    json.put("tid", tid);
    json.put("partner_order_id", orderId);
    json.put("partner_user_id", userId);
    json.put("pg_token", pgToken);

    OutputStream os = conn.getOutputStream();
    os.write(json.toString().getBytes("UTF-8"));
    os.flush();
    os.close();

    int responseCode = conn.getResponseCode();
    InputStream responseStream = (responseCode == 200) ? conn.getInputStream() : conn.getErrorStream();
    BufferedReader reader = new BufferedReader(new InputStreamReader(responseStream, "UTF-8"));
    StringBuilder sb = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
        sb.append(line);
    }
    reader.close();

    JSONParser parser = new JSONParser();
    JSONObject res = (JSONObject) parser.parse(sb.toString());

    // DB 저장
    Class.forName("org.gjt.mm.mysql.Driver");
    Connection dbConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    String insertSql = "INSERT INTO payment (order_id, payment_amount, payment_method, payment_status) VALUES (?, ?, ?, '성공')";
    PreparedStatement pstmt = dbConn.prepareStatement(insertSql);
    pstmt.setString(1, orderId);
    pstmt.setInt(2, Integer.parseInt(finalPrice));
    pstmt.setString(3, paymentMethod);

    int result = pstmt.executeUpdate();
    pstmt.close();
    dbConn.close();

    if (result > 0) {
        response.sendRedirect("shopping_success.jsp");
    } else {
        out.println("<script>alert('결제는 승인되었으나 DB 저장 실패'); history.back();</script>");
    }

} catch (Exception e) {
    out.println("<script>alert('카카오페이 승인 오류: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
    StringWriter sw = new StringWriter();
    PrintWriter pw = new PrintWriter(sw);
    e.printStackTrace(pw);
    out.println("<pre>" + sw.toString() + "</pre>");
}
%>
