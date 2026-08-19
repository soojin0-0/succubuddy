<%@ page contentType="application/json;charset=euc-kr" %>
<%@ page import="java.sql.*,java.util.*" %>
<%
request.setCharacterEncoding("euc-kr");
String userId = (String) session.getAttribute("sid");
String productId = request.getParameter("product_id");
String potIdStr = request.getParameter("pot_id");

Integer potId = null;
if (potIdStr != null && !potIdStr.trim().equals("")) {
	try { potId = Integer.parseInt(potIdStr.trim()); } catch(Exception e) { potId = null; }
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    String updateSql = "UPDATE cart SET pot_id = ? WHERE user_id = ? AND product_id = ?";
    pstmt = conn.prepareStatement(updateSql);
    if (potId != null) pstmt.setInt(1, potId);
    else pstmt.setNull(1, java.sql.Types.INTEGER);
    pstmt.setString(2, userId);
    pstmt.setString(3, productId);
    int updated = pstmt.executeUpdate();
    pstmt.close();

    if (updated > 0) {
        String sql = "SELECT p.price, IFNULL(po.extra_price, 0) AS pot_price, c.quantity " +
                     "FROM cart c " +
                     "JOIN product p ON c.product_id = p.product_id " +
                     "LEFT JOIN pot po ON c.pot_id = po.pot_id " +
                     "WHERE c.user_id = ? AND c.product_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, productId);
        rs = pstmt.executeQuery();
        int itemTotal = 0;
        if (rs.next()) {
            int price = rs.getInt("price");
            int potPrice = rs.getInt("pot_price");
            int quantity = rs.getInt("quantity");
            itemTotal = (price + potPrice) * quantity;
        }
        rs.close();
        pstmt.close();

        out.print("{\"status\":\"success\",\"item_total\":" + itemTotal + "}");
    } else {
        out.print("{\"status\":\"fail\"}");
    }
} catch(Exception e) {
    out.print("{\"status\":\"fail\",\"msg\":\"" + e.getMessage().replace("\"","") + "\"}");
} finally {
    if (rs != null) try { rs.close(); } catch(Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if (conn != null) try { conn.close(); } catch(Exception e) {}
}
%>
