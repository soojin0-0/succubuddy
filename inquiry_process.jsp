<%@ page contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("EUC-KR");

    String product_id = request.getParameter("product_id");
    String inquiry_subject = request.getParameter("inquirySubject");
    String inquiry_text = request.getParameter("inquiryText");
    String inquiry_pswd = request.getParameter("inquiryPswd");

    // 로그인한 사용자의 user_id 가져오기 (세션에서 불러오기)
    String user_id = (String) session.getAttribute("sid");

    if (user_id == null) {
%>
        <script>
            alert("로그인이 필요합니다.");
            location.href = "login.jsp";
        </script>
<%
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

        String sql = "INSERT INTO inquiry (user_id, product_id, inquiry_subject, inquiry_text, inquiry_pswd, inquiry_ymd) VALUES (?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, user_id);
        pstmt.setString(2, product_id);
        pstmt.setString(3, inquiry_subject);
        pstmt.setString(4, inquiry_text);
        pstmt.setString(5, inquiry_pswd);

        int result = pstmt.executeUpdate();

        if (result > 0) {
%>
            <script>
                alert("문의가 등록되었습니다.");
                window.location.href = "productDetail.jsp?product_id=<%= product_id %>";
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
%>
        <script>
            alert("오류 발생: <%= e.getMessage() %>");
            history.back();
        </script>
<%
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
