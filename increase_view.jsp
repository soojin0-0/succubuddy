<%@ page contentType="text/plain;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>

<%
request.setCharacterEncoding("euc-kr");
String itemIdParam = request.getParameter("item_id");
int itemId = 0;

if (itemIdParam != null && itemIdParam.matches("\\d+")) {
    itemId = Integer.parseInt(itemIdParam);
}

int updatedViews = -1;
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    // 1. 조회수 증가
    ps = conn.prepareStatement("UPDATE sub4_items SET views = views + 1 WHERE item_id = ?");
    ps.setInt(1, itemId);
    ps.executeUpdate();
    ps.close();

    // 2. 증가된 조회수 다시 조회
    ps = conn.prepareStatement("SELECT views FROM sub4_items WHERE item_id = ?");
    ps.setInt(1, itemId);
    rs = ps.executeQuery();
    if (rs.next()) {
        updatedViews = rs.getInt("views");
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}

// 클라이언트에 증가된 조회수 반환
out.print(updatedViews);
%>
