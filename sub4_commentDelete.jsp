<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<%
String commentId = request.getParameter("comment_id");
String replyId = request.getParameter("reply_id");
String diaryId = request.getParameter("diary_id");

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    if (commentId != null && !commentId.equals("")) {
        // 댓글 삭제 전에 대댓글 먼저 삭제 (외래키 제약이 있을 수 있음)
        pstmt = conn.prepareStatement("DELETE FROM reply WHERE comment_id = ?");
        pstmt.setString(1, commentId);
        pstmt.executeUpdate();
        pstmt.close();

        pstmt = conn.prepareStatement("DELETE FROM comment WHERE comment_id = ?");
        pstmt.setString(1, commentId);
        pstmt.executeUpdate();
        pstmt.close();
    } else if (replyId != null && !replyId.equals("")) {
        pstmt = conn.prepareStatement("DELETE FROM reply WHERE reply_id = ?");
        pstmt.setString(1, replyId);
        pstmt.executeUpdate();
        pstmt.close();
    }

    conn.close();

    response.sendRedirect("sub4_text.jsp?diary_id=" + diaryId);

} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('삭제 중 오류 발생: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
}
%>
