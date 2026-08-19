<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("euc-kr");

String userId = request.getParameter("user_id");
String productId = request.getParameter("product_id");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    String checkSql = "SELECT * FROM favorite WHERE user_id = ? AND product_id = ?";
    pstmt = conn.prepareStatement(checkSql);
    pstmt.setString(1, userId);
    pstmt.setString(2, productId);
    rs = pstmt.executeQuery();

    boolean exists = rs.next();
    rs.close(); pstmt.close();

    if (exists) {
        String deleteSql = "DELETE FROM favorite WHERE user_id = ? AND product_id = ?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setString(1, userId);
        pstmt.setString(2, productId);
        pstmt.executeUpdate();
        out.print("deleted");
    } else {
        String insertSql = "INSERT INTO favorite (user_id, product_id) VALUES (?, ?)";
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, userId);
        pstmt.setString(2, productId);
        pstmt.executeUpdate();
        out.print("inserted");
    }
} catch (Exception e) {
    out.print("error: " + e.getMessage());  // 이걸로 에러 로그 확인 가능
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
