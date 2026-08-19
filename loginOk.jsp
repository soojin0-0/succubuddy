<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>로그인 처리</title>
</head>
<body>

<%
    String DB_URL = "jdbc:mysql://localhost:3306/succu"; // DB 연결 정보
    String DB_ID = "multi"; 
    String DB_PASSWORD = "abcd";

    Class.forName("org.gjt.mm.mysql.Driver");  
    Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

    String id = request.getParameter("id");
    String pass = request.getParameter("pass");

    String jsql = "SELECT * FROM user WHERE user_id = ?"; // user 테이블에서 ID 조회
    PreparedStatement pstmt = con.prepareStatement(jsql);
    pstmt.setString(1, id);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) { // 입력한 ID가 DB에 존재하는 경우
        if (pass.equals(rs.getString("password"))) { // 비밀번호 확인
            session.setAttribute("sid", id); // 로그인 성공 → 세션 저장
            response.sendRedirect("main.jsp"); // 메인 페이지로 이동
        } else { // 비밀번호가 틀린 경우
%>
            <script>
                alert("[아이디 또는 비밀번호가 일치하지 않습니다]"); 
                history.back(); // 이전 페이지로 이동
            </script>
<%
        }
    } else { // ID가 존재하지 않는 경우
%>
        <script>
            alert("[아이디 또는 비밀번호가 일치하지 않습니다]"); 
            history.back(); // 이전 페이지로 이동
        </script>
<%
    }
    rs.close();
    pstmt.close();
    con.close();
%>

</body>
</html>
