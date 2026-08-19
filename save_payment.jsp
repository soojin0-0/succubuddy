<%@ page contentType="text/html;charset=euc-kr" session="true" %>
<%@ page import="java.io.*, java.sql.*, java.util.*, org.json.simple.*, org.json.simple.parser.*, java.net.*" %>

<%
request.setCharacterEncoding("euc-kr");

String userId = (String) session.getAttribute("sid");
String tid = (String) session.getAttribute("tid");
String orderId = (String) session.getAttribute("order_id");
String pgToken = request.getParameter("pg_token");

String paymentMethod = request.getParameter("payment_method");
String productIdsParam = request.getParameter("product_ids");
String quantitiesParam = request.getParameter("quantities");
String usedPoints = request.getParameter("usedPoints");
String usedCoupon = request.getParameter("usedCoupon");
String finalPrice = request.getParameter("finalPrice");
String discountAmount = request.getParameter("discountAmount");

if (usedPoints == null || usedPoints.isEmpty()) usedPoints = "0";
if (discountAmount == null || discountAmount.isEmpty()) discountAmount = "0";
if (finalPrice == null || finalPrice.isEmpty()) finalPrice = "0";

int usedPointsValue = Integer.parseInt(usedPoints.replaceAll("[^0-9]", ""));
int discountAmountValue = Integer.parseInt(discountAmount.replaceAll("[^0-9]", ""));
int finalPriceValue = Integer.parseInt(finalPrice.replaceAll("[^0-9]", ""));

String[] productIds = productIdsParam != null ? productIdsParam.split(",") : new String[0];
String[] quantities = quantitiesParam != null ? quantitiesParam.split(",") : new String[0];

// 유효성 검사
if (userId == null || userId.isEmpty() || productIds.length == 0 || productIds.length != quantities.length || paymentMethod == null) {
	out.println("<script>alert('결제 정보가 올바르지 않습니다.'); history.back();</script>");
	return;
}

// DB 연결 정보
String url = "jdbc:mysql://localhost:3306/succu";
String dbUser = "multi";
String dbPassword = "abcd";

Connection conn = null;
PreparedStatement pstmt = null;

try {
	Class.forName("org.gjt.mm.mysql.Driver");
	conn = DriverManager.getConnection(url, dbUser, dbPassword);

	// 카카오페이 결제 승인 요청
	if ("카카오페이".equals(paymentMethod)) {
		if (tid == null || pgToken == null || orderId == null) {
			out.println("<script>alert('카카오페이 인증 정보가 누락되었습니다.'); history.back();</script>");
			return;
		}

		URL urlObj = new URL("https://open-api.kakaopay.com/online/v1/payment/approve");
		HttpURLConnection httpConn = (HttpURLConnection) urlObj.openConnection();
		httpConn.setRequestMethod("POST");
		httpConn.setRequestProperty("Authorization", "SECRET_KEY DEV6744AB1DFFD5F846D5EFCFC74AD0F03FA0A59"); // ← 너의 실 서비스 secret key로 변경
		httpConn.setRequestProperty("Content-type", "application/x-www-form-urlencoded;charset=UTF-8");
		httpConn.setDoOutput(true);

		String param = "cid=TC0ONETIME"
			+ "&tid=" + tid
			+ "&partner_order_id=" + orderId
			+ "&partner_user_id=" + userId
			+ "&pg_token=" + pgToken;

		OutputStream os = httpConn.getOutputStream();
		os.write(param.getBytes("UTF-8"));
		os.flush();
		os.close();

		BufferedReader reader = new BufferedReader(new InputStreamReader(httpConn.getInputStream(), "UTF-8"));
		StringBuilder result = new StringBuilder();
		String line;
		while ((line = reader.readLine()) != null) {
			result.append(line);
		}
		reader.close();

		// 응답 파싱
		JSONParser parser = new JSONParser();
		JSONObject json = (JSONObject) parser.parse(result.toString());
	}

	// 주문 저장
	String orderSql = "INSERT INTO orders (order_id, user_id, total_amount, order_status) VALUES (?, ?, ?, '결제완료')";
	pstmt = conn.prepareStatement(orderSql);
	pstmt.setString(1, orderId);
	pstmt.setString(2, userId);
	pstmt.setInt(3, finalPriceValue);
	pstmt.executeUpdate();
	pstmt.close();

	// 주문 상세 저장
	// 주문 상세 저장 - 화분 포함
	String getDetailSql = "SELECT c.product_id, p.price, c.quantity, c.pot_id, po.pot_name, IFNULL(po.extra_price, 0) AS pot_price " +
						  "FROM cart c " +
						  "JOIN product p ON c.product_id = p.product_id " +
						  "LEFT JOIN pot po ON c.pot_id = po.pot_id " +
						  "WHERE c.user_id = ? AND c.product_id = ?";

	PreparedStatement getDetailStmt = conn.prepareStatement(getDetailSql);

	String insertDetailSql = "INSERT INTO order_detail (order_id, product_id, quantity, unit_price, subtotal, pot_id, pot_name, pot_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement detailStmt = conn.prepareStatement(insertDetailSql);

	for (int i = 0; i < productIds.length; i++) {
		String pid = productIds[i].trim();
		getDetailStmt.setString(1, userId);
		getDetailStmt.setString(2, pid);
		ResultSet rs = getDetailStmt.executeQuery();

		if (rs.next()) {
			int unitPrice = rs.getInt("price");
			int quantity = rs.getInt("quantity");
			int potId = rs.getInt("pot_id");
			String potName = rs.getString("pot_name");
			int potPrice = rs.getInt("pot_price");
			int subtotal = (unitPrice + potPrice) * quantity;

			detailStmt.setString(1, orderId);
			detailStmt.setString(2, pid);
			detailStmt.setInt(3, quantity);
			detailStmt.setInt(4, unitPrice);
			detailStmt.setInt(5, subtotal);
			detailStmt.setInt(6, potId);
			detailStmt.setString(7, potName);
			detailStmt.setInt(8, potPrice);
			detailStmt.executeUpdate();
		}
		rs.close();
	}
	getDetailStmt.close();
	detailStmt.close();


	// 결제 정보 저장
	String paymentSql = "INSERT INTO payment (order_id, user_id, payment_amount, payment_method, used_points, coupon_code, discount_amount) VALUES (?, ?, ?, ?, ?, ?, ?)";
	pstmt = conn.prepareStatement(paymentSql);
	pstmt.setString(1, orderId);
	pstmt.setString(2, userId);
	pstmt.setInt(3, finalPriceValue);
	pstmt.setString(4, paymentMethod);
	pstmt.setInt(5, usedPointsValue);
	pstmt.setString(6, (usedCoupon != null && !usedCoupon.isEmpty()) ? usedCoupon : null);
	pstmt.setInt(7, discountAmountValue);
	pstmt.executeUpdate();
	pstmt.close();

	// 포인트 사용 저장
	if (usedPointsValue > 0) {
		String pointSql = "INSERT INTO point_history (user_id, order_id, used_points, created_at) VALUES (?, ?, ?, NOW())";
		pstmt = conn.prepareStatement(pointSql);
		pstmt.setString(1, userId);
		pstmt.setString(2, orderId);
		pstmt.setInt(3, usedPointsValue);
		pstmt.executeUpdate();
		pstmt.close();
	}

	// 쿠폰 제거
	if (usedCoupon != null && !usedCoupon.isEmpty()) {
		String deleteCouponSql = "DELETE FROM coupon WHERE coupon_id = ? AND user_id = ?";
		pstmt = conn.prepareStatement(deleteCouponSql);
		pstmt.setString(1, usedCoupon);
		pstmt.setString(2, userId);
		pstmt.executeUpdate();
		pstmt.close();
	}

	// 장바구니 삭제
	String deleteCartSql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
	pstmt = conn.prepareStatement(deleteCartSql);
	for (String pid : productIds) {
		pstmt.setString(1, userId);
		pstmt.setString(2, pid.trim());
		pstmt.executeUpdate();
	}
	pstmt.close();

	// 성공 이동
	out.println("<script>location.href='shopping_success.jsp';</script>");

} catch (Exception e) {
	e.printStackTrace();
	out.println("<script>alert('결제 실패: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
} finally {
	try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
	try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>