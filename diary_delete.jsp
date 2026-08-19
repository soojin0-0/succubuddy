<%@ page contentType="text/plain; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("euc-kr");

String diaryId = request.getParameter("diary_id");
if (diaryId == null || !diaryId.matches("\\d+")) {
    out.print("유효하지 않은 요청입니다.");
    return;
}

Connection conn = null;
PreparedStatement ps = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr", 
        "multi", 
        "abcd"
    );

    String sql = "DELETE FROM diary WHERE diary_id = ?";
    ps = conn.prepareStatement(sql);
    ps.setInt(1, Integer.parseInt(diaryId));  // 숫자값으로 확실하게 바인딩

    int result = ps.executeUpdate();

    if (result > 0) {
        out.print("SUCCESS");
    } else {
        out.print("삭제할 데이터가 없습니다.");
    }

} catch (Exception e) {
    out.print("오류 발생: " + new String(e.getMessage().getBytes("8859_1"), "euc-kr"));
} finally {
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>
