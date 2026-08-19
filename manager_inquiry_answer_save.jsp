<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("euc-kr");

    String inquiryId = request.getParameter("inquiry_id");
    String managerAnswer = request.getParameter("manager_answer");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR",
            "multi",
            "abcd"
        );

        String sql = "UPDATE inquiry SET manager_answer = ?, status = '답변완료' WHERE inquiry_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, managerAnswer);
        pstmt.setInt(2, Integer.parseInt(inquiryId));

        int result = pstmt.executeUpdate();

        pstmt.close();
        conn.close();

        if (result > 0) {
%>
    <script>
        alert("답변이 정상적으로 저장되었습니다.");
        location.href = "manager_inquiry.jsp";
    </script>
<%
        } else {
%>
    <script>
        alert("답변 저장에 실패했습니다.");
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
