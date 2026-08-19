<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.io.*" %>

<%
    String userId = (String) session.getAttribute("sid"); // 세션 키 변경
    String productId = request.getParameter("product_id");
    String quantity = request.getParameter("quantity");

    if (userId == null) {
        out.print("error: not_logged_in"); 
        return;
    }

    String DB_URL = "jdbc:mysql://localhost:3306/succu";
    String DB_ID = "multi";
    String DB_PASSWORD = "abcd";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        // 수량 업데이트 쿼리
        String sql = "UPDATE cart SET quantity = ? WHERE product_id = ? AND user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, quantity);
        pstmt.setString(2, productId);
        pstmt.setString(3, userId);

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            // 업데이트된 가격 가져오기
            String priceSql = "SELECT price FROM product WHERE product_id = ?";
            pstmt = conn.prepareStatement(priceSql);
            pstmt.setString(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int price = rs.getInt("price");
                int totalPrice = price * Integer.parseInt(quantity);
                out.print(String.format("%,d", totalPrice));  // 변경된 가격을 '1,000' 형식으로 전송
            }
        } else {
            out.print("error: update_failed");
        }

    } catch (Exception e) {
        out.print("error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
