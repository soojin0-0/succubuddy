<%@ page import="java.sql.*" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%
String userId = request.getParameter("user_id");
String productId = request.getParameter("product_id");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    String sql = "SELECT * FROM favorite WHERE user_id = ? AND product_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, userId);
    pstmt.setString(2, productId);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        out.print("exists");
    } else {
        out.print("none");
    }

} catch (Exception e) {
    out.print("error");
} finally {
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
}
%>
