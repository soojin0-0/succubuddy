<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%
request.setCharacterEncoding("euc-kr");
String userId = (String) session.getAttribute("sid");

// 로그인 체크
if (userId == null || userId.trim().equals("")) {
%>
<script>
  alert("로그인 세션이 만료되었습니다. 로그아웃 후 다시 시도해주세요.");
  history.back();
</script>
<%
  return;
}

String diaryIdStr = request.getParameter("diary_id");
String commentText = request.getParameter("comment_text");
String title = request.getParameter("title");
String isSecret = request.getParameter("is_secret");

int diaryId = Integer.parseInt(diaryIdStr);

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    String sql = "INSERT INTO comment (diary_id, user_id, comment_text, comment_ymd, is_secret) VALUES (?, ?, ?, NOW(), ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, diaryId);
    pstmt.setString(2, userId);
    pstmt.setString(3, commentText);
    pstmt.setString(4, isSecret);

    pstmt.executeUpdate();

    // redirect는 여기서 한 번만!
    response.sendRedirect("sub4_text.jsp?diary_id=" + diaryId);
} catch (Exception e) {
    out.println("<script>alert('댓글 저장 중 오류 발생: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
} finally {
    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
