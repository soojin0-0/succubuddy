<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("euc-kr");

String loginId = (String) session.getAttribute("sid"); // 세션에서 가져오기
String latStr = request.getParameter("latitude");
String lngStr = request.getParameter("longitude");
%>

<pre>
sid: <%= loginId %>
latitude: <%= latStr != null ? latStr : "null" %>
longitude: <%= lngStr != null ? lngStr : "null" %>
</pre>

<%
if (loginId != null && latStr != null && lngStr != null && !latStr.isEmpty() && !lngStr.isEmpty()) {
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

        pstmt = conn.prepareStatement("UPDATE user SET latitude = ?, longitude = ? WHERE user_id = ?");
        pstmt.setDouble(1, Double.parseDouble(latStr));
        pstmt.setDouble(2, Double.parseDouble(lngStr));
        pstmt.setString(3, loginId);
        pstmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
} else {
%>
<pre>파라미터 부족 또는 로그인 세션 없음</pre>
<%
}
%>
