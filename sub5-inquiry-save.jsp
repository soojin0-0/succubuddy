<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
request.setCharacterEncoding("euc-kr");

String userId = request.getParameter("user_id");
String inquirySubject = request.getParameter("inquiry_subject");
String inquiryText = request.getParameter("inquiry_text");
String inquiryPswd = request.getParameter("inquiry_pswd");

Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    String sql = "INSERT INTO inquiry (user_id, product_id, inquiry_subject, inquiry_text, inquiry_ymd, inquiry_pswd) " +
                 "VALUES (?, NULL, ?, ?, NOW(), ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, userId);
    pstmt.setString(2, inquirySubject);
    pstmt.setString(3, inquiryText);
	pstmt.setString(4, inquiryPswd);

    int result = pstmt.executeUpdate();

    if (result > 0) {
%>
    <script>
        alert("문의가 등록되었습니다.");
        location.href = "sub5-inquiry.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("문의 등록에 실패했습니다.");
        history.back();
    </script>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
    <script>
        alert("오류 발생: <%= e.getMessage() %>");
        history.back();
    </script>
<%
} finally {
    try {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
