<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.net.*" %>
<%
request.setCharacterEncoding("UTF-8");

String title = request.getParameter("title");
String status = request.getParameter("status");
String sid = (String) session.getAttribute("sid");

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=UTF-8",
        "multi", "abcd"
    );

    String sql = "UPDATE sub4_write SET status = ? WHERE title = ? AND user_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, status);
    pstmt.setString(2, title);
    pstmt.setString(3, sid);

    int updated = pstmt.executeUpdate();
    out.print(updated > 0 ? "OK" : "FAIL");

} catch (Exception e) {
    e.printStackTrace();
    out.print("ERROR");
} finally {
    try { if (pstmt != null) pstmt.close(); } catch (Exception ignore) {}
    try { if (conn != null) conn.close(); } catch (Exception ignore) {}
}
%>
