<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("euc-kr");
    String detailId = request.getParameter("detail_id");
    String newStatus = request.getParameter("status");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR", "multi", "abcd");

        // detail_id 기준으로 상태 수정
        String updateSql = "UPDATE order_detail SET status = ? WHERE detail_id = ?";
        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, newStatus);
        pstmt.setString(2, detailId);

        pstmt.executeUpdate();

        // 처리 후 관리자 페이지로 리다이렉트
        response.sendRedirect("manager_order.jsp");

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
