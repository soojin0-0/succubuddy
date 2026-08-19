<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>

<%
request.setCharacterEncoding("euc-kr");

int review_id = Integer.parseInt(request.getParameter("review_id"));
int review_score = Integer.parseInt(request.getParameter("review_score"));
String review_text = request.getParameter("review_text");
String inputPswd = request.getParameter("review_pswd");

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

boolean isValid = false;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

    // 비밀번호 확인
    String checkSql = "SELECT review_pswd FROM review WHERE review_id = ?";
    pstmt = conn.prepareStatement(checkSql);
    pstmt.setInt(1, review_id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        String dbPswd = rs.getString("review_pswd");
        if (dbPswd.equals(inputPswd)) {
            isValid = true;
        }
    }
    rs.close();
    pstmt.close();

    if (isValid) {
        // 비밀번호 일치 시 리뷰 수정
        String updateSql = "UPDATE review SET review_score = ?, review_text = ?, review_ymd = NOW() WHERE review_id = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setInt(1, review_score);
        pstmt.setString(2, review_text);
        pstmt.setInt(3, review_id);

        int result = pstmt.executeUpdate();

        if (result > 0) {
%>
<script>
    alert("리뷰가 성공적으로 수정되었습니다.");
    location.href = "myReview.jsp";
</script>
<%
        } else {
%>
<script>
    alert("리뷰 수정에 실패했습니다.");
    history.back();
</script>
<%
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