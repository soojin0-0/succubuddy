<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<%
    request.setCharacterEncoding("euc-kr");

    // 세션에서 현재 로그인된 사용자 ID 가져오기
    String userId = (String) session.getAttribute("sid");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        String DB_URL = "jdbc:mysql://localhost:3306/succu";
        String DB_ID = "multi";
        String DB_PASSWORD = "abcd";

        Class.forName("org.gjt.mm.mysql.Driver");
        Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        // 회원 정보 삭제 쿼리 실행
        String sql = "DELETE FROM user WHERE user_id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userId);

        int result = pstmt.executeUpdate();

        pstmt.close();
        con.close();

        if (result > 0) {
            // 회원 탈퇴 후 세션 종료
            session.invalidate();
%>
            <script>
                alert("[회원 탈퇴가 완료되었습니다]");
                window.location.href = "main.html"; // 탈퇴 후 메인 페이지로 이동
            </script>
<%
        } else {
%>
            <script>
                alert("[탈퇴에 실패했습니다. 다시 시도해주세요]");
                window.history.back();
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류 발생: " + e.getMessage());
    }
%>
