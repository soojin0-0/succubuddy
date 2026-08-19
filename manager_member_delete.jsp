<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("euc-kr");

    String userId = request.getParameter("user_id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/succu?characterEncoding=EUC-KR",
            "multi",
            "abcd"
        );

        // 진짜 삭제할 경우 → delete 사용
        // String sql = "DELETE FROM user WHERE user_id = ?";

        // 보통은 delete 말고 상태값 업데이트 많이 씀 (예: status 컬럼이 있으면 '탈퇴'로 변경)
        // 지금은 delete 예시로 진행할게:

        String sql = "DELETE FROM user WHERE user_id = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);

        int result = pstmt.executeUpdate();

        pstmt.close();
        conn.close();

        if (result > 0) {
%>
    <script>
        alert("회원이 정상적으로 탈퇴되었습니다.");
        location.href = "manager_member.jsp";
    </script>
<%
        } else {
%>
    <script>
        alert("회원 탈퇴에 실패했습니다.");
        location.href = "manager_member.jsp";
    </script>
<%
        }

    } catch(Exception e) {
        e.printStackTrace();
%>
    <script>
        alert("오류가 발생했습니다.");
        location.href = "manager_member.jsp";
    </script>
<%
    }
%>
