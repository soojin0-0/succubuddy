<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("euc-kr");

    String inquiryId = request.getParameter("inquiry_id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR",
            "multi",
            "abcd"
        );

        String sql = "DELETE FROM inquiry WHERE inquiry_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(inquiryId));

        int result = pstmt.executeUpdate();

        pstmt.close();
        conn.close();

        if (result > 0) {
%>
    <script>
        alert("문의가 정상적으로 삭제되었습니다.");
        location.href = "manager_inquiry.jsp";
    </script>
<%
        } else {
%>
    <script>
        alert("문의 삭제에 실패했습니다.");
        location.href = "manager_inquiry.jsp";
    </script>
<%
        }

    } catch(Exception e) {
        e.printStackTrace();
%>
    <script>
        alert("오류가 발생했습니다.");
        location.href = "manager_inquiry.jsp";
    </script>
<%
    }
%>
