<%@ page import="java.sql.*" %>
<%@ page contentType="text/plain;charset=euc-kr" %>
<%
String userId = request.getParameter("user_id");
String productId = request.getParameter("product_id");
String result = "error";

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    // 찜 여부 확인
    String checkSql = "SELECT * FROM favorite WHERE user_id = ? AND product_id = ?";
    PreparedStatement checkPstmt = conn.prepareStatement(checkSql);
    checkPstmt.setString(1, userId);
    checkPstmt.setString(2, productId);
    ResultSet rs = checkPstmt.executeQuery();

    if (rs.next()) {
        // 삭제
        PreparedStatement del = conn.prepareStatement("DELETE FROM favorite WHERE user_id = ? AND product_id = ?");
        del.setString(1, userId);
        del.setString(2, productId);
        del.executeUpdate();
        del.close();
        result = "removed";
    } else {
        // 추가
        PreparedStatement ins = conn.prepareStatement("INSERT INTO favorite(user_id, product_id) VALUES (?, ?)");
        ins.setString(1, userId);
        ins.setString(2, productId);
        ins.executeUpdate();
        ins.close();
        result = "added";
    }

    rs.close(); checkPstmt.close(); conn.close();
} catch (Exception e) {
    result = "error";
}
out.print(result);
%>
