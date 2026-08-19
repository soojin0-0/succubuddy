<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%
request.setCharacterEncoding("euc-kr"); // ★ 가장 중요: 제일 먼저 선언
%>
<%@ page import="java.sql.*" %>

<%
Connection conn = null;
PreparedStatement pstmt = null;

String result = "";
String sid = request.getParameter("sid");
String category = request.getParameter("category");

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr", "multi", "abcd");

   String sql = "INSERT INTO user_category (sid, category_name) VALUES (?, ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, sid);
    pstmt.setString(2, category);

    int rows = pstmt.executeUpdate();
    if (rows > 0) {
        result = "success";
    } else {
        result = "fail";
    }

} catch (Exception e) {
    result = "등록 실패: " + e.getMessage(); // 한글 포함된 오류 표시
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}

// 응답
response.setContentType("text/plain; charset=euc-kr");
out.print(result);
%>
