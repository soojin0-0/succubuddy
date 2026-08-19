<%@ page contentType="text/plain; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>

<%
String sid = request.getParameter("sid");
String categoryId = request.getParameter("category_id");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    if (sid != null && categoryId != null) {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr",
            "multi", "abcd"
        );

        // 소유자 검증
        pstmt = conn.prepareStatement("SELECT * FROM diary_category WHERE category_id = ? AND user_id = ?");
        pstmt.setString(1, categoryId);
        pstmt.setString(2, sid);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            rs.close(); pstmt.close();

            pstmt = conn.prepareStatement("DELETE FROM diary_category WHERE category_id = ?");
            pstmt.setString(1, categoryId);
            pstmt.executeUpdate();

            out.print("SUCCESS");
        } else {
            out.print("권한 없음");
        }
    } else {
        out.print("파라미터 오류");
    }
} catch (Exception e) {
    out.print("에러: " + new String(e.getMessage().getBytes("8859_1"), "euc-kr"));
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
