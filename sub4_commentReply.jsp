<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%
request.setCharacterEncoding("euc-kr");

String diaryId = request.getParameter("diary_id");
String parentId = request.getParameter("parent_id");
String commentText = request.getParameter("comment_text");
String userId = (String) session.getAttribute("sid");
String isSecret = request.getParameter("is_secret");

if (isSecret == null) isSecret = "0";  // 누락 방지

// 로그인 체크
if (userId == null || userId.trim().equals("")) {
%>
<script>
  alert("로그인이 필요합니다.");
  history.back();
</script>
<%
  return;
}

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    String sql = "INSERT INTO reply (comment_id, user_id, reply_text, reply_ymd, is_secret) VALUES (?, ?, ?, NOW(), ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(parentId));
    pstmt.setString(2, userId);
    pstmt.setString(3, commentText);
    pstmt.setString(4, isSecret);

    int result = pstmt.executeUpdate();

    if (result > 0) {
        response.sendRedirect("sub4_text.jsp?diary_id=" + diaryId);
    } else {
%>
<script>
  alert("대댓글 저장 실패");
  history.back();
</script>
<%
    }

} catch (Exception e) {
%>
<script>
  alert("에러 발생: <%= e.getMessage().replace("'", "") %>");
  history.back();
</script>
<%
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
    if (conn != null) try { conn.close(); } catch (SQLException e) {}
}
%>
