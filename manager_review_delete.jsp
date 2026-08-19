<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("euc-kr");

    String reviewId = request.getParameter("review_id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR",
            "multi",
            "abcd"
        );

        String sql = "DELETE FROM review WHERE review_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(reviewId));

        int result = pstmt.executeUpdate();

        pstmt.close();
        conn.close();

        if (result > 0) {
%>
    <script>
        alert("리뷰가 정상적으로 삭제되었습니다.");
        location.href = "manager_review.jsp";
    </script>
<%
        } else {
%>
    <script>
        alert("리뷰 삭제에 실패했습니다.");
        location.href = "manager_review.jsp";
    </script>
<%
        }

    } catch(Exception e) {
        e.printStackTrace();
%>
    <script>
        alert("오류가 발생했습니다.");
        location.href = "manager_review.jsp";
    </script>
<%
    }
%>
