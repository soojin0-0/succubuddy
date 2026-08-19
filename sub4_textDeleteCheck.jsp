<%@ page import="java.sql.*" contentType="text/html; charset=euc-kr" %>
<%
request.setCharacterEncoding("euc-kr");

String pw = request.getParameter("pw");
String diaryIdParam = request.getParameter("diary_id");

if (pw == null || diaryIdParam == null || !diaryIdParam.matches("\\d+")) {
    out.println("<script>alert('잘못된 요청입니다.'); history.back();</script>");
    return;
}

int diaryId = Integer.parseInt(diaryIdParam);

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    // 비밀번호 확인
    pstmt = conn.prepareStatement("SELECT password FROM sub4_write WHERE diary_id = ?");
    pstmt.setInt(1, diaryId);
    rs = pstmt.executeQuery();

    boolean isMatch = false;
    if (rs.next()) {
        String dbPw = rs.getString("password");
        if (dbPw != null && dbPw.equals(pw)) isMatch = true;
    }
    rs.close();
    pstmt.close();

    if (!isMatch) {
        out.println("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    // 대댓글 먼저 삭제
    pstmt = conn.prepareStatement("DELETE FROM reply WHERE comment_id IN (SELECT comment_id FROM comment WHERE diary_id = ?)");
    pstmt.setInt(1, diaryId);
    pstmt.executeUpdate();
    pstmt.close();

    // 댓글 삭제
    pstmt = conn.prepareStatement("DELETE FROM comment WHERE diary_id = ?");
    pstmt.setInt(1, diaryId);
    pstmt.executeUpdate();
    pstmt.close();

    // 게시물 삭제
    pstmt = conn.prepareStatement("DELETE FROM sub4_write WHERE diary_id = ?");
    pstmt.setInt(1, diaryId);
    pstmt.executeUpdate();
    pstmt.close();

    conn.close();

    out.println("<script>alert('삭제가 완료되었습니다.'); location.href='sub4.jsp';</script>");

} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('삭제 중 오류가 발생했습니다: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
}
%>
