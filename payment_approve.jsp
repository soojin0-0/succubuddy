<%@ page contentType="text/html;charset=euc-kr" session="true" %>
<%@ page import="java.io.*, java.net.*, java.util.*, org.json.*" %>

<%
    request.setCharacterEncoding("euc-kr");

    String userId = (String) session.getAttribute("sid");
    String orderId = (String) session.getAttribute("order_id");
    String tid = (String) session.getAttribute("tid");
    String pgToken = request.getParameter("pg_token");

    if (userId == null || orderId == null || tid == null || pgToken == null) {
        out.println("<script>alert('결제 정보가 올바르지 않습니다.'); history.back();</script>");
        return;
    }

    String secretKey = "PRD725C99D4FA4EC129788DF8EC542DBD687DD61";

    URL url = new URL("https://open-api.kakaopay.com/v1/payment/approve");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();

    conn.setRequestMethod("POST");
    conn.setRequestProperty("Authorization", "KakaoAK " + secretKey.trim());
    conn.setRequestProperty("Content-Type", "application/json");
    conn.setDoOutput(true);

    JSONObject jsonData = new JSONObject();
    jsonData.put("cid", "TC0ONETIME");
    jsonData.put("tid", tid);
    jsonData.put("partner_order_id", orderId);
    jsonData.put("partner_user_id", userId);
    jsonData.put("pg_token", pgToken);

    try (OutputStream outputStream = conn.getOutputStream()) {
        outputStream.write(jsonData.toString().getBytes("euc-kr"));
        outputStream.flush();
    }

    int responseCode = conn.getResponseCode();
    BufferedReader br = new BufferedReader(new InputStreamReader(
        responseCode == 200 ? conn.getInputStream() : conn.getErrorStream(), "euc-kr"));

    StringBuilder responseData = new StringBuilder();
    String line;
    while ((line = br.readLine()) != null) {
        responseData.append(line);
    }
    br.close();

    if (responseCode == 200) {
        JSONObject jsonResponse = new JSONObject(responseData.toString());
        out.println("<script>alert('결제 성공! 주문번호: " + jsonResponse.getString("partner_order_id") + "'); location.href='shopping_success.jsp';</script>");
    } else {
        out.println("<script>alert('결제 승인 실패: " + responseData.toString() + "'); history.back();</script>");
    }
%>
