<%@ page contentType="text/plain; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>  <%-- 반드시 필요 --%>

<%
    request.setCharacterEncoding("euc-kr");

    String sid = (String) session.getAttribute("sid");
    String category = request.getParameter("category");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

        ps = conn.prepareStatement("DELETE FROM user_category WHERE sid = ? AND category_name = ?");
        ps.setString(1, sid);
        ps.setString(2, category);
        int rows = ps.executeUpdate();

        out.print("OK");
    } catch (Exception e) {
        e.printStackTrace();
        out.print("에러 발생");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
