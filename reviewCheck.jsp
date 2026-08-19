<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>

<%
request.setCharacterEncoding("euc-kr");

int review_id = Integer.parseInt(request.getParameter("review_id"));
String pswd = request.getParameter("pswd");
String mode = request.getParameter("mode");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

boolean valid = false;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

    String sql = "SELECT review_pswd FROM review WHERE review_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, review_id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        String dbPswd = rs.getString("review_pswd");
        if (dbPswd.equals(pswd)) {
            valid = true;
        }
    }

    rs.close();
    pstmt.close();

    if (valid) {
        if ("edit".equals(mode)) {
            response.sendRedirect("myReviewEdit.jsp?review_id=" + review_id);
        } else if ("delete".equals(mode)) {
            String deleteSql = "DELETE FROM review WHERE review_id = ?";
            pstmt = conn.prepareStatement(deleteSql);
            pstmt.setInt(1, review_id);
            int result = pstmt.executeUpdate();

            if (result > 0) {
%>
<script>
    alert("리뷰가 삭제되었습니다.");
    location.href = "myReview.jsp";
</script>
<%
            } else {
%>
<script>
    alert("리뷰 삭제에 실패했습니다.");
    history.back();
</script>
<%
            }
        }
    } else {
%>
<script>
    alert("비밀번호가 일치하지 않습니다.");
    history.back();
</script>
<%
    }

} catch (Exception e) {
%>
<script>
    alert("오류 발생: <%= e.getMessage() %>");
    history.back();
</script>
<%
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>